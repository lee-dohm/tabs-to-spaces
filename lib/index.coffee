#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

TabsToSpaces = null
tabsToSpaces = null

module.exports =
  config:
    onSave:
      type: 'string'
      default: 'none'
      enum: ['none', 'tabify', 'untabify']

  # Public: Activates the package.
  activate: ->
    atom.commands.add 'atom-workspace',
      'tabs-to-spaces:tabify': ->
        loadModule()
        tabsToSpaces.tabify()

      'tabs-to-spaces:untabify': ->
        loadModule()
        tabsToSpaces.untabify()

    atom.workspace.observeTextEditors (editor) ->
      handleEvents(editor)

# Private: Creates event handlers.
#
# * `editor` {TextEditor} to attach the event handlers to
handleEvents = (editor) ->
  buffer = editor.getBuffer()
  buffer.onWillSave ->
    return if editor.getPath() is atom.config.getUserConfigPath()

    grammar = editor.getGrammar()
    switch atom.config.get([".#{grammar.scopeName}"], 'tabs-to-spaces.onSave')
      when 'untabify'
        loadModule()
        tabsToSpaces.untabify()
      when 'tabify'
        loadModule()
        tabsToSpaces.tabify()

# Private: Loads the module on-demand.
loadModule = ->
  TabsToSpaces ?= require './tabs-to-spaces'
  tabsToSpaces ?= new TabsToSpaces()
