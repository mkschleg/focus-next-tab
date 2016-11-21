FocusSearchView = require './focus-search-view'
{CompositeDisposable} = require 'atom'

module.exports = FocusNextTab =
  subscriptions: null

  currentPane: null
  currentItemIndex: -1

  FocusSearchView: null

  activate: (state) ->

    @didChangeActivePane(atom.workspace.getActivePane())

    @FocusSearchView = new FocusSearchView(this)

    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
    'focus-next-tab:Left': => @focusTabLeft()
    'focus-next-tab:Right': => @focusTabRight()
    'focus-next-tab:Search': => @focusTabSearch()
    # coffeelint: disable=max_line_length
    @subscriptions.add atom.workspace.onDidChangeActivePane (pane) => @didChangeActivePane(pane)
    @subscriptions.add atom.workspace.onDidChangeActivePaneItem (item) => @didChangeActivePaneItem()
    # coffeelint: enable=max_line_length

  deactivate: ->
    @subscriptions?.dispose()

  focusTab: (paneItemIndex) ->
    @currentItemIndex = paneItemIndex
    @currentPane.activateItemAtIndex(paneItemIndex)
    console.log @currentPane
    console.log @currentItemIndex

  focusTabLeft: ->
    @focusTab(if @currentItemIndex - 1 < 0 then 0 else @currentItemIndex - 1)

  focusTabRight: ->
    if @currentItemIndex + 1 >= @currentPane.getItems().length-1
      @i = @currentPane.getItems().length-1
    else
      @i = @currentItemIndex + 1
    @focusTab(@i)

  focusTabSearch: ->
    @showFocusSearchView()

  showFocusSearchView: ->
    @focusSearchView ?= new FocusSearchView(this)
    # coffeelint: disable=max_line_length
    @items = ((if item.getLongTitle? then item.getLongTitle() else item.getTitle()) for item in @currentPane.getItems())
    # coffeelint: enable=max_line_length
    @focusSearchView.show(@items)

  didChangeActivePane: (pane) ->
    @currentPane = pane
    @currentItemIndex = @currentPane?.getActiveItemIndex()

  didChangeActivePaneItem: ->
    if (@currentItemIndex != @currentPane?.getActiveItemIndex())
      @currentItemIndex = @currentPane?.getActiveItemIndex()
