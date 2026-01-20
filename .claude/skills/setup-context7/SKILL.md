---
name: setup-context7
description: Set up Context7 MCP for up-to-date library documentation in Claude Code prompts.
---

# Setup Context7 MCP

Context7 MCP dynamically fetches up-to-date, version-specific documentation and code examples from official sources and injects them directly into your Claude Code prompts.

**Why use Context7?** LLMs have stale training data. When you're working with Next.js 15, React 19, or any library that's evolved since the model's cutoff date, you get hallucinated APIs and deprecated patterns. Context7 fixes this.

---

## Step 1: Choose Installation Method

Ask the user which installation method they prefer:

| Method | Pros | Cons |
|--------|------|------|
| **Remote with OAuth** | No API key needed, easy setup | Requires one-time browser auth |
| **Remote with API Key** | No local deps, fast | Need to get API key from context7.com |
| **Remote without auth** | Simplest setup | Rate limited |
| **Local** | Full control, no rate limits | Requires Node.js 18+ |

---

## Step 2: Install Based on Choice

### Option A: Remote Server with OAuth (Recommended)

```bash
claude mcp add --transport http context7 https://mcp.context7.com/mcp/oauth
```

Then tell the user:
"Run `/mcp` in Claude Code, select Context7, and click 'Authenticate' to complete the OAuth flow. Tokens are stored securely and refresh automatically."

### Option B: Remote Server with API Key

First, tell the user to get an API key from https://context7.com

Then run:
```bash
claude mcp add --header "CONTEXT7_API_KEY: YOUR_API_KEY" --transport http context7 https://mcp.context7.com/mcp
```

Replace `YOUR_API_KEY` with their actual key.

### Option C: Remote Server without Auth

```bash
claude mcp add --transport http context7 https://mcp.context7.com/mcp
```

Note: This has rate limits but works for light usage.

### Option D: Local Server

Requires Node.js 18+.

Without API key:
```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp
```

With API key:
```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp --api-key YOUR_API_KEY
```

---

## Step 3: Verify Installation

```bash
claude mcp list | grep context7
```

Should show `context7` in the list.

Or run `/mcp` inside Claude Code to see all configured servers.

---

## Step 4: Show Usage Examples

Tell the user how to use Context7:

**Basic usage** - Add "use context7" to any prompt:
```
use context7 to help me set up Next.js App Router
```

**Specific library** - Use library IDs directly:
```
use context7 with /vercel/next.js for app router setup
use context7 with /facebook/react for hooks documentation
use context7 with /prisma/prisma for database queries
```

**Available tools Context7 provides:**
- `resolve-library-id` - Finds the Context7 library ID for a package
- `query-docs` - Fetches documentation for a specific library

---

## Troubleshooting

**"Context7 not responding"**
- Check if MCP is running: `claude mcp list`
- Try restarting Claude Code

**"Rate limited"**
- Sign up for an API key at https://context7.com
- Or use the OAuth method for higher limits

**"Authentication failed"**
- Run `/mcp` in Claude Code
- Select Context7 and re-authenticate

---

## Quick Reference

| Command | Description |
|---------|-------------|
| `claude mcp list` | List all MCP servers |
| `claude mcp remove context7` | Remove Context7 |
| `/mcp` | Manage MCP servers in Claude Code |

---

## Links

- GitHub: https://github.com/upstash/context7
- Documentation: https://context7.com/docs
- Get API Key: https://context7.com
