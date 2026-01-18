/**
 * Dialog component using native <dialog> element
 * Provides simple API for opening and closing dialogs with animations
 */
(function () {
  'use strict';

  // Initialize all dialogs on the page
  function initDialogs() {
    // Handle dialog triggers (buttons with data-toggle="dialog")
    document.addEventListener('click', function (e) {
      const trigger = e.target.closest('[data-toggle="dialog"]');
      if (!trigger) return;

      e.preventDefault();
      const targetSelector = trigger.getAttribute('data-target');
      if (!targetSelector) return;

      const dialog = document.querySelector(targetSelector);
      if (dialog && dialog.tagName === 'DIALOG') {
        openDialog(dialog);
      }
    });

    // Handle close buttons (buttons with data-dismiss="dialog")
    document.addEventListener('click', function (e) {
      const dismissBtn = e.target.closest('[data-dismiss="dialog"]');
      if (!dismissBtn) return;

      const dialog = dismissBtn.closest('dialog');
      if (dialog) {
        closeDialog(dialog);
      }
    });

    // Handle backdrop clicks (clicking outside the dialog)
    // Only applies to dialogs opened with showModal() (i.e., has .backdrop class)
    document.addEventListener('click', function (e) {
      if (e.target.tagName === 'DIALOG' && e.target.classList.contains('backdrop')) {
        const rect = e.target.getBoundingClientRect();
        const isInDialog =
          rect.top <= e.clientY &&
          e.clientY <= rect.top + rect.height &&
          rect.left <= e.clientX &&
          e.clientX <= rect.left + rect.width;

        // Close if clicking outside (on the backdrop)
        if (!isInDialog) {
          closeDialog(e.target);
        }
      }
    });
  }

  // Open a dialog
  function openDialog(dialog) {
    if (!(dialog instanceof HTMLDialogElement)) return;

    // Always use showModal() for consistent behavior (ESC key, focus trap, etc.)
    // Backdrop visibility is controlled by CSS:
    // - dialog::backdrop { background: transparent } - default (no visible backdrop)
    // - dialog.backdrop::backdrop { background: rgba(0,0,0,0.5) } - visible backdrop
    dialog.showModal();

    // Trigger custom event
    const event = new CustomEvent('dialog:opened', { bubbles: true, detail: { dialog } });
    dialog.dispatchEvent(event);
  }

  // Close a dialog with animation
  function closeDialog(dialog) {
    if (!(dialog instanceof HTMLDialogElement)) return;

    // Add fade-out class for animation
    dialog.classList.add('fade-out');

    // Wait for animation to complete, then close
    const handleAnimationEnd = function () {
      dialog.classList.remove('fade-out');
      dialog.close();
      dialog.removeEventListener('animationend', handleAnimationEnd);

      // Trigger custom event
      const event = new CustomEvent('dialog:closed', { bubbles: true, detail: { dialog } });
      dialog.dispatchEvent(event);
    };

    dialog.addEventListener('animationend', handleAnimationEnd);
  }

  // Public API
  window.Dialog = {
    open: openDialog,
    close: closeDialog,
  };

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initDialogs);
  } else {
    initDialogs();
  }
})();
