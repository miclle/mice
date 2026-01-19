/**
 * Alert component
 * Provides dismiss functionality for alert messages
 */
(function () {
  'use strict';

  // Initialize all alerts on the page
  function initAlerts() {
    // Handle alert close buttons (buttons with data-dismiss="alert")
    document.addEventListener('click', function (e) {
      const dismissBtn = e.target.closest('[data-dismiss="alert"]');
      if (!dismissBtn) return;

      const alert = dismissBtn.closest('.alert');
      if (alert) {
        closeAlert(alert);
      }
    });
  }

  // Close an alert with animation
  function closeAlert(alert) {
    if (!alert) return;

    // Add fade-out animation
    alert.style.transition = 'opacity 0.15s linear';
    alert.style.opacity = '0';

    // Remove from DOM after animation completes
    setTimeout(function () {
      // Trigger custom event before removal
      const event = new CustomEvent('alert:closed', { bubbles: true, detail: { alert } });
      alert.dispatchEvent(event);

      alert.remove();
    }, 150);
  }

  // Public API
  window.Alert = {
    close: closeAlert,
  };

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initAlerts);
  } else {
    initAlerts();
  }
})();
