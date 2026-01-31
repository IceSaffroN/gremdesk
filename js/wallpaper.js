/* ========== WALLPAPER SYSTEM (CLEAN) ========== */
let ADMIN_MODE = false;
let lastWallpaper = null;

const POOLS = { normal: null, admin: null };

const pick = (arr) => arr[Math.floor(Math.random() * arr.length)];

async function fetchPool(dirKey, urlBase) {
  const res = await fetch(`/api/list?dir=${encodeURIComponent(dirKey)}`);
  if (!res.ok) throw new Error(`Pool fetch failed (${dirKey}): ${res.status}`);

  const files = await res.json(); // ["01.webp", ...]
  const base = urlBase.endsWith("/") ? urlBase : (urlBase + "/");

  return (files || []).map((name) => base + String(name).replace(/^\/+/, ""));
}

async function ensurePools() {
  if (!POOLS.normal) POOLS.normal = await fetchPool("wallpapers", "wallpapers/");
  if (ADMIN_MODE && !POOLS.admin) POOLS.admin = await fetchPool("wallpapers-admin", "wallpapers-admin/");
}

async function setWallpaper() {
  try {
    // Pin fallback color immediately (prevents any transient transparency/white)
    document.body.style.backgroundColor = "#1e1e1e";

    await ensurePools();

    const pool = (ADMIN_MODE && POOLS.admin?.length) ? POOLS.admin : POOLS.normal;
    if (!pool?.length) return console.error("No wallpapers available");

    let url = pick(pool);
    for (let i = 0; i < 10 && pool.length > 1 && url === lastWallpaper; i++) url = pick(pool);
    lastWallpaper = url;

    // Preload/decode (fast path; uses browser cache)
    const img = new Image();
    img.src = url;
    await img.decode().catch(() => {}); // don't hard-fail on decode quirks

    // Apply
    document.body.style.backgroundImage = `url("${url}")`;
    document.body.style.backgroundSize = "cover";
    document.body.style.backgroundPosition = "center";
    document.body.style.backgroundRepeat = "no-repeat";
    document.body.style.backgroundAttachment = "fixed";
  } catch (e) {
    console.error("Wallpaper error:", e);
  }
}

// ---- Admin Mode ----
function setAdminMenusVisible(visible) {
  document.querySelectorAll('.menu[data-admin="true"]').forEach(menu => {
    menu.classList.toggle("hidden-admin", !visible);
  });
}

async function toggleAdminMode() {
  ADMIN_MODE = !ADMIN_MODE;
  setAdminMenusVisible(ADMIN_MODE);

  // Only change wallpaper when entering admin mode if admin wallpapers exist
  if (ADMIN_MODE) {
    try {
      if (!POOLS.admin) POOLS.admin = await fetchPool("wallpapers-admin", "wallpapers-admin/");
      if (POOLS.admin?.length) await setWallpaper();
    } catch {
      // If admin pool is missing/unavailable, keep current wallpaper
    }
    return;
  }

  // Leaving admin mode: always switch back to normal pool
  await setWallpaper();
}

setWallpaper();
