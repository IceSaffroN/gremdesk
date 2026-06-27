// ========== MVP CLICK ANALYTICS ==========
const ANALYTICS_KEY = "gremdesk_clicks_v1";

function loadAnalytics() {
  try {
    return JSON.parse(localStorage.getItem(ANALYTICS_KEY)) || {};
  } catch {
    return {};
  }
}

function trackClick(id, meta = {}) {
  if (!id) return;

  const data = loadAnalytics();
  const now = Date.now();

  data[id] ??= {
    count: 0,
    first: now,
    last: null,
    meta: {}
  };

  data[id].count += 1;
  data[id].last = now;
  data[id].meta = { ...data[id].meta, ...meta };

  localStorage.setItem(ANALYTICS_KEY, JSON.stringify(data));
}
