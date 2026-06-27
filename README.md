# GremDesk

A lightweight, local-first start page for fast navigation and launching personal workflows via a custom `gremdesk://` protocol.

---

## What it does

- Renders a top-bar menu from a JSON config
- Supports:
  - Normal URLs (`https://...`)
  - Local protocol actions (`gremdesk://...`)
  - JavaScript actions (`action`)
  - Copy-to-clipboard items (`data`)
- Random wallpaper loading (with optional admin mode wallpapers)
- Minimal by design: No accounts, no telemetry, no cloud dependencies

---

## Platform & Scope
- **OS:** Windows  
- **Browser:** Tested with Chrome & Firefox
- **Audience:** Power users who want a fast, local, customizable start page
- **Licence:** MIT (see LICENSE)

---

## Core files

- `index.html` — minimal page shell
- `style.css` — visual styling
- `core.js` — startup + config loading
- `ui.js` — menu rendering logic
- `wallpaper.js` — wallpaper selection + admin mode
- `modals.js` — shared modal behavior
- `links.example.json` — public example configuration

---

## Installation

1) Download or clone this repo.
2) Extract it to a folder on your machine, for example `C:\gremdesk`.
3) Install Gremdesk Server using one of the options below
4) Open GremDesk in your browser at `http://localhost:8080/`.
5) Once you are happy everything is working, rename `links.example.json` to `links.json` and customize your links.
6) Optional: set GremDesk as your browser home page or new tab page.
7) Optional: enable `gremdesk://` protocol support if you want GremDesk to launch local commands.

---

## Local Server Quick Install

GremDesk includes a PowerShell installer for common local setup.

The installer can:

- Register the optional `gremdesk://` protocol handler
- Add a startup shortcut so the local server starts when you log in
- Start the local server immediately

To use the menu installer, double-click:

```text
extras\gremdesk_Installer.bat
```

Or, from the root GremDesk folder, run the PowerShell installer directly:

```powershell
powershell -ExecutionPolicy Bypass -File ".\extras\install scripts\install.ps1"
```

The installer will ask before enabling optional components.

After the installer starts the server, open GremDesk in your browser:

```text
http://localhost:8080/
```

If you enable auto-start, GremDesk creates a shortcut named `GremDesk Server.lnk` in your Windows Startup folder:

```text
%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
```

To remove installed components later, run:

```powershell
powershell -ExecutionPolicy Bypass -File ".\extras\install scripts\uninstall.ps1"
```

You can also remove auto-start manually by deleting `GremDesk Server.lnk` from the Startup folder.


---

## Optional: YT-DLP Integration
Coming in a future release.

---

## Setting up a local server (Full Description)

## Basic Python Local Server Setup
1) Install Python 3.12.X
2) Run .\gremdesk\extras\gremdesk-server\gremdesk_server.py in PowerShell
3) Open in your browser. You should now see GremDesk running at http://localhost:8080/
4) If the issue persists, consult the troubleshooting section or open a ticket with the GremDesk GitHub. (AI assistants such as ChatGPT or Grok can often help diagnose Python or configuration issues.)


## Set this to run silently at boot
1) Open Windows Task Scheduler
2) Create a Task called `gremdesk server`
3) Tick Run with highest privileges
4) Configure for Windows 10
5) Triggers Tab > New... > Begin the task: `At log on`
6) Actions Tab > New... > Program: `wscript.exe`; Argument: `"C:\[path to your gremdesk]\extras\gremdesk-server\LaunchGremDeskServer.vbs"`
7) Settings > Check `Run task as soon as possible after a scheduled start is missed`

## Install GremDesk Newtab (Chrome Only; Optional)
- Replaces Chrome’s New Tab page and instantly redirects to your local GremDesk server.
- Feel free to ignore these instructions and instead just download a new tab extension from the extension store.
1) Open Chrome and go to: `chrome://extensions`
2) Enable Developer mode (top-right)
3) Click Load unpacked
4) Select this folder: `...\gremdesk\extras\gremdesk-newtab`

## Register the GremDesk protocol (Optional)

The PowerShell installer can register `gremdesk://` for you.

Only enable this if you want GremDesk links to launch local commands on your computer.

## Quick troubleshooting
- Blank page / config not loading: confirm you’re using `http://localhost:...` (not `file://...`)
- Port already in use: change `8080` to something else (e.g. `8090`)
- Firewall prompt: allow local network access (or choose "Private networks" only)
