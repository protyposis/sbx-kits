# gitlab-cli

**Kind:** mixin

Installs [glab](https://gitlab.com/gitlab-org/cli), the official GitLab CLI. Configures `GITLAB_HOST` for the target GitLab instance and wires `GITLAB_TOKEN` as a proxy-managed secret so authenticated `glab` commands work immediately.

## Configuration

| Variable | Default | Description |
|---|---|---|
| `GITLAB_HOST` | `gitlab.com` | The GitLab instance host `glab` defaults to. |
| `GITLAB_TOKEN` | _(secret)_ | A GitLab personal access token with at least `api` scope. Proxy-managed — never exposed in plain environment. |

## Usage

### 1. Provide your GitLab token

```bash
sbx secret set-custom -g --host <GITLAB_HOST> --env GITLAB_TOKEN
```

### 2. (Optional) Set a custom GitLab host

```bash
export GITLAB_HOST=gitlab.example.com
```

### 3. Apply the mixin

```bash
sbx run opencode --kit ./gitlab-cli ~/my-project
```

`glab` is available immediately — for example `glab issue list` or `glab mr create`.
