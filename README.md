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

1) Download all the required files from the Repo
2) Extract it to a folder on your machine (ie: C:\gremdesk)
3) Setup your local server ( see expanded notes below )
4) Open GremDesk and test in your browser ( eg via: http://localhost:8080/ )
5) Set your browser to use GremDesk as a new tab or home page
   - You will need a browser extension to default onto GremDesk each new tab
   - GremDesk ships with a minimal local new tab extension for Chrome (notes below)
6) Rename links.example.json to links.json and customize it
7) Stop here if you do not need protocol support ( otherwise see expanded notes below )

---

## Local Server Quick Install (Recommended)

You can use the install.ps1 to do a simplified installation. It can register the protocol for you for running scripts from GremDesk. In addition it can setup the GremDesk server to run at startup silently.
To install via the PowerShell installer, run:
`powershell -ExecutionPolicy Bypass -File .\extras\install scripts\install.ps1`
in your root GremDesk folder.
Then navigate to: `C:\Users\[YourUsername]\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\`

GremDesk auto-starts the local server at login by creating a shortcut in your Startup folder.
To remove it later, delete GremDesk Server.lnk from: 
`%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup`

---

## Optional: YT-DLP Integration
Coming in a future release.

---

# Setting up a local server (Full Description)

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

# Install GremDesk Newtab (Chrome Only; Optional)
- Replaces Chrome’s New Tab page and instantly redirects to your local GremDesk server.
- Feel free to ignore these instructions and instead just download a new tab extension from the extension store.
1) Open Chrome and go to: `chrome://extensions`
2) Enable Developer mode (top-right)
3) Click Load unpacked
4) Select this folder: `...\gremdesk\extras\gremdesk-newtab`

# Register the GremDesk protocol (Optional)
*This is for if you want to be able to call programs etc from GremDesk*

# Quick troubleshooting
- Blank page / config not loading: confirm you’re using `http://localhost:...` (not `file://...`)
- Port already in use: change `8080` to something else (e.g. `8090`)
- Firewall prompt: allow local network access (or choose "Private networks" only)