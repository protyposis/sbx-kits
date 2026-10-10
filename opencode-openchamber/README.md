# opencode-openchamber

**Kind:** sandbox

Starts [OpenChamber](https://github.com/openchamber/openchamber) first. OpenChamber launches and manages the [OpenCode](https://opencode.ai) server, and the OpenCode TUI attaches to it. Because OpenChamber owns the server, it can update and restart OpenCode without ending the session: the TUI reconnects on its own. OpenChamber binds to all LAN interfaces so it can be reached via a published host port.

Sandbox setup installs the latest OpenCode v2 (OpenChamber needs 2.0.20 or newer). Quitting the TUI stops OpenChamber and OpenCode.

## Ports

| Service | In-container port | Variable |
|---|---|---|
| OpenCode server (managed by OpenChamber) | 4096 | `OPENCODE_PORT` |
| OpenChamber web UI | 3000 | `OPENCHAMBER_PORT` |

## Usage

```bash
# Create the sandbox
sbx run opencode-openchamber --kit "git+https://github.com/protyposis/sbx-kits.git#dir=opencode-openchamber" ~/my-project

# Publish the OpenChamber port so you can open it in a browser
sbx ports <sandbox-name> --publish 3000:3000
```

Then open `http://localhost:3000` in your browser.
