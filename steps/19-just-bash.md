---
title: just-bash - Sandboxed Bash for AI Agents
time_estimate: 1 min
required: false
recommended: true
dependencies:
  - "05"
tags:
  - quick
---

# Step 19: just-bash - Sandboxed Bash for AI Agents

just-bash is a virtual bash environment with an in-memory filesystem, written in TypeScript and designed for AI agents. It lets you run bash commands in a sandboxed environment without touching the real filesystem.

**Time estimate: ~1 minute**
**Type: RECOMMENDED** - Safe sandboxed execution for AI agent workflows

---

## Why This Matters

When building AI agents or tools that need to execute shell commands, you don't always want those commands hitting your real filesystem. just-bash gives you:

- **Full bash syntax** - Pipes, redirects, loops, functions, variables, globs
- **In-memory filesystem** - Reads and writes stay sandboxed by default
- **100+ Unix commands** - cat, grep, sed, awk, jq, find, curl, and more
- **Optional runtimes** - Python (CPython WASM), JavaScript/TypeScript (QuickJS), SQLite
- **Multiple filesystem modes** - InMemory, Overlay (copy-on-write), ReadWrite, Mountable
- **Custom commands** - Extend with your own TypeScript commands via `defineCommand`
- **AI SDK integration** - Works as a tool via the companion `bash-tool` package

---

## What We're Installing

**just-bash** - A virtual bash environment for TypeScript/JavaScript projects.

GitHub: https://github.com/vercel-labs/just-bash

---

## Step 1: Check If Already Installed

```bash
npm list just-bash 2>/dev/null && echo "just-bash: installed" || echo "Not installed globally (install per-project)"
```

just-bash is typically installed per-project, not globally.

---

## Step 2: Install just-bash

**In any Node.js project:**

```bash
npm install just-bash
```

**For AI SDK integration (optional):**

```bash
npm install bash-tool
```

**Try it with the CLI (no project needed):**

```bash
npx just-bash -c 'echo "Hello from the sandbox!" && ls -la'
```

---

## Step 3: Quick Test

Create a quick test script:

```bash
cat << 'EOF' > /tmp/test-just-bash.mjs
import { Bash } from "just-bash";

const bash = new Bash();

// Write a file in the sandbox
await bash.exec('echo "Hello World" > greeting.txt');

// Read it back
const result = await bash.exec("cat greeting.txt");
console.log("stdout:", result.stdout);
console.log("exit code:", result.exitCode);

// Pipes and text processing work
const pipe = await bash.exec('echo "apple\nbanana\ncherry" | grep an | sort');
console.log("pipe result:", pipe.stdout);

// jq works too
const jq = await bash.exec('echo \'{"name":"lazy-agent"}\' | jq .name');
console.log("jq result:", jq.stdout);

console.log("✅ just-bash is working!");
EOF
node /tmp/test-just-bash.mjs
```

---

## Step 4: Key Features

### In-Memory Filesystem (Default)

```typescript
import { Bash } from "just-bash";

const bash = new Bash({
  files: { "/data/config.json": '{"key": "value"}' },
  env: { MY_VAR: "hello" },
});

await bash.exec("cat /data/config.json | jq .");
await bash.exec("echo $MY_VAR");
```

### Overlay Filesystem (Read from disk, write to memory)

```typescript
import { Bash } from "just-bash";
import { OverlayFs } from "just-bash/fs/overlay-fs";

const overlay = new OverlayFs({ root: "/path/to/project" });
const bash = new Bash({ fs: overlay, cwd: overlay.getMountPoint() });

await bash.exec("cat package.json");           // reads from disk
await bash.exec('echo "modified" > file.txt'); // stays in memory
```

### Custom Commands

```typescript
import { Bash, defineCommand } from "just-bash";

const hello = defineCommand("hello", async (args, ctx) => {
  return { stdout: `Hello, ${args[0] || "world"}!\n`, stderr: "", exitCode: 0 };
});

const bash = new Bash({ customCommands: [hello] });
await bash.exec("hello Alice"); // "Hello, Alice!\n"
```

### AI SDK Tool Integration

```typescript
import { createBashTool } from "bash-tool";
import { generateText } from "ai";

const bashTool = createBashTool({
  files: { "/data/users.json": '[{"name": "Alice"}, {"name": "Bob"}]' },
});

const result = await generateText({
  model: "anthropic/claude-sonnet-4",
  tools: { bash: bashTool },
  prompt: "Count the users in /data/users.json",
});
```

---

## Commands Reference

### Supported Unix Commands

| Category | Commands |
|----------|----------|
| File Ops | `cat`, `cp`, `ln`, `ls`, `mkdir`, `mv`, `rm`, `stat`, `touch`, `tree` |
| Text | `awk`, `cut`, `diff`, `grep`, `head`, `sed`, `sort`, `tail`, `tr`, `uniq`, `wc` |
| Data | `jq` (JSON), `sqlite3`, `xan` (CSV), `yq` (YAML/XML) |
| Network | `curl`, `html-to-markdown` (when network enabled) |
| Runtimes | `python3` (opt-in), `js-exec` (opt-in) |

### Shell Features

- Pipes: `cmd1 | cmd2`
- Redirections: `>`, `>>`, `2>`, `2>&1`, `<`
- Chaining: `&&`, `||`, `;`
- Variables, functions, loops, if statements, globs

---

## Troubleshooting

### Module not found?

Make sure you're using ESM (`"type": "module"` in package.json) or `.mjs` extension:

```json
{ "type": "module" }
```

### Network commands not available?

`curl` requires explicit network configuration:

```typescript
const bash = new Bash({
  network: { dangerouslyAllowFullInternetAccess: true },
});
```

---

## Success!

You now have a sandboxed bash environment for building AI agents and tools. Files stay in memory, commands are safe to run, and you get the full power of bash without the risk.

---

## Next Steps

- Use just-bash in your AI agent projects for safe command execution
- Check out the `bash-tool` package for AI SDK integration
- Explore OverlayFs for read-only access to real project files
- See the full docs: https://github.com/vercel-labs/just-bash
