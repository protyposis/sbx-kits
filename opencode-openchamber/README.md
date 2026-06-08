# opencode-openchamber

**Kind:** sandbox

Runs [OpenCode](https://opencode.ai) as the primary TUI/server and starts [OpenChamber](https://github.com/openchamber/openchamber) as a background web UI once OpenCode is ready. OpenChamber binds to all LAN interfaces so it can be reached via a published host port.

## Ports

| Service | In-container port | Variable |
|---|---|---|
| OpenCode server | 4096 | `OPENCODE_PORT` |
| OpenChamber web UI | 3000 | `OPENCHAMBER_PORT` |

## Usage

```bash
# Create the sandbox
sbx run opencode-openchamber --kit "git+https://github.com/protyposis/sbx-kits.git#dir=opencode-openchamber" ~/my-project

# Publish the OpenChamber port so you can open it in a browser
sbx ports <sandbox-name> --publish 3000:3000
```

Then open `http://localhost:3000` in your browser.
