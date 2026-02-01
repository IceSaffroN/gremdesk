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

## Installing GremDesk

1) Download all the required files from the Repo
2) Extract it to a folder on your machine (ie: C:\gremdesk)
3) Setup your local server ( see expanded notes below )
4) Open GremDesk and test in your browser ( eg via: http://localhost:8080/ )
5) Set your browser to use GremDesk as a new tab or home page
   - You will need a browser extension to default onto GremDesk each new tab
   - GremDesk ships with a minimal local new tab extension for Chrome
6) Rename links.example.json to links.json and customize it
7) Stop here if you do not need protocol support ( otherwise see expanded notes below )

---

## Setting up a local server

*Browsers often restrict local `file://` pages*
*Hence the local server requirement*

# Basic Python Local Server Setup
1) Install Python 3.12.X
2) Run .\gremdesk\extras\gremdesk-server\LaunchGremDeskServer.vbs
3) Open in your browser and navigate to `http://localhost:8080/`
4) You should see Gremdesk working. Otherwise try troubleshooting with an LLM.

# Set this to run silently at boot
1) Open Windows Task Scheduler
2) Create a Task called `gremdesk server`
3) Tick Run with highest privileges
4) Configure for Windows 10
5) Triggers Tab > New... > Begin the task: `At log on`
6) Actions Tab > New... > Program: wscript.exe; Argument: `"C:\gremdesk\extras\gremdesk-server\LaunchGremDeskServer.vbs"`
7) Settings > Check `Run task as soon as possible after a scheduled start is missed`

# Quick troubleshooting
- Blank page / config not loading: confirm you’re using `http://localhost:...` (not `file://...`)
- Port already in use: change `8080` to something else (e.g. `8090`)
- Firewall prompt: allow local network access (or choose "Private networks" only)