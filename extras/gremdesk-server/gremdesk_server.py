import json
import os
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from urllib.parse import urlparse, parse_qs

PORT = 8080

# Only allow these two logical dirs (maps URL param -> on-disk folder)
ALLOWED_DIRS = {
    "wallpapers": "wallpapers",
    "wallpapers-admin": "wallpapers-admin",
}

# Only return these file types
ALLOWED_EXTS = {".webp", ".png", ".jpg", ".jpeg", ".gif"}

class GremDeskHandler(SimpleHTTPRequestHandler):
    protocol_version = "HTTP/1.1"
    server_version = "GremDeskServer"
    sys_version = ""

    # Serve files relative to current working directory (your VBS sets it)
    def do_GET(self):
        parsed = urlparse(self.path)

        if parsed.path == "/api/list":
            qs = parse_qs(parsed.query)
            dir_key = (qs.get("dir", [""])[0] or "").strip()

            if dir_key not in ALLOWED_DIRS:
                return self._json(400, {"error": "Invalid dir. Use: wallpapers or wallpapers-admin"})

            folder = ALLOWED_DIRS[dir_key]
            folder_path = os.path.join(os.getcwd(), folder)

            if not os.path.isdir(folder_path):
                # Graceful: if the optional admin folder is missing, treat it as "no admin wallpapers"
                if dir_key == "wallpapers-admin":
                    return self._json(200, [])
                return self._json(404, {"error": f"Folder not found: {folder}"})

            files = []
            for name in os.listdir(folder_path):
                full = os.path.join(folder_path, name)
                if not os.path.isfile(full):
                    continue
                ext = os.path.splitext(name)[1].lower()
                if ext in ALLOWED_EXTS:
                    files.append(name)

            files.sort(key=lambda s: s.lower())
            return self._json(200, files)

        # Everything else = normal static serving (index.html, css, js, images...)
        return super().do_GET()

    def end_headers(self):
        path = self.path.split("?", 1)[0]

        # Never cache API responses
        if path.startswith("/api/"):
            self.send_header("Cache-Control", "no-store, no-cache, must-revalidate")

        # Cache static assets & images (1 hour)
        elif any(path.lower().endswith(ext) for ext in (
            ".css", ".js", ".svg", ".webp", ".png", ".jpg", ".jpeg", ".gif"
        )):
            self.send_header("Cache-Control", "public, max-age=3600")

        # Don't aggressively cache HTML (so edits show up)
        elif path == "/" or path.lower().endswith(".html"):
            self.send_header("Cache-Control", "no-store")

        super().end_headers()

    def _json(self, code: int, data):
        payload = json.dumps(data).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(payload)))
        self.end_headers()
        self.wfile.write(payload)

if __name__ == "__main__":
    # Move up two levels to C:\Gremster\GremDesk
    os.chdir(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..")))

    httpd = ThreadingHTTPServer(("0.0.0.0", PORT), GremDeskHandler)
    print(f"GremDesk server running on http://localhost:{PORT}/")
    httpd.serve_forever()