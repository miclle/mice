# Mice: message

# Inspired by the original essage by 小鱼 sofish
# https://github.com/sofish/essage

# Copyright (c) 2014 Miclle
# Licensed under MIT (https://github.com/miclle/mice/blob/master/LICENSE)


'use strict';

(($) ->

  class Message

    constructor: ->
      @element = $("<div class=\"message\"><span class=\"close\">&times;</span></div>")

    init: ->

    show: (message, duration) ->
      $('body').append @element

    hide: ->

  $.fn.message = (option) ->

  $.fn.message.Constructor = Message

  $.fn.message.defaults =
    placement: "top"
    status: "normal"

  # export to window
  window.Message = new Message()

  return

) jQuery