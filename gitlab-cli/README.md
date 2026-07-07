# gitlab-cli

**Kind:** mixin

Installs [glab](https://gitlab.com/gitlab-org/cli), the official GitLab CLI. Configures the target GitLab host for `glab` and wires `GITLAB_TOKEN` as a proxy-managed secret so authenticated `glab` commands work immediately.

## Configuration

| Variable | Default | Description |
|---|---|---|
| `GITLAB_TOKEN` | _(secret)_ | A GitLab personal access token with at least `api` scope. Proxy-managed — never exposed in plain environment. |
| Target GitLab host | `gitlab.com` | The GitLab instance `glab` targets. Auto-detected from the workspace git origin when possible; otherwise set with `glab config set host`. |

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

On each sandbox start, if the workspace is a Git repository with a remote named `origin` pointing to a self-managed GitLab instance, the host is written to glab's global config automatically. No action is required.

If detection is not possible — for example because the workspace is not a Git repository, has no `origin` remote, or the origin is on a different host than the GitLab instance you want to use — set the host permanently in glab's config:

```bash
sbx exec <sandbox> -- glab config set host https://git.example.com --global
```

This persists across sandbox restarts. The kit respects any host already present in glab config and skips auto-detection, so set it before starting the sandbox to take precedence.
