# Mice: tooltip

# Inspired by the original jQuery.tipsy by Jason Frame
# https://github.com/jaz303/tipsy

# Copyright (c) 2014 Miclle
# Licensed under MIT (https://github.com/miclle/mice/blob/master/LICENSE)

'use strict';

(($) ->

  # TOOLTIP PUBLIC CLASS DEFINITION

  class Tooltip
    constructor: (element, options) ->
      @type
      @options
      @enabled
      @timeout
      @hoverState
      @$element   = null

      @init('tooltip', element, options)


    init: (type, element, options) ->
      @enabled  = true
      @type     = type
      @$element = $(element)
      @options   = @getOptions(options)
      @$viewport  = @options.viewport and $(@options.viewport.selector or @options.viewport)

      for trigger in @options.trigger.split(' ')
        if trigger == 'click'
          @$element.on('click.' + @type, @options.selector, $.proxy(@toggle, @))
        else if trigger != 'manual'
          eventIn  = if trigger == 'hover' then 'mouseenter' else 'focusin'
          eventOut = if trigger == 'hover' then 'mouseleave' else 'focusout'

          @$element.on((eventIn)  + '.' + @type, @options.selector, $.proxy(@enter, @))
          @$element.on((eventOut) + '.' + @type, @options.selector, $.proxy(@leave, @))

      if @options.selector
        @_options = $.extend({}, @options, { trigger: 'manual', selector: '' })
      else
        @fixTitle()

      return

    getDefault: ->
      $.fn.tooltip.defaults

    getOptions: (options) ->
      options = $.extend({}, @getDefault(), @$element.data(), options)
      options.delay = show: options.delay, hide: options.delay if options.delay and typeof options.delay == 'number'
      options

    getDelegateOptions: ->
      options  = {}
      defaults = @getDefaults()

      @_options and $.each @_options, (key, value) ->
        options[key] = value if defaults[key] != value

      options

    enter: (obj) ->
      self = if obj instanceof @constructor then obj else $(obj.currentTarget).data('bs.' + @type)

      if !self
        self = new @constructor(obj.currentTarget, @getDelegateOptions())
        $(obj.currentTarget).data('bs.' + @type, self)

      clearTimeout(@timeout)

      self.hoverState = 'in'

      return self.show() if !self.options.delay or !self.options.delay.show

      self.timeout = setTimeout (-> self.show() if self.hoverState == 'in') , self.options.delay.show

    leave: (obj) ->
      self = if obj instanceof @constructor then obj else $(obj.currentTarget).data('bs.' + @type)

      if !self
        self = new @constructor(obj.currentTarget, @getDelegateOptions())
        $(obj.currentTarget).data('bs.' + @type, self)

      clearTimeout(self.timeout)

      self.hoverState = 'out'

      return self.hide() if !self.options.delay or !self.options.delay.hide

      self.timeout = setTimeout (-> self.hide() if self.hoverState == 'out') , self.options.delay.hide

    show: ->
      e = $.Event('show.bs.'+@type)
      if @getTitle() and @enabled
        @$element.trigger e

        inDom =  $.contains(document.documentElement, @$element[0])
        return if e.isDefaultPrevented() or !inDom

        that = @

        $tip = @tip()
        @setContent()

        $tip.addClass 'fade' if @options.animation

        placement = if typeof @options.placement == 'function' then @options.placement.call(@, $tip[0], @$element[0]) else @options.placement

        autoToken = /\s?auto?\s?/i
        autoPlace = autoToken.test(placement)
        placement = placement.replace(autoToken, '') or 'top' if autoPlace

        $tip.detach().css({ top: 0, left: 0, display: 'block' }).addClass(placement).data('bs.' + @type, @)

        if @options.container then $tip.appendTo(@options.container) else $tip.insertAfter(@$element)

        pos          = @getPosition()
        actualWidth  = $tip[0].offsetWidth
        actualHeight = $tip[0].offsetHeight

        if autoPlace
          orgPlacement = placement
          $parent      = @$element.parent()
          parentDim    = @getPosition($parent)

          placement = if placement == 'bottom' and pos.top   + pos.height       + actualHeight - parentDim.scroll > parentDim.height then 'top'    else
                      if placement == 'top'    and pos.top   - parentDim.scroll - actualHeight < 0                                   then 'bottom' else
                      if placement == 'right'  and pos.right + actualWidth      > parentDim.width                                    then 'left'   else
                      if placement == 'left'   and pos.left  - actualWidth      < parentDim.left                                     then 'right'  else placement

          $tip.removeClass(orgPlacement).addClass(placement)

        calculatedOffset = @getCalculatedOffset placement, pos, actualWidth, actualHeight

        @applyPlacement calculatedOffset, placement

        complete = ->
          that.$element.trigger('shown.bs.' + that.type)
          that.hoverState = null

        if $.support.transition and @$tip.hasClass('fade') then $tip.one('bsTransitionEnd', complete).emulateTransitionEnd(150) else complete()

    applyPlacement: (offset, placement) ->
      $tip   = @tip()
      width  = $tip[0].offsetWidth
      height = $tip[0].offsetHeight

      # manually read margins because getBoundingClientRect includes difference
      marginTop = parseInt($tip.css('margin-top'), 10)
      marginLeft = parseInt($tip.css('margin-left'), 10)

      # we must check for NaN for ie 8/9
      offset.top  = offset.top  + if isNaN(marginTop)  then 0 else marginTop
      offset.left = offset.left + if isNaN(marginLeft) then 0 else marginLeft

      # $.fn.offset doesn't round pixel values
      # so we use setOffset directly with our own function B-0
      $.offset.setOffset($tip[0], $.extend({ using: (props) -> $tip.css({ top: Math.round(props.top), left: Math.round(props.left) }) }, offset), 0)

      $tip.addClass 'in'

      # check to see if placing tip in new offset caused the tip to resize itself
      actualWidth  = $tip[0].offsetWidth
      actualHeight = $tip[0].offsetHeight

      offset.top = offset.top + height - actualHeight if placement == 'top' and actualHeight != height

      delta = @getViewportAdjustedDelta placement, offset, actualWidth, actualHeight

      if delta.left then offset.left += delta.left else offset.top += delta.top

      arrowDelta          = if delta.left then delta.left * 2 - width + actualWidth else delta.top * 2 - height + actualHeight
      arrowPosition       = if delta.left then 'left'        else 'top'
      arrowOffsetPosition = if delta.left then 'offsetWidth' else 'offsetHeight'

      $tip.offset(offset)
      @replaceArrow arrowDelta, $tip[0][arrowOffsetPosition], arrowPosition

    replaceArrow: (delta, dimension, position) ->
      @arrow().css(position, if delta then (50 * (1 - delta / dimension) + '%') else '')

    setContent: ->
      @tip().find('.inner')[if @options.html then 'html' else 'text'](@getTitle()).removeClass('fade in top bottom left right')

    hide: ->
      that = @
      $tip = @tip()
      e    = $.Event('hide.bs.' + @type)

      complete = ->
        $tip.detach() if that.hoverState != 'in'
        that.$element.trigger('hidden.bs.' + that.type)

      @$element.trigger(e)

      return if e.isDefaultPrevented()

      $tip.removeClass('in')

      if $.support.transition and @$tip.hasClass('fade') then $tip.one('bsTransitionEnd', complete).emulateTransitionEnd(150) else complete()

      @hoverState = null

      @

    fixTitle: ->
      @$element.attr('data-original-title', @$element.attr('title') or '').removeAttr('title') if @$element.attr('title') or typeof (@$element.attr('data-original-title')) != 'string'

    getPosition: ($element) ->
      $element  = $element or @$element
      el        = $element[0]
      isBody    = el.tagName == 'BODY'

      return $.extend({}, (if (typeof el.getBoundingClientRect == 'function') then el.getBoundingClientRect() else null), {
        scroll: if isBody then document.documentElement.scrollTop or document.body.scrollTop else $element.scrollTop()
        width:  if isBody then $(window).width()  else $element.outerWidth()
        height: if isBody then $(window).height() else $element.outerHeight()
      }, if isBody then { top: 0, left: 0 } else $element.offset())

    getCalculatedOffset: (placement, pos, actualWidth, actualHeight) ->
      switch placement
        when 'bottom' then { top: pos.top + pos.height,   left: pos.left + pos.width / 2 - actualWidth / 2  }
        when 'top'    then { top: pos.top - actualHeight, left: pos.left + pos.width / 2 - actualWidth / 2  }
        when 'left'   then { top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth }
        when 'right'  then { top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width   }

    getViewportAdjustedDelta: (placement, pos, actualWidth, actualHeight) ->
      delta = { top: 0, left: 0 }
      return delta if !@$viewport

      viewportPadding = @options.viewport and @options.viewport.padding or 0
      viewportDimensions = @getPosition @$viewport

      if /right|left/.test placement
        topEdgeOffset    = pos.top - viewportPadding - viewportDimensions.scroll
        bottomEdgeOffset = pos.top + viewportPadding - viewportDimensions.scroll + actualHeight
        if topEdgeOffset < viewportDimensions.top #top overflow
          delta.top = viewportDimensions.top - topEdgeOffset
        else if bottomEdgeOffset > viewportDimensions.top + viewportDimensions.height #bottom overflow
          delta.top = viewportDimensions.top + viewportDimensions.height - bottomEdgeOffset
      else
        leftEdgeOffset  = pos.left - viewportPadding
        rightEdgeOffset = pos.left + viewportPadding + actualWidth
        if leftEdgeOffset < viewportDimensions.left #left overflow
          delta.left = viewportDimensions.left - leftEdgeOffset
        else if rightEdgeOffset > viewportDimensions.width #right overflow
          delta.left = viewportDimensions.left + viewportDimensions.width - rightEdgeOffset

      delta

    getTitle: ->
      @$element.attr('data-original-title') or (if typeof @options.title == 'function' then @options.title.call(@$element[0]) else  @options.title)

    tip: ->
      @$tip = @$tip or $(@options.template)

    arrow: ->
      @$arrow = @$arrow or @tip().find('.arrow')

    validate: ->
      if !@$element[0].parentNode
        @hide()
        @$element = null
        @options  = null

    enable: ->
      @enabled = true

    disable: ->
      @enabled = false

    toggleEnabled: ->
      @enabled = !@enabled

    toggle: (e) ->
      self = @
      if e
        self = $(e.currentTarget).data('bs.' + @type)
        if !self
          self = new @constructor(e.currentTarget, @getDelegateOptions())
          $(e.currentTarget).data('bs.' + @type, self)

      if self.tip().hasClass('in') then self.leave(self) else self.enter(self)

    destroy: ->
      clearTimeout(@timeout)
      @hide().$element.off('.' + @type).removeData('bs.' + @type)


  $.fn.tooltip = (option) ->
    @each ->
      $element = $(@)
      data     = $element.data('bs.tooltip')
      options  = typeof option == 'object' and option

      return if !data and option == 'destroy'

      $element.data('bs.tooltip', (data = new Tooltip(@, options))) if !data

      data[option]() if typeof option == 'string'


  $.fn.tooltip.Constructor = Tooltip


  $.fn.tooltip.defaults =
    animation: true
    placement: 'top'
    selector: false
    template: '<div class="tooltip" role="tooltip"><div class="arrow"></div><div class="inner"></div></div>'
    trigger: 'hover focus'
    title: ''
    delay: 0
    html: false
    container: false
    viewport:
      selector: 'body'
      padding: 0

  return

) jQuery