'use strict';

(($) ->

  # MODAL CLASS DEFINITION
  # ======================

  class Modal
    constructor: (element, options) ->
      @options        = options
      @$body          = $(document.body)
      @$element       = $(element)
      @$backdrop
      @isShown        = null
      @scrollbarWidth = 0

      if @options.remote
        @$element.find('.modal-content').load(@options.remote, $.proxy( (-> @$element.trigger('loaded.bs.modal')) , @))

  Modal.VERSION  = '3.2.0'

  Modal.DEFAULTS =
    backdrop: true
    keyboard: true
    show: true


  Modal::toggle = (_relatedTarget) ->
    if @isShown then @hide() else @show(_relatedTarget)


  Modal::show = (_relatedTarget) ->
    that = @
    e    = $.Event('show.bs.modal', relatedTarget: _relatedTarget)

    @$element.trigger(e)

    return if (@isShown || e.isDefaultPrevented())

    @isShown = true

    @checkScrollbar()
    @$body.addClass('modal-open')

    @setScrollbar()
    @escape()

    @$element.on 'click.dismiss.bs.modal', '[data-dismiss="modal"]', $.proxy(@hide, @)

    @backdrop =>
      transition = $.support.transition && that.$element.hasClass('fade')

      @$element.appendTo(@$body) unless @$element.parent().length # don't move modals dom position

      @$element.show().scrollTop(0)

      @$element[0].offsetWidth if transition # force reflow

      @$element.addClass('in').attr('aria-hidden', false)

      @enforceFocus()

      e = $.Event('shown.bs.modal', relatedTarget: _relatedTarget)

      if transition
        @$element.find('.modal-dialog') # wait for modal to slide in
          .one 'miceTransitionEnd', -> @$element.trigger('focus').trigger(e)
          .emulateTransitionEnd(300)
      else
        @$element.trigger('focus').trigger(e)


  Modal::hide = (e) ->
    if (e) then e.preventDefault()

    e = $.Event('hide.bs.modal')

    @$element.trigger(e)

    return if (!@isShown || e.isDefaultPrevented())

    @isShown = false

    @$body.removeClass('modal-open')

    @resetScrollbar()
    @escape()

    $(document).off('focusin.bs.modal')

    @$element
      .removeClass('in')
      .attr('aria-hidden', true)
      .off('click.dismiss.bs.modal')

    if $.support.transition && @$element.hasClass('fade')
      @$element
        .one('miceTransitionEnd', $.proxy(@hideModal, @))
        .emulateTransitionEnd(300)
    else
      @hideModal()


  Modal::enforceFocus = ->
    $(document)
      .off 'focusin.bs.modal' # guard against infinite focus loop
      .on 'focusin.bs.modal',
        $.proxy (e) ->
          if @$element[0] != e.target && !@$element.has(e.target).length
            @$element.trigger('focus')
        , @


  Modal::escape = ->
    if @isShown && @options.keyboard
      @$element.on 'keyup.dismiss.bs.modal',
        $.proxy (e) ->
          e.which == 27 && @hide()
        , @
    else if !@isShown
      @$element.off('keyup.dismiss.bs.modal')


  Modal::hideModal = ->
    that = @
    @$element.hide()
    @backdrop -> that.$element.trigger('hidden.bs.modal')


  Modal::removeBackdrop = ->
    @$backdrop && @$backdrop.remove()
    @$backdrop = null


  Modal::backdrop = (callback) ->
    that = this
    animate = if @$element.hasClass('fade') then 'fade' else ''

    if @isShown && @options.backdrop
      doAnimate = $.support.transition && animate

      @$backdrop = $('<div class="modal-backdrop ' + animate + '" />').appendTo(@$body)

      @$element.on 'click.dismiss.bs.modal',
        $.proxy (e) ->
          return if e.target != e.currentTarget
          if @options.backdrop == 'static' then @$element[0].focus.call(@$element[0]) else @hide.call(this)
        , this

      @$backdrop[0].offsetWidth if doAnimate # force reflow

      @$backdrop.addClass('in')

      return unless callback

      if doAnimate
        @$backdrop.one('miceTransitionEnd', callback).emulateTransitionEnd(150)
      else
        callback()

    else if !@isShown && @$backdrop
      @$backdrop.removeClass('in')

      callbackRemove = ->
        that.removeBackdrop()
        callback && callback()

      if $.support.transition && @$element.hasClass('fade')
        @$backdrop
          .one('miceTransitionEnd', callbackRemove)
          .emulateTransitionEnd(150)
      else
        callbackRemove()

    else if callback
      callback()


  Modal::checkScrollbar = ->
    return if document.body.clientWidth >= window.innerWidth
    @scrollbarWidth = @scrollbarWidth || @measureScrollbar()


  Modal::setScrollbar = ->
    bodyPad = parseInt @$body.css('padding-right') || 0, 10
    @$body.css('padding-right', bodyPad + @scrollbarWidth) if @scrollbarWidth


  Modal::resetScrollbar = ->
    @$body.css 'padding-right', ''


  Modal::measureScrollbar = -> # thx walsh
    scrollDiv = document.createElement('div')
    scrollDiv.className = 'modal-scrollbar-measure'
    @$body.append(scrollDiv)
    scrollbarWidth = scrollDiv.offsetWidth - scrollDiv.clientWidth
    @$body[0].removeChild(scrollDiv)
    scrollbarWidth


  # MODAL PLUGIN DEFINITION
  # =======================

  Plugin = (option, _relatedTarget) ->
    @each ->
      $element   = $(@)
      data    = $element.data('bs.modal')
      options = $.extend({}, Modal.DEFAULTS, $element.data(), typeof option == 'object' && option)

      if (!data)
        $element.data 'bs.modal', (data = new Modal(@, options))

      if typeof option == 'string'
        data[option](_relatedTarget)

      else if options.show
        data.show(_relatedTarget)

  old = $.fn.modal

  $.fn.modal             = Plugin
  $.fn.modal.Constructor = Modal


  # MODAL NO CONFLICT
  # =================

  $.fn.modal.noConflict = ->
    $.fn.modal = old
    @


  # MODAL DATA-API
  # ==============

  $(document).on 'click.bs.modal.data-api',
    '[data-toggle="modal"]',
    (e) ->
      $element  = $(@)
      href      = $element.attr('href')
      $target   = $($element.attr('data-target') || (href && href.replace(/.*(?=#[^\s]+$)/, ''))) # strip for ie7
      option    = if $target.data('bs.modal') then 'toggle' else $.extend({ remote: !/#/.test(href) && href }, $target.data(), $element.data())

      e.preventDefault() if $element.is('a')

      $target.one 'show.bs.modal', (showEvent) ->
        return if (showEvent.isDefaultPrevented()) # only register focus restorer if modal will actually get shown
        $target.one 'hidden.bs.modal', -> $element.is(':visible') && $element.trigger('focus')

      Plugin.call($target, option, @)

  return

) jQuery