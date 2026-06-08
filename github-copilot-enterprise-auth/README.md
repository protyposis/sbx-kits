# github-copilot-enterprise-auth

A mixin that extends the built-in GitHub Copilot token auth to cover GitHub
Copilot Enterprise accounts.

The sandbox proxy already manages a GitHub token for the standard Copilot
endpoints. This mixin tags `api.enterprise.githubcopilot.com` with the same
`github` service identity, so the proxy forwards that token to enterprise
endpoints as well — no extra credentials or configuration needed.

## Usage

```bash
sbx run copilot \
  --kit "git+https://github.com/protyposis/sbx-kits.git#dir=github-copilot-enterprise-auth" \
  ~/my-project
```
