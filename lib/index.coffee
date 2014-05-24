#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

TabsToSpaces = null
tabsToSpaces = null

# Loads the module on-demand.
loadModule = ->
  TabsToSpaces ?= require './tabs-to-spaces'
  tabsToSpaces ?= new TabsToSpaces()

module.exports =
  activate: ->
    atom.workspaceView.command 'tabs-to-spaces:tabify', ->
      loadModule()
      tabsToSpaces.tabify()

    atom.workspaceView.command 'tabs-to-spaces:untabify', ->
      loadModule()
      tabsToSpaces.untabify()

    atom.workspace.eachEditor (editor) ->
      tabsToSpaces.handleEvents(editor)
