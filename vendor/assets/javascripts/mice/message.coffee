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
      @.init()

    init: =>
      @$element = $(@element) if @element
      @$element.on('click', '.close', => @.hide()) if @$element

    show: (message, duration) ->

      @$element = @$element || $('body').data('miclle-message-global')

      if @$element == `undefined`
        @$element = $ $.fn.message.defaults.template
        $('body').append(@$element).data('miclle-message-global', @$element)
        @init()

      @$element.children('.inner').text(message) if message

      if @$element.hasClass 'botton'
        @$element.slideUp => setTimeout (=> @.hide() ), duration
      else
        @$element.slideDown => setTimeout (=> @.hide() ), duration

    hide: ->
      if @$element.hasClass 'botton' then @$element.slideDown() else @$element.slideUp()

    toggle: ->
      if @$element.is ':hidden' then @show() else @hide()

    destroy: ->
      @hide().remove()

  $.fn.message = (option) ->
    @each ->
      $element = $(@)
      data     = $element.data('mice.message')
      options  = typeof option == 'object' and option

      return if !data and option == 'destroy'

      $element.data('mice.message', (data = new Message(@, options))) if !data

      data[option]() if typeof option == 'string'


  $.fn.message.Constructor = Message

  $.fn.message.defaults =
    template: "<div class=\"message\"><div class=\"inner\"></div><span class=\"close\">&times;</span></div>"
    status: ''

  # export to window
  window.Message = new Message()

  $ -> $('[data-ride="message"]').message();

  return

) jQuery