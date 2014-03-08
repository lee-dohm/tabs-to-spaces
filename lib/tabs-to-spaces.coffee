#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

class TabsToSpaces
  spaces = null

  activate: ->
    atom.workspaceView.command 'tabs-to-spaces:convert', => @convert()

  convert: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    spaces = Array(atom.config.get('editor.tabLength') + 1).join(' ')
    editor.transact =>
      editor.selectAll()
      editor.splitSelectionsIntoLines()
      @replaceTabsWithSpaces(selection) for selection in editor.getSelections()
    editor.setCursorBufferPosition([0, 0])

  replaceTabsWithSpaces: (selection) ->
    text = selection.getText()
    newText = text.replace /^\t+/, ''
    indentation = Array(text.length - newText.length + 1).join(spaces)
    selection.insertText(indentation + newText)
    selection.clear()

  setSpaces: (spcs) ->
    spaces = spcs

module.exports = new TabsToSpaces
