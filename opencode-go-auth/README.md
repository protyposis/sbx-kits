# opencode-go-auth

**Kind:** mixin

Wires up [OpenCode Go](https://opencode.ai) authentication via the Docker sandbox proxy. The proxy intercepts outbound requests to `opencode.ai`, replaces the `Authorization` header with the real API key before forwarding, and the resolved value is injected into OpenCode's `auth.json` at startup — no manual `/connect` step required.

## How it works

1. The host-side secret `opencode-go` is forwarded into the sandbox as `OPENCODE_GO_API_KEY` via `proxyManaged`.
2. A startup command writes the key to `~/.local/share/opencode/auth.json` as an `api` credential for the `opencode-go` provider.
3. `network.serviceDomains` routes `opencode.ai` traffic through the proxy service, and `serviceAuth` stamps the `Authorization: Bearer <key>` header on each request.

## Usage

### 1. Provide your API key

Either store it as a named secret:

```bash
sbx secret set -g opencode-go
```

Or export it as an environment variable in your shell before running `sbx`:

```bash
export OPENCODE_GO_API_KEY=<your-key>
```

Both are equivalent — the credentials resolver checks host env vars as well as the secret store.

### 2. Apply the mixin

```bash
sbx run opencode --kit "git+https://github.com/protyposis/sbx-kits.git#dir=opencode-go-auth" ~/my-project
```

Stack with other kits as needed:

```bash
sbx run opencode \
  --kit "git+https://github.com/protyposis/sbx-kits.git#dir=opencode-go-auth" \
  --kit "git+https://github.com/protyposis/sbx-kits.git#dir=opencode-omo" \
  ~/my-project
```

OpenCode will have the `opencode-go` provider available immediately on startup.
