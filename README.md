# sbx-kits

A collection of [Docker Sandbox](https://docs.docker.com/ai/sandboxes/) [kits](https://docs.docker.com/ai/sandboxes/customize/kits/). Each subdirectory is a self-contained kit that can be used independently or composed together.

## Kits

| Directory | Kind | Purpose |
|---|---|---|
| [`opencode-openchamber/`](./opencode-openchamber/) | sandbox | OpenCode TUI + OpenChamber web UI side-car |
| [`opencode-omo/`](./opencode-omo/) | mixin | Oh My OpenAgent with OpenAI and OpenCode Go providers |
| [`opencode-go-auth/`](./opencode-go-auth/) | mixin | Proxy-managed OpenCode Go API key injection |
| [`gitlab-cli/`](./gitlab-cli/) | mixin | GitLab CLI (glab) with proxy-managed token |
| [`traffic-inspection-ca/`](./traffic-inspection-ca/) | mixin | Install corporate CA certificate for TLS inspection (e.g., ZScaler) |
| [`github-copilot-enterprise-auth/`](./github-copilot-enterprise-auth/) | mixin | Extend built-in GitHub token auth to Copilot Enterprise endpoints |

## Quick start

### OpenCode + OpenChamber (sandbox)

```bash
sbx run opencode-openchamber --kit "git+https://github.com/protyposis/sbx-kits.git#dir=opencode-openchamber" ~/my-project

# Expose the OpenChamber web UI in a browser
sbx ports <sandbox-name> --publish 3000:3000
```

### Oh My OpenAgent (mixin)

```bash
sbx run opencode --kit "git+https://github.com/protyposis/sbx-kits.git#dir=opencode-omo" ~/my-project
```

### OpenCode Go authentication (mixin)

```bash
# Store your API key once on the host
sbx secret set -g opencode-go

sbx run opencode --kit "git+https://github.com/protyposis/sbx-kits.git#dir=opencode-go-auth" ~/my-project
```

### Composing kits

Kits can be stacked with multiple `--kit` flags:

```bash
sbx secret set -g opencode-go

sbx run opencode \
  --kit "git+https://github.com/protyposis/sbx-kits.git#dir=opencode-go-auth" \
  --kit "git+https://github.com/protyposis/sbx-kits.git#dir=opencode-omo" \
  ~/my-project
```

## Troubleshooting

### `ERROR: failed to create agent sandbox: agent "opencode-openchamber" not found`

The kit must also be specified when running an existing sandbox, i.e., `sbx run --kit "git+https://github.com/protyposis/sbx-kits.git#dir=opencode-openchamber" <sandbox-name>` instead of `sbx run opencode-openchamber-myproject`.
