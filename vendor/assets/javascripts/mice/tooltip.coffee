# tipsy, facebook style tooltips for jquery
# version 1.0.0a
# (c) 2008-2010 jason frame [jason@onehackoranother.com]
# released under the MIT license
# https://github.com/jaz303/tipsy

'use strict';

(($) ->


  maybeCall = (thing, ctx) ->
    if (typeof thing == 'function') then thing.call(ctx) else thing


  isElementInDOM = (element) ->
    (return true if element == document) while element = element.parentNode
    false


  class Tipsy
    constructor: (@element, @options) ->
      @.$element = $(@element)
      @.options = @options
      @.enabled = true
      @.fixTitle()

    show: ->
      title = @.getTitle()
      if title and @.enabled
        $tip = @.tip()

        $tip.find('.tipsy-inner')[if @options.html then 'html' else 'text'](title)
        $tip[0].className = 'tipsy'
        $tip.remove().css({ top: 0, left:0, visibility: 'hidden', display: 'block'}).prependTo(document.body)

        pos = $.extend({}, @.$element.offset(), {
          width: @.$element[0].offsetWidth,
          height: @.$element[0].offsetHeight
        });

        actualWidth = $tip[0].offsetWidth
        actualHeight = $tip[0].offsetHeight
        gravity = maybeCall @.options.gravity, @.$element[0]

        switch gravity.charAt(0)
          when 'n'
            tp = {top: pos.top + pos.height + @.options.offset, left: pos.left + pos.width / 2 - actualWidth / 2};
          when 's'
            tp = {top: pos.top - actualHeight - @.options.offset, left: pos.left + pos.width / 2 - actualWidth / 2};
          when 'e'
            tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth - @.options.offset};
          when 'w'
            tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width + @.options.offset};

        if gravity.length == 2
          if gravity.charAt(1) == 'w'
            tp.left = pos.left + pos.width / 2 - 15
          else
            tp.left = pos.left + pos.width / 2 - actualWidth + 15

        $tip.css(tp).addClass('tipsy-' + gravity)
        $tip.find('.tipsy-arrow')[0].className = 'tipsy-arrow tipsy-arrow-' + gravity.charAt(0)
        if @.options.className then $tip.addClass(maybeCall @.options.className, @.$element[0])

        if @.options.fade
          $tip.stop().css({opacity: 0, display: 'block', visibility: 'visible'}).animate({opacity: @.options.opacity});
        else
          $tip.css({visibility: 'visible', opacity: @.options.opacity});

      return

    hide: ->
      if @.options.fade then @.tip().stop().fadeOut(-> $(@).remove()) else @.tip().remove()

    fixTitle: ->
      if @.$element.attr('title') or typeof(@.$element.attr('original-title')) != 'string'
        @.$element.attr('original-title', @.$element.attr('title') || '').removeAttr('title')

    getTitle: ->
      @.fixTitle()
      if typeof @.options.title == 'string'
        title = @.$element.attr( if @.options.title == 'title' then 'original-title' else @.options.title)
      else if typeof @.options.title == 'function'
        title = @.options.title.call(@.$element[0])

      title = ('' + title).replace(/(^\s*|\s*$)/, "")
      title or @.options.fallback

    tip: ->
      if !@.$tip
        @.$tip = $('<div class="tipsy"></div>').html('<div class="tipsy-arrow"></div><div class="tipsy-inner"></div>');
        @.$tip.data('tipsy-pointee', @.$element[0]);
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

  $.fn.tipsy = (options) ->
    if options == true
      return @.data('tipsy')
    else if typeof options == 'string'
      tipsy = @.data('tipsy')
      if tipsy then tipsy[options]()
      return @

    options = $.extend({}, $.fn.tipsy.defaults, options)

    get = (element) ->
      tipsy = $.data(element, 'tipsy')
      if !tipsy
        tipsy = new Tipsy(element, $.fn.tipsy.elementOptions(element, options))
        $.data(element, 'tipsy', tipsy)
      return tipsy

    enter = ->
      tipsy = get @
      tipsy.hoverState = 'in'
      if options.delayIn == 0
        tipsy.show()
      else
        tipsy.fixTitle()
        setTimeout((-> tipsy.show() if tipsy.hoverState == 'in' ), options.delayIn)

    leave = ->
      tipsy = get @
      tipsy.hoverState = 'out'
      if options.delayOut == 0
        tipsy.hide()
      else
        setTimeout((-> tipsy.hide() if tipsy.hoverState == 'out' ), options.delayOut)

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


  $.fn.tipsy.defaults = {
    className: null
    delayIn: 0
    delayOut: 0
    fade: false
    fallback: ''
    gravity: 's'
    html: false
    live: false
    offset: 0
    opacity: 0.8
    title: 'title'
    trigger: 'hover'
  };


  $.fn.tipsy.revalidate = ->
    $('.tipsy').each ->
      pointee = $.data(@, 'tipsy-pointee')
      $(@).remove() if (!pointee || !isElementInDOM(pointee))


  $.fn.tipsy.elementOptions = (ele, options) ->
    if $.metadata then $.extend({}, options, $(ele).metadata()) else options


  $.fn.tipsy.autoNS = ->
    if $(@).offset().top > ($(document).scrollTop() + $(window).height() / 2) then 's' else 'n'


  $.fn.tipsy.autoWE = ->
    if $(@).offset().left > ($(document).scrollLeft() + $(window).width() / 2) then 'e' else 'w'


  $.fn.tipsy.autoBounds = (margin, prefer) ->
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