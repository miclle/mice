# Mice: alert

# Copyright (c) 2014 Miclle
# Licensed under MIT (https://github.com/miclle/mice/blob/master/LICENSE)

'use strict';

(($) ->

  # ALERT PUBLIC CLASS DEFINITION
  # ===============================
  class Alert
    constructor: (element) ->
      $(element).on('click', '[data-dismiss="alert"]', @close)

    close: (e) ->
      $this    = $(this)
      selector = $this.attr('data-target')

      unless selector
        selector = $this.attr('href')
        selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') # strip for ie7

      $parent = $(selector)

      e.preventDefault() if e

      $parent = (if $this.hasClass('alert') then $this else $this.parent()) unless $parent.length

      $parent.trigger(e = $.Event('close.alert'))

      return if e.isDefaultPrevented()

      $parent.removeClass('in')

      removeElement = -> # detach from parent, fire event then clean up data
        $parent.detach().trigger('closed.alert').remove()

      if $.support.transition and $parent.hasClass('fade')
        $parent.one('miceTransitionEnd', removeElement).emulateTransitionEnd(150)
      else
        removeElement()


  # ALERT PLUGIN DEFINITION
  # =========================
  $.fn.alert = (option) ->
    @each ->
      $this = $(this)
      data  = $this.data('alert')

      $this.data('alert', (data = new Alert(this))) unless data
      data[option].call($this) if (typeof option == 'string')


  $.fn.alert.Constructor = Alert

  $(document).on('click.alert.data-api', '[data-dismiss="alert"]', Alert.prototype.close)

  return

) jQuery