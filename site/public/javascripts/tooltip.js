/**
 * Tooltip component
 * Provides tooltip functionality with positioning and animations
 */
(function () {
  'use strict';

  // Default configuration
  const defaults = {
    animation: true,
    container: false,
    delay: 0,
    html: false,
    placement: 'top',
    contextual: '',
    selector: false,
    template:
      '<div class="tooltip" role="tooltip"><div class="arrow"></div><div class="inner"></div></div>',
    title: '',
    trigger: 'hover focus',
    viewport: { selector: 'body', padding: 0 },
  };

  // Tooltip class
  class Tooltip {
    constructor(element, options) {
      this.element = element;
      this.options = { ...defaults, ...this.getDataOptions(), ...options };
      this.tooltip = null;
      this.timeout = null;
      this.hoverState = null;
      this.enabled = true;

      this.init();
    }

    // Get options from data attributes
    getDataOptions() {
      const data = {};
      const dataset = this.element.dataset;

      if (dataset.animation) data.animation = dataset.animation === 'true';
      if (dataset.container) data.container = dataset.container;
      if (dataset.delay) data.delay = parseInt(dataset.delay, 10);
      if (dataset.html) data.html = dataset.html === 'true';
      if (dataset.placement) data.placement = dataset.placement;
      if (dataset.contextual) data.contextual = dataset.contextual;
      if (dataset.template) data.template = dataset.template;
      if (dataset.trigger) data.trigger = dataset.trigger;

      return data;
    }

    // Initialize tooltip
    init() {
      const triggers = this.options.trigger.split(' ');

      triggers.forEach((trigger) => {
        if (trigger === 'click') {
          this.element.addEventListener('click', (e) => this.toggle(e));
        } else if (trigger === 'hover') {
          this.element.addEventListener('mouseenter', (e) => this.enter(e));
          this.element.addEventListener('mouseleave', (e) => this.leave(e));
        } else if (trigger === 'focus') {
          this.element.addEventListener('focus', (e) => this.enter(e));
          this.element.addEventListener('blur', (e) => this.leave(e));
        }
      });
    }

    // Get title content
    getTitle() {
      return this.element.getAttribute('title') || this.element.dataset.originalTitle || this.options.title;
    }

    // Enter handler
    enter(e) {
      clearTimeout(this.timeout);

      this.hoverState = 'in';

      const delay = typeof this.options.delay === 'object' ? this.options.delay.show : this.options.delay;

      if (!delay) {
        this.show();
        return;
      }

      this.timeout = setTimeout(() => {
        if (this.hoverState === 'in') {
          this.show();
        }
      }, delay);
    }

    // Leave handler
    leave(e) {
      clearTimeout(this.timeout);

      this.hoverState = 'out';

      const delay = typeof this.options.delay === 'object' ? this.options.delay.hide : this.options.delay;

      if (!delay) {
        this.hide();
        return;
      }

      this.timeout = setTimeout(() => {
        if (this.hoverState === 'out') {
          this.hide();
        }
      }, delay);
    }

    // Toggle tooltip
    toggle(e) {
      if (this.tooltip && this.tooltip.classList.contains('in')) {
        this.hide();
      } else {
        this.show();
      }
    }

    // Show tooltip
    show() {
      if (!this.enabled) return;

      // Dispatch show event
      const showEvent = new CustomEvent('show.semantic.tooltip', { bubbles: true, cancelable: true });
      this.element.dispatchEvent(showEvent);
      if (showEvent.defaultPrevented) return;

      // Create tooltip if it doesn't exist
      if (!this.tooltip) {
        this.createTooltip();
      }

      // Get title and set content
      const title = this.getTitle();
      if (!title) return;

      const inner = this.tooltip.querySelector('.inner');
      if (this.options.html) {
        inner.innerHTML = title;
      } else {
        inner.textContent = title;
      }

      // Add contextual class
      if (this.options.contextual) {
        this.tooltip.classList.add(this.options.contextual);
      }

      // Remove title attribute to prevent native tooltip
      if (this.element.hasAttribute('title')) {
        this.element.dataset.originalTitle = this.element.getAttribute('title');
        this.element.removeAttribute('title');
      }

      // Position and show
      this.position();

      // Add 'in' class for fade-in animation
      setTimeout(() => {
        this.tooltip.classList.add('in');

        // Dispatch shown event
        const shownEvent = new CustomEvent('shown.semantic.tooltip', { bubbles: true });
        this.element.dispatchEvent(shownEvent);
      }, 10);
    }

    // Hide tooltip
    hide() {
      if (!this.tooltip) return;

      // Dispatch hide event
      const hideEvent = new CustomEvent('hide.semantic.tooltip', { bubbles: true, cancelable: true });
      this.element.dispatchEvent(hideEvent);
      if (hideEvent.defaultPrevented) return;

      // Remove 'in' class for fade-out animation
      this.tooltip.classList.remove('in');

      // Remove tooltip after animation
      setTimeout(() => {
        if (this.tooltip && !this.tooltip.classList.contains('in')) {
          this.tooltip.remove();
          this.tooltip = null;

          // Dispatch hidden event
          const hiddenEvent = new CustomEvent('hidden.semantic.tooltip', { bubbles: true });
          this.element.dispatchEvent(hiddenEvent);
        }
      }, 150);
    }

    // Create tooltip element
    createTooltip() {
      const container = this.options.container ? document.querySelector(this.options.container) : document.body;
      const temp = document.createElement('div');
      temp.innerHTML = this.options.template.trim();
      this.tooltip = temp.firstChild;
      container.appendChild(this.tooltip);
    }

    // Position tooltip
    position() {
      if (!this.tooltip) return;

      const placement = this.options.placement;
      const elementRect = this.element.getBoundingClientRect();
      const tooltipRect = this.tooltip.getBoundingClientRect();

      let top, left;

      // Calculate position based on placement
      switch (placement) {
        case 'top':
          top = elementRect.top - tooltipRect.height + window.scrollY;
          left = elementRect.left + elementRect.width / 2 - tooltipRect.width / 2 + window.scrollX;
          break;
        case 'bottom':
          top = elementRect.bottom + window.scrollY;
          left = elementRect.left + elementRect.width / 2 - tooltipRect.width / 2 + window.scrollX;
          break;
        case 'left':
          top = elementRect.top + elementRect.height / 2 - tooltipRect.height / 2 + window.scrollY;
          left = elementRect.left - tooltipRect.width + window.scrollX;
          break;
        case 'right':
          top = elementRect.top + elementRect.height / 2 - tooltipRect.height / 2 + window.scrollY;
          left = elementRect.right + window.scrollX;
          break;
        default:
          top = elementRect.top - tooltipRect.height + window.scrollY;
          left = elementRect.left + elementRect.width / 2 - tooltipRect.width / 2 + window.scrollX;
      }

      // Apply position
      this.tooltip.style.top = `${top}px`;
      this.tooltip.style.left = `${left}px`;

      // Add placement class
      this.tooltip.classList.add(placement);
    }

    // Destroy tooltip
    destroy() {
      this.hide();
      this.element.removeEventListener('click', this.toggle);
      this.element.removeEventListener('mouseenter', this.enter);
      this.element.removeEventListener('mouseleave', this.leave);
      this.element.removeEventListener('focus', this.enter);
      this.element.removeEventListener('blur', this.leave);

      // Restore original title
      if (this.element.dataset.originalTitle) {
        this.element.setAttribute('title', this.element.dataset.originalTitle);
        delete this.element.dataset.originalTitle;
      }
    }
  }

  // Initialize all tooltips with data-toggle="tooltip"
  function initTooltips() {
    const tooltipElements = document.querySelectorAll('[data-toggle="tooltip"]');
    tooltipElements.forEach((element) => {
      if (!element._tooltip) {
        element._tooltip = new Tooltip(element);
      }
    });
  }

  // Public API
  window.Tooltip = Tooltip;

  // Auto-initialize on DOM ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initTooltips);
  } else {
    initTooltips();
  }

  // Re-initialize on dynamic content changes (optional)
  // You can manually call initTooltips() after adding new tooltip elements
})();
