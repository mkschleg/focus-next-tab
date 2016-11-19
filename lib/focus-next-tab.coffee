FocusNextTabView = require './focus-next-tab-view'
{CompositeDisposable} = require 'atom'

module.exports = FocusNextTab =
  focusNextTabView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @focusNextTabView = new FocusNextTabView(state.focusNextTabViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @focusNextTabView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'focus-next-tab:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @focusNextTabView.destroy()

  serialize: ->
    focusNextTabViewState: @focusNextTabView.serialize()

  toggle: ->
    console.log 'FocusNextTab was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
