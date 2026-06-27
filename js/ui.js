/* ========== UI BUILDING ========== */

// Build topbar menus
function buildTopbar(TOP) {
  const topbar = document.querySelector(".topbar");
  const left = document.createElement("div");
  const right = document.createElement("div");

  left.className = "top-left";
  right.className = "top-right";

  // left menus
  for (const [section, menuConfig] of Object.entries(TOP.LEFT)) {
    left.appendChild(makeMenu(section, menuConfig));
  }

  // right menus
  for (const [section, menuConfig] of Object.entries(TOP.RIGHT)) {
    right.appendChild(makeMenu(section, menuConfig));
  }

  topbar.append(left, right);

  let activeMenu = null;

  document.querySelectorAll('.menu').forEach(menu => {
      let timer;

      menu.addEventListener('mouseenter', () => {

          clearTimeout(timer);

          // If another menu is open, close it immediately.
          if (activeMenu && activeMenu !== menu) {
              clearTimeout(activeMenu._timer);
              activeMenu.classList.remove('is-open');
          }

          menu.classList.add('is-open');
          activeMenu = menu;
          menu._timer = timer;
      });

      menu.addEventListener('mouseleave', () => {

          timer = setTimeout(() => {

              menu.classList.remove('is-open');

              if (activeMenu === menu) {
                  activeMenu = null;
              }

          }, 50);

          menu._timer = timer;
      });

  });

}

// Create dropdown
function makeMenu(title, menuConfig) {
  if (!menuConfig || !Array.isArray(menuConfig.items)) {
    throw new Error(`Menu "${title}" must be an object with an "items" array.`);
  }

  const wrapper = document.createElement("div");
  wrapper.className = "menu";

  // MVP hidden: true => never render this menu
  if (menuConfig.hidden === true) {
    return document.createComment(`menu "${title}" hidden:true`);
  }

  // MVP hidden: "admin" => render but hide until unlockAdminMode()
  const isAdminMenu = (menuConfig.hidden === "admin") || (menuConfig.admin === true);
  if (isAdminMenu) {
    wrapper.dataset.admin = "true";
    wrapper.classList.add("hidden-admin");
  }

  const header = document.createElement("span");
  header.className = "menu-header";
  header.textContent = title;
  header.dataset.section = title.toUpperCase();

  const dropdown = document.createElement("div");
  dropdown.className = "dropdown";

  const showIcons = (menuConfig.showIcons ?? true) === true;

  for (const link of menuConfig.items) {
    if (link?.hidden === true) continue; // MVP: never render hidden items
    link._section = title;
    dropdown.appendChild(buildMenuNode(link, showIcons));
  }

  wrapper.append(header, dropdown);
  return wrapper;
}

// Render the icon
function makeMenuIconEl(iconSrc) {
  const src = iconSrc || "svg/default.svg";

  // v2: mask glyph
  const tile = document.createElement("div");
  tile.className = "menu-icon menu-icon--tile";

  const glyph = document.createElement("div");
  glyph.className = "menu-iconGlyph";
  glyph.style.setProperty("--icon", `url("${src}")`);
  glyph.style.setProperty("--glyph", "currentColor");

  tile.appendChild(glyph);
  return tile;
}

