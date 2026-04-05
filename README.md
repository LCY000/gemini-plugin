# gemini-plugin

A Claude Code plugin that adds a Gemini sub-agent with live Google Search grounding. Runs on your own Google account — completely independent of Claude's token budget.

## What it does

- Triggers automatically for information queries: facts, current events, research, comparisons, prices, news, etc.
- Uses `gemini-2.5-pro` with thinking + `google_web_search` internally
- Falls back to Claude's WebSearch only when Gemini's result is insufficient or citable sources are needed

## Prerequisites

1. Install Gemini CLI:
   ```bash
   npm install -g @google/gemini-cli
   ```

2. Log in with your Google account:
   ```bash
   gemini
   ```
   (Follow the auth flow on first launch)

3. Verify it works:
   ```bash
   gemini -p "hello"
   ```

> **Note:** The skill assumes Gemini CLI is at `/opt/homebrew/bin/gemini` (Homebrew on macOS).  
> If your path differs, edit `skills/gemini/scripts/call_gemini.sh` after installing.

## Installation

```bash
/plugin marketplace add LCY000/gemini-plugin
/plugin install gemini@LCY000
```

## Usage

Once installed, Claude will automatically use Gemini for information queries. No manual invocation needed.

You can also invoke it explicitly:

```
/gemini:gemini
```

## How it works

Claude runs the Gemini CLI as a background process. When the result is ready, Claude reads the output and incorporates it into the response. This keeps your Claude token budget free for reasoning and code tasks.
