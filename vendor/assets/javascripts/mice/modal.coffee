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

      if @options.remote then @$element.find('.modal-content').load(@options.remote, $.proxy( (-> @$element.trigger('loaded.bs.modal')), @))

    toggle: (_relatedTarget) ->
      if @isShown then @hide() else @show(_relatedTarget)

    show: (_relatedTarget) ->
      e = $.Event('show.bs.modal', { relatedTarget: _relatedTarget })

      @$element.trigger(e)

      return if @isShown or e.isDefaultPrevented()

      @isShown = true

      @checkScrollbar()
      @$body.addClass('modal-open')

      @setScrollbar()
      @escape()

      @$element.on('click.dismiss.bs.modal', '[data-dismiss="modal"]', $.proxy(@hide, @))

      @backdrop =>
        transition = $.support.transition and @$element.hasClass('fade')

        if !@$element.parent().length then @$element.appendTo(@$body) # don't move modals dom position

        @$element.show().scrollTop(0)

        if transition then @$element[0].offsetWidth # force reflow

        @$element.addClass('in').attr('aria-hidden', false)

        @enforceFocus()

        e = $.Event('shown.bs.modal', { relatedTarget: _relatedTarget })

        if transition
          @$element.find('.modal-dialog') # wait for modal to slide in
            .one('bsTransitionEnd', -> @$element.trigger('focus').trigger(e))
            .emulateTransitionEnd(300)
        else
          @$element.trigger('focus').trigger(e)

    hide: (e) ->
      e.preventDefault() if e

      e = $.Event('hide.bs.modal')

      @$element.trigger(e)

      return if !@isShown or e.isDefaultPrevented()

      @isShown = false

      @$body.removeClass('modal-open')

      @resetScrollbar()
      @escape()

      $(document).off('focusin.bs.modal')

      @$element.removeClass('in').attr('aria-hidden', true).off('click.dismiss.bs.modal')

      if $.support.transition and @$element.hasClass('fade')
        @$element.one('bsTransitionEnd', $.proxy(@hideModal, @)).emulateTransitionEnd(300)
      else
        @hideModal()

    enforceFocus: ->
      $(document).off('focusin.bs.modal').on('focusin.bs.modal', $.proxy( ((e) -> @$element.trigger('focus') if @$element[0] != e.target and !@$element.has(e.target).length), @))

    escape: ->
      if @isShown and @options.keyboard
        @$element.on('keyup.dismiss.bs.modal', $.proxy( ((e) -> e.which == 27 and @hide()), @))
      else if !@isShown
        @$element.off('keyup.dismiss.bs.modal')

    hideModal: ->
      @$element.hide()
      @backdrop => @$element.trigger('hidden.bs.modal')

    removeBackdrop: ->
      @$backdrop and @$backdrop.remove()
      @$backdrop = null

    backdrop: (callback) ->
      that = this
      animate = if @$element.hasClass('fade') then 'fade' else ''

      if @isShown and @options.backdrop
        doAnimate = $.support.transition and animate

        @$backdrop = $('<div class="modal-backdrop ' + animate + '" />').appendTo(@$body)

        proxy = (e) ->
          return if e.target != e.currentTarget
          if @options.backdrop == 'static' then @$element[0].focus.call(@$element[0]) else @hide.call(@)

        @$element.on 'click.dismiss.bs.modal', $.proxy(proxy, @)

        if doAnimate then @$backdrop[0].offsetWidth # force reflow

        @$backdrop.addClass('in')

        return unless callback

        if doAnimate then @$backdrop.one('bsTransitionEnd', callback).emulateTransitionEnd(150) else callback()

      else if !@isShown and @$backdrop
        @$backdrop.removeClass('in')

        callbackRemove = =>
          @removeBackdrop()
          callback and callback()

        if $.support.transition and @$element.hasClass('fade') then @$backdrop.one('bsTransitionEnd', callbackRemove).emulateTransitionEnd(150) else callbackRemove()

      else if callback
        callback()


    checkScrollbar: ->
      return if document.body.clientWidth >= window.innerWidth
      @scrollbarWidth = @scrollbarWidth or @measureScrollbar()

    setScrollbar: ->
      bodyPad = parseInt((@$body.css('padding-right') or 0), 10)
      if @scrollbarWidth then @$body.css('padding-right', bodyPad + @scrollbarWidth)

    resetScrollbar: ->
      @$body.css('padding-right', '')

    measureScrollbar: -> # thx walsh
      scrollDiv = document.createElement('div')
      scrollDiv.className = 'modal-scrollbar-measure'
      @$body.append(scrollDiv)
      scrollbarWidth = scrollDiv.offsetWidth - scrollDiv.clientWidth
      @$body[0].removeChild(scrollDiv)
      return scrollbarWidth


  # MODAL PLUGIN DEFINITION
  # =======================

  $.fn.modal = (option, _relatedTarget) ->
    @.each ->
      $this   = $(@)
      data    = $this.data('bs.modal')
      options = $.extend({}, $.fn.modal.defaults, $this.data(), typeof option == 'object' and option)

      if !data
        $this.data('bs.modal', (data = new Modal(@, options)))

      if typeof option == 'string'
        data[option](_relatedTarget)

      else if options.show
        data.show(_relatedTarget)


  $.fn.modal.Constructor = Modal

  # TOOLTIP PLUGIN DEFAULT OPTIONS
  # =========================
  $.fn.modal.defaults =
    backdrop: true
    keyboard: true
    show: true


  # MODAL DATA-API
  # ==============

  $(document).on 'click.bs.modal.data-api', '[data-toggle="modal"]', (e) ->
    $this   = $(@)
    href    = $this.attr('href')
    $target = $($this.attr('data-target') or (href and href.replace(/.*(?=#[^\s]+$)/, ''))) # strip for ie7
    option  = if $target.data('bs.modal') then 'toggle' else $.extend({ remote: !/#/.test(href) and href }, $target.data(), $this.data())

    if $this.is('a') then e.preventDefault()

    $target.one 'show.bs.modal', (showEvent) ->
        return if showEvent.isDefaultPrevented() # only register focus restorer if modal will actually get shown
        $target.one 'hidden.bs.modal', -> $this.is(':visible') and $this.trigger('focus')

    # Plugin.call($target, option, @)

    $target.modal option, @

  return

) jQuery