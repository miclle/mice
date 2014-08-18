# Mice: Email Autocomplete
# A jQuery plugin that suggests and autocompletes the domain in email fields.

# Inspired by the original jQuery Email Autocomplete by Low Yong Zhen <cephyz@gmail.com>
# http://yzlow.github.io/email-autocomplete/demo/

# Copyright (c) 2014 Miclle
# Licensed under MIT (https://github.com/miclle/mice/blob/master/LICENSE)


'use strict'

(($) ->

  # EMAILAUTOCOMPLETE PUBLIC CLASS DEFINITION
  # ===============================
  class EmailAutoComplete
    constructor: (element, options) ->

      @$field = $(element);
      @options = $.extend(true, {}, defaults, options); #we want deep extend
      @_defaults = defaults;
      @_domains = @options.domains;
      @init();


    init: ->
      # shim indexOf
      @doIndexOf() unless Array.prototype.indexOf

      # bind handlers
      @$field.on("keyup.eac", $.proxy(@displaySuggestion, @))
      @$field.on("blur.eac", $.proxy(@autocomplete, @))

      # get input padding,border and margin to offset text
      @fieldLeftOffset = (@$field.outerWidth(true) - @$field.width()) / 2

      # wrap our field
      $wrap = $("<div class='eac-input-wrap' />").css({
        display: @$field.css("display"),
        position: "relative",
        fontSize: @$field.css("fontSize")
      })
      @$field.wrap($wrap)

      # create container to test width of current val
      @$cval = $("<span class='eac-cval' />").css({
        visibility: "hidden",
        position: "absolute",
        display: "inline-block",
        fontFamily: @$field.css("fontFamily"),
        fontWeight: @$field.css("fontWeight"),
        letterSpacing: @$field.css("letterSpacing")
      }).insertAfter(@$field)

      # create the suggestion overlay
      # touchstart jquery 1.7+
      heightPad = (@$field.outerHeight(true) - @$field.height()) / 2 # padding+border
      @$suggOverlay = $("<span class='"+@options.suggClass+"' />").css({
        display: "block",
        "box-sizing": "content-box", # standardize
        lineHeight: @$field.css('lineHeight'),
        paddingTop: heightPad + "px",
        paddingBottom: heightPad + "px",
        fontFamily: @$field.css("fontFamily"),
        fontWeight: @$field.css("fontWeight"),
        letterSpacing: @$field.css("letterSpacing"),
        position: "absolute",
        top: 0,
        left: 0
      }).insertAfter(@$field).on("mousedown.eac touchstart.eac", $.proxy(@autocomplete, this))


    suggest: (str) ->
      str_arr = str.split("@")
      if str_arr.length > 1
        str = str_arr.pop()
        return "" if (!str.length)
      else
        return ""

      match = @_domains.filter( (domain) -> return 0 == domain.indexOf(str) ).shift() || ""

      return match.replace(str, "")


    autocomplete: ->
      return false if(typeof @suggestion == `undefined`)

      @$field.val(@val + @suggestion)
      @$suggOverlay.html("")
      @$cval.html("")


     # Displays the suggestion, handler for field keyup event
    displaySuggestion: (e) ->
      @val = @$field.val()
      @suggestion = @suggest(@val)

      if !@suggestion.length
        @$suggOverlay.html("")
      else
        e.preventDefault()

      # update with new suggestion
      @$suggOverlay.html(@suggestion)
      @$cval.html(@val)

      # find width of current input val so we can offset the suggestion text
      cvalWidth = @$cval.width()

      # offset our suggestion container
      @$suggOverlay.css('left', @fieldLeftOffset + cvalWidth + "px") if(@$field.outerWidth() > cvalWidth)


    # indexof polyfill
    # https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/indexOf#Polyfill
    doIndexOf: ->

      Array.prototype.indexOf = (searchElement, fromIndex) ->
        throw new TypeError( '"this" is null or not defined' ) if ( this == `undefined` || this == null )

        length = @length >>> 0 # Hack to convert object.length to a UInt32

        fromIndex = +fromIndex || 0

        fromIndex = 0 if (Math.abs(fromIndex) == Infinity)

        if (fromIndex < 0)
          fromIndex += length
          fromIndex = 0 if (fromIndex < 0)

        for item in @


        for fromIndex in length
          return fromIndex if @[fromIndex] == searchElement

        return -1


  # EMAILAUTOCOMPLETE PLUGIN DEFINITION
  # =========================
  $.fn.emailautocomplete = (option) ->
    @each ->
      if (!$.data(this, "yz_" + pluginName)) {
        $.data(this, "yz_" + pluginName, new EmailAutoComplete(@, options))
      }

  $.fn.emailautocomplete.Constructor = EmailAutoComplete

  # EMAILAUTOCOMPLETE PLUGIN DEFAULT OPTIONS
  # =========================
  $.fn.emailautocomplete.defaults =
    suggClass: "suggestion"
    domains: ["yahoo.com" ,"google.com" ,"hotmail.com" ,"gmail.com" ,"me.com" ,"aol.com" ,"mac.com" ,"live.com" ,"comcast.net" ,"googlemail.com" ,"msn.com" ,"hotmail.co.uk" ,"yahoo.co.uk" ,"facebook.com" ,"verizon.net" ,"sbcglobal.net" ,"att.net" ,"gmx.com" ,"mail.com" ,"outlook.com" ,"icloud.com"]

  # $ -> $("[data-toggle=emailautocomplete]").emailautocomplete()

  return

) jQuery


