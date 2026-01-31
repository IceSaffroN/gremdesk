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

## Installing GremDesk - Roughl Overview

1) Download all the required files from the Repo
2) Extract it to a folder on your machine
3) Setup your local server ( see expanded notes below )
4) Open GremDesk in your browser ( eg via: http://localhost:8080/ )
5) Set your browser to use GremDesk as a new tab or home page
   - You will need a browser extension to default onto GremDesk each new tab
   - GremDesk ships with a minimal local new tab extension for Chrome
6) Rename links.example.json to links.json and customize it
7) Stop here if you do not need protocol support ( otherwise see expanded notes below )

---

## Setting up a local server

*Browsers often restrict local `file://` pages (especially when loading JSON or other assets)*
*GremDesk is designed to run from a local web server*

# Basic Python Local Server Setup
1) Open PowerShell in the GremDesk folder (where `index.html` is)
2) Run `python -m http.server 8080`
3) Open in your browser: `http://localhost:8080/`

# Installing Python
1) Use your favourite LLM to help guide you through this

# Set this to run silently at boot
1) Use your favourite LLM to help guide you through this

# Quick troubleshooting
- Blank page / config not loading: confirm you’re using `http://localhost:...` (not `file://...`)
- Port already in use: change `8080` to something else (e.g. `8090`)
- Firewall prompt: allow local network access (or choose "Private networks" only)