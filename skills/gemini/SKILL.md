---
name: gemini
description: >
  Parallel sub-agent backed by Gemini CLI with live Google Search grounding.
  Free of Claude's quota — default to calling it, don't deliberate.

  TRIGGER for anything with an information dimension: facts, current events, research,
  comparisons, versions, prices, news, trends, analysis, verification, "what's the latest",
  "is X still true". Even routine questions may have recent developments worth catching.

  Default is Gemini-only. Claude's own WebSearch only when explicitly needed for
  citable sources or when Gemini's result is insufficient. Skip for pure file edits,
  git ops, mechanical code changes.
---

# Gemini Sub-Agent

Gemini CLI at `/opt/homebrew/bin/gemini`. Runs on the user's Google account — independent
of Claude's token budget. Internally uses `gemini-3.1-pro-preview` with thinking,
`google_web_search`, and a Flash sub-agent. One call = a full agentic pipeline.

## Calling Gemini

```bash
bash ~/.claude/skills/gemini/scripts/call_gemini.sh "your prompt"
```

Always `run_in_background: true`. Launch it first, then do your own work in parallel.
If no result after ~45s, proceed without it.

---

## Decision flow

```
Info query?
  └─ Yes → Gemini only (default)
            └─ Result sufficient? → Done
            └─ Result thin / off-target?
                  ├─ Refine prompt → call Gemini again
                  └─ Need citable URLs → add targeted WebSearch
  └─ No (pure code/file/git) → Skip
```

**Claude's own WebSearch is a fallback, not a default.**
Only reach for it when:
- Gemini returned vague, outdated, or clearly wrong results
- The user explicitly needs source URLs to cite
- The topic requires deep cross-validated research (user asked to 研究/分析/做報告)

For everything else — single questions, current events, facts, prices, comparisons —
Gemini alone is enough. Don't run WebSearch in parallel "just in case".

---

## Calling Gemini a second time

If the first result misses the mark, don't switch to WebSearch by default — try Gemini
again with a better prompt first. Common fixes:

- Add the exact date and user context it was missing
- Use more precise terminology (學年度 not 年份, exact version numbers, proper nouns)
- Narrow or redirect the focus ("ignore X, focus only on Y")

A second Gemini call is cheaper and often sufficient.

---

## Research mode (both in parallel)

Only when the user explicitly asks for comprehensive research, analysis, or a report —
and needs citable sources alongside breadth/recency.

1. Launch Gemini in background with research framing
2. Run WebSearch in parallel (3–5 targeted queries)
3. Synthesize: Gemini covers recency/breadth, WebSearch covers citable URLs

**Gemini framing for research:**
> "Claude is covering citable sources. You focus on: past 6 months news, real-world
> adoption, community sentiment, practitioner opinions."

---

## Writing Gemini prompts

Before calling Gemini, transfer everything you already understand — current date,
user's situation, precise terms, what's already known. Gemini should start with
the same picture you have, not reconstruct it from scratch.

Beyond that, just ask for what you need. No rigid template.
