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
    (if element == document then true) while element = element.parentNode
    false

  class Tooltip
    constructor: (@element, @options) ->
      @enabled = true
      @.fixTitle()

    show: ->
      title = @.getTitle
      if title and @enabled
        $tip = @.tip()

        $tip.find('.tipsy-inner')[if @options.html then 'html' else 'text'](title)

    hide: ->

    fixTitle: ->

    getTitle: ->

    tip: ->

    validate: ->

    enable: ->
      @enabled = true

    disable: ->
      @.enabled = false

    toggleEnabled: ->
      @.enabled = !@.enabled


) jQuery