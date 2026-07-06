# gitlab-cli

**Kind:** mixin

Installs [glab](https://gitlab.com/gitlab-org/cli), the official GitLab CLI. Configures `GITLAB_HOST` for the target GitLab instance and wires `GITLAB_TOKEN` as a proxy-managed secret so authenticated `glab` commands work immediately.

## Configuration

| Variable | Default | Description |
|---|---|---|
| `GITLAB_HOST` | `gitlab.com` | The GitLab instance host `glab` defaults to. Auto-detected from the workspace git origin when possible. |
| `GITLAB_TOKEN` | _(secret)_ | A GitLab personal access token with at least `api` scope. Proxy-managed — never exposed in plain environment. |

## Usage

### 1. Provide your GitLab token

```bash
sbx secret set-custom -g --host <GITLAB_HOST> --env GITLAB_TOKEN
```

### 2. Apply the mixin

```bash
sbx run opencode --kit "git+https://github.com/protyposis/sbx-kits.git#dir=gitlab-cli" ~/my-project
```

`glab` is available immediately — for example `glab issue list` or `glab mr create`.

## GitLab host detection

On each sandbox start, if the workspace is a Git repository with a remote named `origin` pointing to a self-managed GitLab instance, `GITLAB_HOST` is set automatically. No action is required.

If detection is not possible — for example because the workspace is not a Git repository, has no `origin` remote, or the origin is on a different host than the GitLab instance you want to use — set `GITLAB_HOST` permanently by appending it to `/etc/sandbox-persistent.sh`:

```bash
sbx exec <sandbox> -- bash -c "echo 'export GITLAB_HOST=git.example.com' >> /etc/sandbox-persistent.sh"
```

This persists across sandbox restarts. The kit respects any `GITLAB_HOST` already present in `/etc/sandbox-persistent.sh` and skips auto-detection, so set it before starting the sandbox to take precedence.
