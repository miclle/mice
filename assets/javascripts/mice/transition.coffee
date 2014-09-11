# Mice: transition.coffee

# Copyright (c) 2014 Miclle
# Licensed under MIT (https://github.com/miclle/mice/blob/master/LICENSE)

"use strict"
(($) ->

  # CSS TRANSITION SUPPORT (Shoutout: http://www.modernizr.com/)
  transitionEnd = ->
    element = document.createElement("mice")
    transEndEventNames =
      WebkitTransition : "webkitTransitionEnd"
      MozTransition    : "transitionend"
      OTransition      : "oTransitionEnd otransitionend"
      transition       : "transitionend"

    return end: transEndEventNames[name] for name of transEndEventNames when element.style[name] isnt `undefined`
    false # explicit for ie8 (  ._.)

  # http://blog.alexmaccaw.com/css-transitions
  $.fn.emulateTransitionEnd = (duration) =>
    called = false
    $(this).one "miceTransitionEnd", -> called = true
    setTimeout (-> $(_this).trigger $.support.transition.end unless called), duration
    @

  $ ->
    $.support.transition = transitionEnd()
    return unless $.support.transition
    $.event.special.miceTransitionEnd =
      bindType     : $.support.transition.end
      delegateType : $.support.transition.end
      handle       : (e) -> e.handleObj.handler.apply @, arguments if $(e.target).is(@)

) jQuery