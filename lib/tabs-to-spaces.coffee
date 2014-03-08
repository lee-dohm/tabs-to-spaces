#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

# Handles the interface between Atom and the Tabs to Spaces package.
class TabsToSpaces
  spaces = null

  # Activates the package.
  activate: ->
    atom.workspaceView.command 'tabs-to-spaces:convert', => @convert()

  # Converts all leading tabs to spaces in the current editor window.
  #
  # Sets the cursor position to the top of the file when complete.
  convert: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    spaces = Array(atom.config.get('editor.tabLength') + 1).join(' ')
    editor.transact =>
      editor.selectAll()
      editor.splitSelectionsIntoLines()
      @replaceTabsWithSpaces(selection) for selection in editor.getSelections()
    editor.setCursorBufferPosition([0, 0])

  # Replaces all leading tabs with spaces in the given selection.
  #
  # @private
  # @param [Selection] selection Selection within which to replace tabs with spaces.
  replaceTabsWithSpaces: (selection) ->
    text = selection.getText()
    newText = text.replace /^\t+/, ''
    indentation = Array(text.length - newText.length + 1).join(spaces)
    selection.insertText(indentation + newText)
    selection.clear()

  # Sets the number of spaces to replace a single tab character with.
  #
  # @private
  # @param [String] spcs Text to replace a single tab character with.
  setSpaces: (spcs) ->
    spaces = spcs

module.exports = new TabsToSpaces
