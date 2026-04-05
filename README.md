# gemini-plugin

A Claude Code skill (distributed as a plugin) that offloads information queries to a **Gemini sub-agent** — so Claude can answer with live Google Search results without burning your Claude Code token budget.

## Why use this?

Claude Code has a monthly usage quota. Every search query Claude runs costs tokens. This skill routes information queries to Gemini CLI instead, which runs on your own Google account for free. Claude's quota is preserved for what it's actually good at: reasoning, coding, and file editing.

## How it works

When you ask something with an information dimension — current events, prices, version numbers, comparisons, "is X still true" — Claude automatically delegates to Gemini in the background. Gemini runs its own agentic pipeline with Google Search, then hands the result back to Claude to synthesize.

### Three modes

**1. Standard (default)**  
Claude calls Gemini once in the background while it prepares the response. Covers the vast majority of queries.

```
You ask → Claude calls Gemini (background) → Gemini searches → Claude answers
```

**2. Retry with refined prompt**  
If the first result is thin or off-target, Claude retries Gemini with a better prompt before giving up — adding missing context, more precise terminology, or a narrower focus. A second Gemini call is cheaper than switching to WebSearch.

```
Result insufficient → Refine prompt → Call Gemini again → Done
```

**3. Research mode**  
Only when you explicitly ask for comprehensive research, a report, or need citable sources. Claude runs Gemini and its own WebSearch **in parallel** and synthesizes both.

```
You ask for 研究/分析/做報告 → Gemini (recency + breadth) + WebSearch (citable URLs) → Synthesized answer
```

Claude's own WebSearch is never used as a default — only as a fallback or for research mode.

---

## Prerequisites

1. Install Gemini CLI:
   ```bash
   npm install -g @google/gemini-cli
   ```

2. Log in with your Google account:
   ```bash
   gemini
   ```
   Follow the auth flow on first launch.

3. Verify it works:
   ```bash
   gemini -p "hello"
   ```

> **Path note:** The skill assumes Gemini CLI is at `/opt/homebrew/bin/gemini` (Homebrew on macOS).  
> If your path differs, edit `skills/gemini/scripts/call_gemini.sh` after installing.

### Recommended: set your model

The skill uses whatever model is configured as the default in Gemini CLI. To get the best results, open the Gemini CLI settings and set your preferred model:

```bash
gemini
```

Go to **Settings → Model**. Recommended options:
- `gemini-3.1-pro-preview` — most capable, best for complex research
- `gemini-3-flash-preview` — faster, good for quick lookups

The skill will use whichever model you set automatically.

---

## Installation

```bash
/plugin marketplace add LCY000/gemini-plugin
/plugin install gemini@LCY000
```

## Usage

No manual invocation needed. Once installed, Claude automatically uses Gemini whenever a query has an information dimension.

Skipped automatically for: file edits, git operations, mechanical code changes — anything where web search adds no value.
