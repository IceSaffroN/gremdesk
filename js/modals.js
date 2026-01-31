// js/modals.js
(() => {
  const overlay = () => document.getElementById("gdModalOverlay");
  const titleEl = () => document.getElementById("gdModalTitle");
  const bodyEl = () => document.getElementById("gdModalBody");
  const actionsEl = () => document.getElementById("gdModalActions");
  const hintEl = () => document.getElementById("gdModalHint");

  let justOpened = false;

  function close() {
    const ov = overlay();
    if (!ov) return;
    ov.classList.add("hidden");
    ov.setAttribute("aria-hidden", "true");

    // Cleanup content
    titleEl().textContent = "";
    bodyEl().innerHTML = "";
    actionsEl().innerHTML = "";
    hintEl().style.display = "none";
    hintEl().textContent = "";
  }

  function open({ title = "", html = "", actions = [], hint = "" } = {}) {
    const ov = overlay();
    if (!ov) return;

    titleEl().textContent = title;
    bodyEl().innerHTML = html;

    // Actions (buttons)
    actionsEl().innerHTML = "";
    for (const a of actions) {
      const btn = document.createElement("button");
      btn.textContent = a.label || "OK";
      if (a.className) btn.className = a.className;
      btn.addEventListener("click", () => {
        if (a.onClick) a.onClick();
        else close();
      });
      actionsEl().appendChild(btn);
    }

    // Optional hint line
    if (hint) {
      hintEl().style.display = "block";
      hintEl().textContent = hint;
    }

    justOpened = true;
    ov.classList.remove("hidden");
    ov.setAttribute("aria-hidden", "false");
    setTimeout(() => { justOpened = false; }, 0);
  }

  // Click-outside closes (but not the click that opened it)
  document.addEventListener("click", (e) => {
    const ov = overlay();
    if (!ov || ov.classList.contains("hidden")) return;
    if (justOpened) return;

    // Only close if click hits overlay background, not the modal card
    if (e.target === ov) close();
  });

  // ESC closes
  document.addEventListener("keydown", (e) => {
    const ov = overlay();
    if (!ov || ov.classList.contains("hidden")) return;
    if (e.key === "Escape") close();
  });

  // Expose globally (since your project isn’t using modules)
  window.Modal = { open, close };
})();
