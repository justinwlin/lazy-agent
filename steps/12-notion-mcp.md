# Step 12: Notion MCP [RECOMMENDED]

> **This step takes ~5 minutes.**
> 
> If the user's team uses Notion, this is highly recommended. Claude can then read and search Notion pages directly.

## What is Notion MCP?

MCP (Model Context Protocol) lets Claude Code interact with Notion directly:
- Search your Notion workspace
- Read page contents
- Find documentation quickly

## Step 1: Create a Notion Integration

1. Go to: https://www.notion.so/my-integrations
2. Click **"+ New integration"**
3. Fill in:
   - **Name**: `Claude Code`
   - **Associated workspace**: Select your workspace
   - **Type**: Internal
4. Click **Submit**
5. Copy the **Internal Integration Secret** (starts with `secret_`)

## Step 2: Share Pages with the Integration

For Claude to access a page, you must share it:

1. Open a Notion page you want Claude to access
2. Click **"..."** (top right) → **"Connections"**
3. Search for **"Claude Code"** (your integration)
4. Click **"Confirm"**

Repeat for any pages/databases you want Claude to read.

> **Tip:** Share a top-level page and all sub-pages inherit access.

## Step 3: Install Notion MCP Server

```bash
npm install -g @anthropic/mcp-server-notion
```

## Step 4: Configure Claude Code

Add the Notion MCP to your Claude config.

Create/edit `~/.config/claude-code/settings.json`:

```json
{
  "mcpServers": {
    "notion": {
      "command": "mcp-server-notion",
      "env": {
        "NOTION_API_KEY": "secret_xxxxx"
      }
    }
  }
}
```

Replace `secret_xxxxx` with your actual integration secret.

Or set as environment variable in `~/.zshrc.local`:
```bash
export NOTION_API_KEY="secret_xxxxx"
```

## Step 5: Restart Claude Code

Quit and restart Claude Code for the MCP to load.

## Step 6: Verify It Works

Ask Claude:
```
> search Notion for "onboarding"
> read my Notion page about project roadmap
```

## What You Can Do

- **Search**: "Find the API documentation in Notion"
- **Read**: "What does the architecture doc say about auth?"
- **Reference**: "Summarize the PRD in Notion"

## Troubleshooting

- **"Cannot access page"**: Share the page with your integration (Step 2)
- **"Integration not found"**: Check the API key is correct
- **"MCP not loaded"**: Restart Claude Code

## Links

- Notion Integrations: https://www.notion.so/my-integrations
- Notion API Docs: https://developers.notion.com
- MCP Docs: https://docs.anthropic.com/en/docs/claude-code/mcp
