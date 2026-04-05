#!/bin/bash
# Usage: call_gemini.sh "your prompt here"
# Calls gemini -p in headless mode and returns the response text.
# Gemini internally uses google_web_search + thinking + flash sub-agent.

prompt="$1"

if [ -z "$prompt" ]; then
  echo "Error: no prompt provided" >&2
  exit 1
fi

result=$(gemini -p "$prompt" --output-format json 2>/dev/null)

if [ $? -ne 0 ] || [ -z "$result" ]; then
  echo "[Gemini unavailable]"
  exit 0
fi

echo "$result" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('response', '[no response]'))
except Exception as e:
    print('[Gemini parse error]')
"
