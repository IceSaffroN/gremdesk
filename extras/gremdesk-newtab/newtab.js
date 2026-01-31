/* global chrome */
(function () {
  const url = "http://localhost:8080/";

  chrome.tabs.getCurrent((tab) => {
    if (!tab || !tab.id) {
      // Fallback: if we can't access the tab for some reason, do a normal navigation
      document.location.href = url;
      return;
    }

    chrome.tabs.update(tab.id, {
      url,
      highlighted: true
    });
  });
})();