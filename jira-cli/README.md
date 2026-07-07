# jira-cli

**Kind:** mixin

Installs [jira-cli](https://github.com/ankitpokhrel/jira-cli) (`jira` command) from source via the Go toolchain. Authenticates against Jira Data Center / self-hosted Jira with a bearer API token injected by the sandbox proxy.

## Configuration

| Variable | Default | Description |
|---|---|---|
| `JIRA_AUTH_TYPE` | `bearer` | Auth mode. Fixed by the kit to use API token bearer auth. |
| `JIRA_API_TOKEN` | _(secret, required)_ | Jira API token bound to your Jira host. Proxy-injected — never visible in plain environment. |

## Usage

### 1. Provide your Jira API token

```bash
sbx secret set-custom -g --host <yourjirahost> --env JIRA_API_TOKEN
```

### 2. Apply the mixin

```bash
sbx run opencode --kit "git+https://github.com/protyposis/sbx-kits.git#dir=jira-cli" ~/my-project
```

### 3. Initialise the CLI inside the sandbox

Run once to write the local config (replacing placeholders with your Jira host and username):

```bash
jira init --installation local --server <yourjirahost> --auth-type bearer --login <yourjirauser>
```

`jira` is then ready to use, e.g. `jira issue list`, `jira sprint list`, `jira issue view <KEY>`, `jira issue create`.