
{$, $$, SelectListView} = require "atom-space-pen-views"

module.exports =
class FocusSearchView extends SelectListView
  parentClass: null

  initialize: (parent) ->
    super
    @addClass('focus-tab')
    @parentClass = parent

  viewForItem: (item) ->
    "<li>#{item}</li>"

  confirmed: (item) ->
    @parentClass?.focusTab(@items.indexOf(item))
    @panel.hide()

  cancelled: ->
    @hide()

  hide: ->
    @panel?.hide()

  show: (files) ->
    @setItems(files)
    @storeFocusedElement()
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()
    @focusFilterEditor()
