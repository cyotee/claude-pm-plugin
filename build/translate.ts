/**
 * translate.ts - Generate OpenCode-compatible files from Claude Code plugin sources
 *
 * Usage: npx tsx build/translate.ts
 *
 * TypeScript version of translate.sh for environments with Node.js.
 * Translates Claude Code plugin commands and agents into OpenCode format.
 */

import { readFileSync, writeFileSync, mkdirSync, readdirSync } from "fs";
import { join, basename } from "path";

const PLUGIN_ROOT = join(import.meta.dirname ?? __dirname, "..");
const OPENCODE_DIR = join(PLUGIN_ROOT, ".opencode");

// ─────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────

function extractFrontmatter(content: string): Record<string, string> {
  const match = content.match(/^---\n([\s\S]*?)\n---/);
  if (!match) return {};

  const fields: Record<string, string> = {};
  for (const line of match[1].split("\n")) {
    const colonIdx = line.indexOf(":");
    if (colonIdx > 0) {
      const key = line.slice(0, colonIdx).trim();
      const value = line.slice(colonIdx + 1).trim();
      fields[key] = value;
    }
  }
  return fields;
}

function extractBody(content: string): string {
  const parts = content.split("---");
  // parts[0] is empty (before first ---), parts[1] is frontmatter, rest is body
  if (parts.length < 3) return "";
  return parts.slice(2).join("---").trim();
}

function translateCommandRefs(text: string): string {
  return text
    .replace(/\/pm:/g, "/pm-")
    .replace(/\/design:/g, "/pm-")
    .replace(/\/backlog:/g, "/pm-");
}

function mapModel(model: string): string {
  switch (model) {
    case "sonnet":
      return "anthropic/claude-sonnet";
    case "haiku":
      return "anthropic/claude-haiku";
    case "opus":
      return "anthropic/claude-opus";
    default:
      return "anthropic/claude-sonnet";
  }
}

// ─────────────────────────────────────────────
// Translate
// ─────────────────────────────────────────────

mkdirSync(join(OPENCODE_DIR, "commands"), { recursive: true });
mkdirSync(join(OPENCODE_DIR, "agents"), { recursive: true });

// Commands
const cmdDir = join(PLUGIN_ROOT, "commands");
let cmdCount = 0;

for (const file of readdirSync(cmdDir).filter((f) => f.endsWith(".md"))) {
  const name = basename(file, ".md");
  const content = readFileSync(join(cmdDir, file), "utf-8");
  const fm = extractFrontmatter(content);

  if (!fm.description) {
    console.warn(`[translate] Skipping command ${name} (no description)`);
    continue;
  }

  const outName = name === "pm" ? "pm.md" : `pm-${name}.md`;
  const body = translateCommandRefs(extractBody(content));

  const output = `---\ndescription: ${fm.description}\n---\n\n${body}\n`;
  writeFileSync(join(OPENCODE_DIR, "commands", outName), output);
  cmdCount++;
  console.log(`[translate] Command: ${name} → ${outName}`);
}

// Agents
const agentDir = join(PLUGIN_ROOT, "agents");
let agentCount = 0;

for (const file of readdirSync(agentDir).filter((f) => f.endsWith(".md"))) {
  const name = basename(file, ".md");
  const content = readFileSync(join(agentDir, file), "utf-8");
  const fm = extractFrontmatter(content);

  if (!fm.description) {
    console.warn(`[translate] Skipping agent ${name} (no description)`);
    continue;
  }

  const body = translateCommandRefs(extractBody(content));
  const ocModel = mapModel(fm.model || "sonnet");

  const output = [
    "---",
    `description: ${fm.description}`,
    "mode: subagent",
    `model: ${ocModel}`,
    "tools:",
    "  read: true",
    "  glob: true",
    "  grep: true",
    "  bash: true",
    "  write: false",
    "  edit: false",
    "---",
    "",
    body,
    "",
  ].join("\n");

  writeFileSync(join(OPENCODE_DIR, "agents", `${name}.md`), output);
  agentCount++;
  console.log(`[translate] Agent: ${name}`);
}

console.log(
  `\n[translate] Done! Commands: ${cmdCount}, Agents: ${agentCount}`
);
