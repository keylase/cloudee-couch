Spine = require('spine')
App = require('../index')

focusedController = null;

class Controller extends Spine.Controller
  selectedIndex: 0
  selected: false
  elements:
    '.f': 'els'

  constructor: ->
    super
    Spine.bind 'keypress', @keypress
    @bind 'left', @left
    @bind 'right', @right
    @bind 'down', @down
    @bind 'up', @up
    @bind 'enter', @enter

    @bind 'blur', @blur
    @bind 'focus', @focus

    # Manage only one controller each time in focus
    @active ->
      focusedController.trigger('blur') if focusedController
      focusedController = @
      focusedController.trigger('focus')

  blur: ->
    @el.removeClass('focus')

  focus:->
    @el.addClass('focus')

  render: ->
    @refreshElements()
    @select() if @els?.length

  selectedEl: ->
    $(@els[@selectedIndex])

  select: ->
    @selectedEl().addClass('select')

  deselect: ->
    @selectedEl().removeClass('select')

  nextSelect: ->
    @selectedIndex = if @selectedIndex>=@els.length-1 then 0 else @selectedIndex+1

  prevSelect: ->
    @selectedIndex = if @selectedIndex>0 then @selectedIndex-1 else @els.length-1

  keypress: (e) =>
    return true unless focusedController is @
    @trigger 'left' if e.keyCode==37
    return true if (!@els || !@els.length) && e.keyCode!=37
    @trigger 'right' if e.keyCode==39
    @trigger 'down' if e.keyCode==40
    @trigger 'up' if e.keyCode==38
    @trigger 'enter' if e.keyCode==13
    return false

  down: ->
#    @log 'down'
    @deselect()
    @nextSelect()
    @select()

  up: ->
#    @log 'up'
    @deselect()
    @prevSelect()
    @select()

  navigateBack: ->
    @navigate false

  left: ->
#    @log 'left'
    @navigateBack()

  right: ->
#    @log 'right'

  enter: ->
#    @log 'enter'
    return true unless @els.length
    href = @selectedEl().attr('href')
    # substr(1) for removing the # from the url
    return @navigate href.substring(1) if href
    item = @selectedEl().data('item')
    @log 'item', item, item.name
#    @navigate @item.couchUrl

    return false

  log: ->
    console.info.apply console, arguments

module.exports = Controller