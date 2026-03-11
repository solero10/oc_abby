import { spawn } from "node:child_process";
import fs from "node:fs";
import net from "node:net";

const HOME = process.env.HOME || "/home/kernk";
const SCRIPT = `${HOME}/.openclaw/proxy/https_tunnel.py`;
const PORT = 18443;
const HOST = "127.0.0.1";

function isGatewayStartupEvent(event: any): boolean {
  return event?.type === "gateway" && event?.action === "startup";
}

function isListening(port: number, host: string, timeoutMs = 500): Promise<boolean> {
  return new Promise((resolve) => {
    const socket = new net.Socket();
    let settled = false;

    const done = (ok: boolean) => {
      if (settled) return;
      settled = true;
      try { socket.destroy(); } catch {}
      resolve(ok);
    };

    socket.setTimeout(timeoutMs);
    socket.once("connect", () => done(true));
    socket.once("timeout", () => done(false));
    socket.once("error", () => done(false));

    try {
      socket.connect(port, host);
    } catch {
      done(false);
    }
  });
}

async function ensureProxyUp(): Promise<void> {
  if (!fs.existsSync(SCRIPT)) {
    console.warn(`[ensure-https-proxy] script missing: ${SCRIPT}`);
    return;
  }

  const alreadyUp = await isListening(PORT, HOST);
  if (alreadyUp) {
    console.log("[ensure-https-proxy] proxy already listening on :18443");
    return;
  }

  const child = spawn("python3", [SCRIPT], {
    detached: true,
    stdio: "ignore",
  });
  child.unref();
  console.log("[ensure-https-proxy] started https_tunnel.py");
}

export default async function ensureHttpsProxyHook(event: any): Promise<void> {
  if (!isGatewayStartupEvent(event)) return;
  await ensureProxyUp();
}
