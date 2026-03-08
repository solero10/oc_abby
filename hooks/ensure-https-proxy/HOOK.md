---
name: ensure-https-proxy
description: "Ensure HTTPS tunnel proxy is running on gateway startup"
metadata:
  {
    "openclaw":
      {
        "emoji": "🔐",
        "events": ["gateway:startup"],
        "requires": { "bins": ["python3"], "config": ["workspace.dir"] },
      },
  }
---

# Ensure HTTPS Proxy

Starts the local HTTPS tunnel proxy (`https_tunnel.py`) on gateway startup if port `18443` is not already listening.
