# Mice: tooltip

# Inspired by the original jQuery.tipsy by Jason Frame
# https://github.com/jaz303/tipsy

# Copyright (c) 2014 Miclle
# Licensed under MIT (https://github.com/miclle/mice/blob/master/LICENSE)

'use strict';

(($) ->


  maybeCall = (thing, ctx) ->
    if (typeof thing == 'function') then thing.call(ctx) else thing


  isElementInDOM = (element) ->
    (return true if element == document) while element = element.parentNode
    false


  class Tooltip
    constructor: (@element, @options) ->
      @.$element = $(@element)
      @.options = @options
      @.enabled = true
      @.fixTitle()

    show: ->
      title = @.getTitle()
      if title and @.enabled
        $tip = @.tip()

        $tip.find('.tooltip-inner')[if @options.html then 'html' else 'text'](title)
        $tip[0].className = 'tooltip'
        $tip.remove().css({ top: 0, left:0, visibility: 'hidden', display: 'block'}).prependTo(document.body)

        pos = $.extend({}, @.$element.offset(), {
          width: @.$element[0].offsetWidth,
          height: @.$element[0].offsetHeight
        });

        actualWidth = $tip[0].offsetWidth
        actualHeight = $tip[0].offsetHeight
        placement = maybeCall @.options.placement, @.$element[0]

        switch placement.charAt(0)
          when 'n'
            tp = {top: pos.top + pos.height + @.options.offset, left: pos.left + pos.width / 2 - actualWidth / 2};
          when 's'
            tp = {top: pos.top - actualHeight - @.options.offset, left: pos.left + pos.width / 2 - actualWidth / 2};
          when 'e'
            tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth - @.options.offset};
          when 'w'
            tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width + @.options.offset};

        if placement.length == 2
          if placement.charAt(1) == 'w'
            tp.left = pos.left + pos.width / 2 - 15
          else
            tp.left = pos.left + pos.width / 2 - actualWidth + 15

        $tip.css(tp).addClass('tooltip-' + placement)
        $tip.find('.tooltip-arrow')[0].className = 'tooltip-arrow tooltip-arrow-' + placement.charAt(0)
        if @.options.className then $tip.addClass(maybeCall @.options.className, @.$element[0])

        if @.options.fade
          $tip.stop().css({opacity: 0, display: 'block', visibility: 'visible'}).animate({opacity: @.options.opacity});
        else
          $tip.css({visibility: 'visible', opacity: @.options.opacity});

      return

    hide: ->
      if @.options.fade then @.tip().stop().fadeOut(-> $(@).remove()) else @.tip().remove()

    fixTitle: ->
      if @.$element.attr('title') or typeof(@.$element.attr('data-original-title')) != 'string'
        @.$element.attr('data-original-title', @.$element.attr('title') || '').removeAttr('title')

    getTitle: ->
      @.fixTitle()
      if typeof @.options.title == 'string'
        title = @.$element.attr( if @.options.title == 'title' then 'data-original-title' else @.options.title)
      else if typeof @.options.title == 'function'
        title = @.options.title.call(@.$element[0])

      title = ('' + title).replace(/(^\s*|\s*$)/, "")
      title or @.options.fallback

    tip: ->
      if !@.$tip
        @.$tip = $('<div class="tooltip"></div>').html('<div class="tooltip-arrow"></div><div class="tooltip-inner"></div>');
        @.$tip.data('tooltip-pointee', @.$element[0]);
      @.$tip;

    validate: ->
      if !@.$element[0].parentNode
        @.hide();
        @.$element = null;
        @.options = null;

    enable: ->
      @.enabled = true

    disable: ->
      @.enabled = false

    toggleEnabled: ->
      @.enabled = !@.enabled


  $.fn.tooltip = (options) ->
    if options == true
      return @.data('tooltip')
    else if typeof options == 'string'
      tooltip = @.data('tooltip')
      if tooltip then tooltip[options]()
      return @

    options = $.extend({}, $.fn.tooltip.defaults, options)

    get = (element) ->
      tooltip = $.data(element, 'tooltip')
      if !tooltip
        tooltip = new Tooltip(element, $.fn.tooltip.elementOptions(element, options))
        $.data(element, 'tooltip', tooltip)
      return tooltip

    enter = ->
      tooltip = get @
      tooltip.hoverState = 'in'
      if options.delayIn == 0
        tooltip.show()
      else
        tooltip.fixTitle()
        setTimeout((-> tooltip.show() if tooltip.hoverState == 'in' ), options.delayIn)

    leave = ->
      tooltip = get @
      tooltip.hoverState = 'out'
      if options.delayOut == 0
        tooltip.hide()
      else
        setTimeout((-> tooltip.hide() if tooltip.hoverState == 'out' ), options.delayOut)

    if !options.live
      @.each( ->
        get(@)
        return
      )

    if options.trigger != 'manual'
      binder  = if options.live then 'live' else 'bind'
      eventIn = if options.trigger == 'hover' then 'mouseenter' else 'focus'
      eventOut= if options.trigger == 'hover' then 'mouseleave' else 'blur'
      @[binder](eventIn, enter)[binder](eventOut, leave)

    @


  $.fn.tooltip.defaults = {
    className: null
    delayIn: 0
    delayOut: 0
    fade: false
    fallback: ''
    placement: 's'
    html: false
    live: false
    offset: 0
    opacity: 0.8
    title: 'title'
    trigger: 'hover'
  };


  $.fn.tooltip.revalidate = ->
    $('.tooltip').each ->
      pointee = $.data(@, 'tooltip-pointee')
      $(@).remove() if (!pointee || !isElementInDOM(pointee))


  $.fn.tooltip.elementOptions = (ele, options) ->
    if $.metadata then $.extend({}, options, $(ele).metadata()) else options


  $.fn.tooltip.autoNS = ->
    if $(@).offset().top > ($(document).scrollTop() + $(window).height() / 2) then 's' else 'n'


  $.fn.tooltip.autoWE = ->
    if $(@).offset().left > ($(document).scrollLeft() + $(window).width() / 2) then 'e' else 'w'


  $.fn.tooltip.autoBounds = (margin, prefer) ->
    ->
      dir = { ns: prefer[0], ew:(if prefer.length > 1 then prefer[1] else false)}
      boundTop = $(document).scrollTop + margin
      boundLeft = $(document).scrollLeft + margin

      $this = $(@)

      dir.ns = 'n' if ($this.offset().top < boundTop)
      dir.ew = 'w' if ($this.offset().left < boundLeft)
      dir.ew = 'e' if ($(window).width() + $(document).scrollLeft() - $this.offset().left < margin)
      dir.ns = 's' if ($(window).height() + $(document).scrollTop() - $this.offset().top < margin)

      dir.ns + (if dir.ew then dir.ew else '')


  return


) jQuery