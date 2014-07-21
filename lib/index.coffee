#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

TabsToSpaces = null
tabsToSpaces = null

module.exports =
  configDefaults:
    onSave: ''

  activate: ->
    atom.workspaceView.command 'tabs-to-spaces:tabify', ->
      loadModule()
      tabsToSpaces.tabify()

    atom.workspaceView.command 'tabs-to-spaces:untabify', ->
      loadModule()
      tabsToSpaces.untabify()

    atom.workspace.eachEditor (editor) ->
      handleEvents(editor)

# Internal: Sets up event handlers.
#
# editor - {Editor} to attach the event handlers to.
handleEvents = (editor) ->
  buffer = editor.getBuffer()
  buffer.on 'will-be-saved', ->
    if atom.config.get('tabs-to-spaces.onSave') is 'untabify'
      loadModule()
      tabsToSpaces.untabify()
    else if atom.config.get('tabs-to-spaces.onSave') is 'tabify'
      loadModule()
      tabsToSpaces.tabify()

# Internal: Loads the module on-demand.
loadModule = ->
  TabsToSpaces ?= require './tabs-to-spaces'
  tabsToSpaces ?= new TabsToSpaces()
