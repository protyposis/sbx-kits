# sonarqube-cli

**Kind:** mixin

Installs the [SonarQube CLI](https://github.com/SonarSource/sonarqube-cli) (`sonar` command) from SonarSource. Configures environment variable-based authentication for SonarQube Cloud or a self-hosted SonarQube Server instance.

## Configuration

| Variable | Default | Description |
|---|---|---|
| `SONARQUBE_CLI_TOKEN` | _(secret, required)_ | SonarQube user token. Generate from SonarQube → My Account → Security → Generate Tokens. |
| `SONARQUBE_CLI_SERVER` | _(empty)_ | SonarQube server URL. Required for self-hosted. Set to `https://sonarqube.us` for SonarQube Cloud US. |
| `SONARQUBE_CLI_ORG` | _(empty)_ | SonarQube Cloud organization key. Required for SonarQube Cloud only. |

## Usage

### SonarQube Cloud (sonarcloud.io)

```bash
# 1. Store your token (prompts interactively)
sbx secret set-custom -g --env SONARQUBE_CLI_TOKEN --host "sonarsource.io"

# 2. Store your organization key or self-hosted server
sbx secret set-custom -g --env SONARQUBE_CLI_ORG --value "irrelevant" --host "irrelevant" --placeholder "your-org-key"

# 3. Run the sandbox
sbx run opencode --kit "git+https://github.com/protyposis/sbx-kits.git#dir=sonarqube-cli" ~/my-project
```

### Self-hosted SonarQube Server

```bash
# 1. Store your token
sbx secret set-custom -g --env SONARQUBE_CLI_TOKEN --host <your-sonar-host>

# 2. Store your server URL
sbx secret set-custom -g --env SONARQUBE_CLI_SERVER --value "irrelevant" --host "irrelevant" --placeholder "https://sonar.mydomain.com/"

# 3. Run the sandbox
sbx run opencode --kit "git+https://github.com/protyposis/sbx-kits.git#dir=sonarqube-cli" ~/my-project
```

## Telemetry

Telemetry is disabled by default (`DO_NOT_TRACK=1` is set in the kit spec). To re-enable, run `sonar config telemetry --enabled` inside the sandbox or override the variable:

```bash
sbx run opencode --env DO_NOT_TRACK=0 --kit "git+https://github.com/protyposis/sbx-kits.git#dir=sonarqube-cli" ~/my-project
```
