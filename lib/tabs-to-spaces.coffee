#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

# Handles the interface between Atom and the Tabs to Spaces package.
class TabsToSpaces
  spaces = null

  # Activates the package.
  activate: ->
    atom.workspaceView.command 'tabs-to-spaces:untabify', => @untabify()

  # Converts all leading tabs to spaces in the current editor window.
  #
  # Sets the cursor position to the top of the file when complete.
  untabify: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    @setSpaces(@multiplyText(' ', atom.config.get('editor.tabLength')))
    buffer = editor.buffer

    @replaceTabsWithSpaces(buffer)

  # Creates a string containing `text` concatenated `count` times.
  #
  # @private
  # @param [String] text Text to repeat.
  # @paarm [Number] count Number of times to repeat.
  # @return [String] Repeated text.
  multiplyText: (text, count) ->
    Array(count + 1).join(text)

  # Replaces all leading tabs with spaces in the given selection.
  #
  # @private
  # @param [Selection] selection Selection within which to replace tabs with spaces.
  replaceTabsWithSpaces: (buffer) ->
    buffer.transact =>
      buffer.scan /^\t+/g, (obj) =>
        obj.replace(@multiplyText(spaces, obj.matchText.length))

  # Sets the number of spaces to replace a single tab character with.
  #
  # @private
  # @param [String] spcs Text to replace a single tab character with.
  setSpaces: (spcs) ->
    spaces = spcs

module.exports = new TabsToSpaces
