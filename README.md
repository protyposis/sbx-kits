# sbx-kits

A collection of [Docker Sandbox](https://docs.docker.com/ai/sandboxes/) [kits](https://docs.docker.com/ai/sandboxes/customize/kits/). Each subdirectory is a self-contained kit that can be used independently or composed together.

## Kits

| Directory | Kind | Purpose |
|---|---|---|
| [`github-copilot-enterprise-auth/`](./github-copilot-enterprise-auth/) | mixin | Extend built-in GitHub token auth to Copilot Enterprise endpoints |
| [`gitlab-cli/`](./gitlab-cli/) | mixin | GitLab CLI (glab) with proxy-managed token |
| [`opencode-omo/`](./opencode-omo/) | mixin | Oh My OpenAgent with OpenAI and OpenCode Go providers |
| [`opencode-openchamber/`](./opencode-openchamber/) | sandbox | OpenCode TUI + OpenChamber web UI side-car |
| [`sonarqube-cli/`](./sonarqube-cli/) | mixin | SonarQube CLI (`sonar`) with env-var-based token authentication for Cloud and self-hosted |
| [`traffic-inspection-ca/`](./traffic-inspection-ca/) | mixin | Install corporate CA certificate for TLS inspection (e.g., ZScaler) |

## Quick start

### OpenCode + OpenChamber (sandbox)

```bash
sbx run opencode-openchamber --kit "git+https://github.com/protyposis/sbx-kits.git#dir=opencode-openchamber" ~/my-project

# Expose the OpenChamber web UI in a browser
sbx ports <sandbox-name> --publish 3000:3000
```

### Copilot on a corporate network with GitLab (mixin)

For environments with TLS traffic inspection (e.g., ZScaler), GitHub Copilot
Enterprise accounts, and GitLab access:

```bash
# Register the GitLab token once on the host (replace with your GitLab host)
sbx secret set-custom -g --host "gitlab.mycompany.com" --env GITLAB_TOKEN

sbx run copilot \
  --kit "git+https://github.com/protyposis/sbx-kits.git#dir=traffic-inspection-ca" \
  --kit "git+https://github.com/protyposis/sbx-kits.git#dir=github-copilot-enterprise-auth" \
  --kit "git+https://github.com/protyposis/sbx-kits.git#dir=gitlab-cli" \
  ~/my-project
```

Load `traffic-inspection-ca` first so the CA is trusted before the other kits
make outbound connections during install.

## Troubleshooting

### `ERROR: failed to create agent sandbox: agent "opencode-openchamber" not found`

The kit must also be specified when running an existing sandbox, i.e., `sbx run --kit "git+https://github.com/protyposis/sbx-kits.git#dir=opencode-openchamber" <sandbox-name>` instead of `sbx run opencode-openchamber-myproject`.
