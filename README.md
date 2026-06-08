# OpenCode + OpenChamber Docker Sandbox Kit

This version fixes the stale initial artifact:

- OpenChamber is **not** started before OpenCode is available.

## Run

```bash
sbx run opencode-openchamber --kit ./opencode-openchamber-kit ~/my-project
```

## Startup order

The wrapper starts a background watcher, then immediately execs the foreground OpenCode TUI:

```bash
start_openchamber_after_opencode_ready &
exec opencode --hostname "$OPENCODE_HOSTNAME" --port "$OPENCODE_PORT" "$@"
```

The watcher waits for the fixed OpenCode port to be reachable, then starts OpenChamber:

```bash
openchamber --lan --port "$OPENCHAMBER_PORT"
```

## Fixed ports

```text
OPENCODE_HOSTNAME=127.0.0.1
OPENCODE_PORT=4096
OPENCHAMBER_PORT=3000
OPENCHAMBER_OPENCODE_HOSTNAME=127.0.0.1
OPENCHAMBER_OPENCODE_PORT=4096
```

## OpenCode Go authentication

The kit uses the Docker sandbox proxy to inject the OpenCode Go API key. Store the key on the host before launching the sandbox:

```bash
sbx secret set -g opencode-go
```

The `opencode-go` provider will be available
immediately inside OpenCode without any `/connect` step.

## Oh My OpenAgent

The installer is run with ChatGPT/OpenAI and OpenCode Go enabled:

```bash
bunx oh-my-openagent install \
  --no-tui \
  --platform=opencode \
  --claude=no \
  --openai=yes \
  --gemini=no \
  --copilot=no \
  --opencode-zen=no \
  --zai-coding-plan=no \
  --opencode-go=yes \
  --kimi-for-coding=no \
  --vercel-ai-gateway=no \
  --skip-auth
```
