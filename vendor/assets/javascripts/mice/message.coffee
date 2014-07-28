# Mice: message

# Inspired by the original essage by 小鱼 sofish
# https://github.com/sofish/essage

# Copyright (c) 2014 Miclle
# Licensed under MIT (https://github.com/miclle/mice/blob/master/LICENSE)


'use strict';

(($) ->

  class Message

    constructor: (element, options) ->
      @element = element
      @$element
      @options
      @.init(options)

    init: (options) =>
      @$element = $(@element) if @element
      @$element.on('click', '.close', => @.hide()) if @$element

      @options = @getOptions(options)

    getOptions: (options) ->
      if @$element then $.extend({}, $.fn.message.defaults, @$element.data(), options) else $.extend({}, $.fn.message.defaults, options)

    show: (message, duration) ->

      duration = duration || @options.duration

      @$element = @$element || $('body').data('miclle-message-global')

      if @$element == `undefined`
        @$element = $ $.fn.message.defaults.template
        $('body').append(@$element).data('miclle-message-global', @$element)
        if typeof message == 'string'
          @init( message: message )
        else
          @init(message)

        @$element.removeClass('top').removeClass('bottom').addClass(@options.placement)

      message = @options.message

      @$element.children('.inner').html(message) if message

      @$element.slideDown => duration and setTimeout (=> @.hide()), duration
      @

    hold: ->
      @$element.slideDown()

    hide: ->
      @$element.slideUp()

    toggle: ->
      if @$element.is ':hidden' then @show() else @hide()

    destroy: ->
      @hide().$element.remove()

  $.fn.message = (option) ->
    @each ->
      $element = $(@)
      data     = $element.data('mice.message')
      options  = typeof option == 'object' and option

      return if !data and option == 'destroy'

      if !data
        data = new Message @, options
        data.show()
        $element.data 'mice.message', data

      data[option]() if typeof option == 'string'


  $.fn.message.Constructor = Message

  $.fn.message.defaults =
    template: "<div class=\"message\"><div class=\"inner\"></div><span class=\"close\">&times;</span></div>"
    message: null
    placement: 'top'
    status: ''
    duration: null

  # export to window
  window.Message = new Message()

  $ -> $('[data-ride="message"]').message();

  return

) jQuery