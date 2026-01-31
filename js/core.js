/* ========== BOOTSTRAP ========== */

async function loadLinks() {
  try {
    const res = await fetch("links.json");
    if (!res.ok) throw new Error("links.json missing");
    console.log("[GremDesk] Loaded links.json");
    return await res.json();
  } catch (err) {
    console.warn("[GremDesk] links.json not found, falling back to links.example.json");
    const res = await fetch("links.example.json");
    if (!res.ok) {
      throw new Error("links.example.json missing — cannot start GremDesk");
    }
    return await res.json();
  }
}

loadLinks()
  .then(data => {
    buildTopbar(data.TOP);
  })
  .catch(err => {
    console.error("[GremDesk] Failed to load any links config:", err);
  });

// disable Tab so it doesn't jump focus around
document.addEventListener("keydown", e => {
  if (e.key === "Tab") e.preventDefault();
});