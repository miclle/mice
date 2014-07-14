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
      @options  = @options.viewport and $(@options.viewport.selector or @options.viewport)

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
      options = $.extend({}, @getDefaults(), @$element.data(), options)
      options.delay = show: options.delay, hide: options.delay if options.delay and typeof options.delay == 'number'
      options

    getDelegateOptions: ->
      options  = {}
      defaults = @getDefaults()

      @_options and $.each @_options, (key, value) ->
        options[key] = value if defaults[key] != value

      options

    enter: (obj) ->
      self = if obj instanceof this.constructor then obj else $(obj.currentTarget).data('bs.' + @type)

      if !self
        self = new @constructor(obj.currentTarget, @getDelegateOptions())
        $(obj.currentTarget).data('bs.' + @type, self)

      clearTimeout(@timeout)

      self.hoverState = 'in'

      return self.show() if !self.options.delay or !self.options.delay.show

      self.timeout = setTimeout (-> self.show() if self.hoverState == 'in') , self.options.delay.show

    leave: (obj) ->
      self = if obj instanceof this.constructor then obj else $(obj.currentTarget).data('bs.' + @type)

      if !self
        self = new this.constructor(obj.currentTarget, @getDelegateOptions())
        $(obj.currentTarget).data('bs.' + @type, self)

      clearTimeout(self.timeout)

      self.hoverState = 'out'

      return self.hide() if !self.options.delay or !self.options.delay.hide

      self.timeout = setTimeout (-> self.hide() if self.hoverState == 'out') , self.options.delay.hide

  $.fn.tooltip = (options) ->
    @.each ->


  $.fn.tooltip.defaults =
    animation: true
    placement: 'top'
    selector: false
    template: '<div class="tooltip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
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