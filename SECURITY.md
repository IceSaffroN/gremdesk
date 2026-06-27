# Security Policy

GremDesk is a local-first Windows start page. It is designed to run on your own machine and serve files from the local project folder.

## Local Server

The optional GremDesk server binds to `127.0.0.1` on port `8080` by default. This means it should only be reachable from the same computer, not from other devices on your network.

## Local Protocol Handler

The optional `gremdesk://` protocol can launch commands on your computer.

Review command entries before using them, especially entries that open programs, run scripts, or use clipboard text.

The example command file is intentionally a template. Rename it to `gremdesk.commands.cmd` and customize it for your own machine.

## Reporting

If you discover a security issue, please report it privately to the maintainer via GitHub rather than opening a public issue.