function buildMenuNode(link, showIcons) {
  if (link?.hidden === true) return document.createComment("hidden item");

  // Allow submenu items (and even leaf items, if you want) to override icon visibility
  const nodeShowIcons = (link.showIcons ?? showIcons) === true;
  const iconSrc = link.icon || "svg/default_blank.svg";

  // Submenu node
  if (Array.isArray(link.items) && link.items.length > 0) {
    const wrap = document.createElement("div");
    wrap.className = "submenu";

    if (showIcons) {
      wrap.classList.add("submenu--icons");
    }

    const header = document.createElement("div");
    header.className = "submenu-header";
    header.classList.add("menu-row");

    if (showIcons) {
      header.appendChild(makeMenuIconEl(iconSrc));
    }

    const label = document.createElement("span");
    label.textContent = link.name || "";
    header.appendChild(label);

    const chevron = document.createElement("span");
    chevron.className = "submenu-chevron";
    chevron.textContent = "›";
    header.appendChild(chevron);
    
    const sub = document.createElement("div");
    sub.className = "dropdown submenu-dropdown";

    const childShowIcons = (link.showIcons ?? showIcons) === true;

    link.items.forEach(child => {
      sub.appendChild(buildMenuNode(child, childShowIcons));
    });

    wrap.append(header, sub);
    return wrap;
  }

  // Leaf node (normal item)
  const a = document.createElement("a");
  a.classList.add("menu-row");

  // Ctrl-hide support (hide unless Ctrl is held)
  if (link.ctrlHide === true) {
    a.classList.add("ctrl-hide");
  }

  // --- analytics identity ---
  const analyticsId =
    link.url ||
    link.action ||
    link.data ||
    `${link.name || "unknown"}@${link._section || "root"}`;

  a.dataset.analyticsId = analyticsId;

  // Only render icon if not explicitly suppressed
  if (nodeShowIcons) {
    a.appendChild(makeMenuIconEl(iconSrc));
  }

  const label = document.createElement("span");
  label.textContent = link.name || "";
  a.appendChild(label);

  // Inline description (optional)
  if (link.desc) {
    const sep = document.createElement("span");
    sep.className = "menu-desc-sep";
    // sep.textContent = "   ";
    sep.textContent = " › ";

    const desc = document.createElement("span");
    desc.className = "menu-desc";
    desc.textContent = link.desc;

    a.append(sep, desc);
  }

  if (link.url) {
    a.href = link.url;
    a.target = "_self";

    // Left click tracking
    a.addEventListener("click", () => {
      trackClick(a.dataset.analyticsId, {
        type: "url",
        name: link.name,
        url: link.url
      });
    });

    // Right-click URL (optional)
    const rightUrl = link.urlRight || link.rightUrl || link.rightClickUrl;
    if (rightUrl) {
      a.addEventListener("contextmenu", (e) => {
        e.preventDefault();      // stop browser context menu
        e.stopPropagation();

        trackClick(a.dataset.analyticsId + ":right", {
          type: "url-right",
          name: link.name,
          url: rightUrl
        });

        // Open the right-click URL
        window.open(rightUrl, "_blank");
      });
    }
  } else if (link.action) {
    a.href = "#";

    if (link.action === "toggleAdminMode") {
      attachAdminModeHandler(a, link);
    } else {
      attachActionHandler(a, link);
    }
  } else if (link.data) {
    a.href = "#";
    a.addEventListener("click", e => {
      e.preventDefault();

      trackClick(a.dataset.analyticsId, {
        type: "clipboard",
        name: link.name
      });

      navigator.clipboard.writeText(link.data);
    });
  } else {
    // inert fallback (still clickable but no-op)
    a.href = "#";
    a.addEventListener("click", e => e.preventDefault());
  }

  return a;
}

function attachActionHandler(el, link) {
  el.addEventListener("click", e => {
    e.preventDefault();

    trackClick(el.dataset.analyticsId, {
      type: "action",
      name: link.name,
      action: link.action
    });

    window[link.action]?.();
  });
}

function attachAdminModeHandler(el, link) {
  const HOLD_MS = 1200;
  let holdTimer = null;
  let didLongPress = false;

  const startHold = () => {
    didLongPress = false;
    clearTimeout(holdTimer);
    holdTimer = setTimeout(() => {
      didLongPress = true;
      window.toggleAdminMode?.();
    }, HOLD_MS);
  };

  const cancelHold = () => {
    clearTimeout(holdTimer);
    holdTimer = null;
  };

  // Mouse / touch
  el.addEventListener("mousedown", e => { if (e.button === 0) startHold(); });
  el.addEventListener("touchstart", startHold, { passive: true });

  el.addEventListener("mouseup", cancelHold);
  el.addEventListener("mouseleave", cancelHold);
  el.addEventListener("touchend", cancelHold);
  el.addEventListener("touchcancel", cancelHold);

  // Click fallback (short click)
  el.addEventListener("click", e => {
    e.preventDefault();

    if (didLongPress) return;

    trackClick(el.dataset.analyticsId, {
      type: "action",
      name: link.name,
      action: link.action
    });

    window.Modal?.open({
      title: "Admin mode is not enabled by default",
      html: `<p>Refer to the documentation for details</p>`,
      actions: [{ label: "Close" }]
    });
  });
}

// ========== About Menu ==========

function showAbout() {
  window.Modal?.open({
    title: "About GremDesk",
    html: `
      <div><strong>GremDesk</strong> — local startpage + launcher.</div>
      <div style="margin-top:8px; opacity:.85;">Edit <code>links.json</code> to change menus.</div>
    `,
    actions: [{ label: "Close" }]
  });
}


// ========== Listen for Ctrl ==========
// Ctrl-held detection for admin reveal
let ctrlHeld = false;

document.addEventListener("keydown", e => {
  if (e.key === "Control" && !ctrlHeld) {
    ctrlHeld = true;
    document.body.classList.add("ctrl-held");
  }
});

document.addEventListener("keyup", e => {
  if (e.key === "Control") {
    ctrlHeld = false;
    document.body.classList.remove("ctrl-held");
  }
});
