---
description: Force exit from stop hook loop (escape hatch)
---

# Force Stop

Emergency escape hatch when the stop hook is looping and you need to exit.

**Arguments:** $ARGUMENTS

## Instructions

### Step 1: Create Exit Flag

Create the exit flag file that the stop hook will honor:

```bash
mkdir -p .claude
touch .claude/backlog-exit
```

### Step 2: Output Promise

Output the following (the stop hook will see this and allow exit):

```
<promise>BLOCKED: user_forced_stop</promise>
```

Do not output anything else after the promise tag.
