#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

{Subscriber} = require 'emissary'

# Handles the interface between Atom and the Tabs to Spaces package.
class TabsToSpaces
  Subscriber.includeInto(this)

  spaces = null

  # Activates the package.
  activate: ->
    atom.workspaceView.command 'tabs-to-spaces:tabify', => @tabify()
    atom.workspaceView.command 'tabs-to-spaces:untabify', => @untabify()

    @subscribe atom.workspace.eachEditor (editor) =>
      @handleEvents(editor)

  # Converts all leading spaces to tabs in the current buffer.
  tabify: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    @setSpaces(@multiplyText(' ', atom.config.get('editor.tabLength')))
    buffer = editor.buffer

    @replaceSpacesWithTabs(buffer)

  # Converts all leading tabs to spaces in the current editor.
  untabify: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    @setSpaces(@multiplyText(' ', atom.config.get('editor.tabLength')))
    buffer = editor.buffer

    @replaceTabsWithSpaces(buffer)

  # Sets up event handlers.
  #
  # @private
  # @param [Editor] editor Editor for which to attach event handlers.
  handleEvents: (editor) ->
    buffer = editor.getBuffer()
    bufferSubscription = @subscribe buffer, 'will-be-saved', =>
      if atom.config.get('tabs-to-spaces.onSave') == 'untabify'
        @untabify()
      else if atom.config.get('tabs-to-spaces.onSave') == 'tabify'
        @tabify()

    @subscribe editor, 'destroyed', ->
      bufferSubscription.off()

    @subscribe buffer, 'destroyed', =>
      @unsubscribe(buffer)

  # Creates a string containing `text` concatenated `count` times.
  #
  # @private
  # @param [String] text Text to repeat.
  # @paarm [Number] count Number of times to repeat.
  # @return [String] Repeated text.
  multiplyText: (text, count) ->
    Array(count + 1).join(text)

  # Replaces leading spaces with an integral number of tabs plus the
  # a number of spaces necessary to fill in the rest of the space.
  #
  # @private
  # @param [TextBuffer] buffer Buffer within which to replace the spaces with tabs.
  replaceSpacesWithTabs: (buffer) ->
    @replaceTextInBuffer buffer, /^ +/g, (obj) =>
      tabs = @multiplyText("\t", obj.matchText.length // spaces.length)
      text = tabs + @multiplyText(' ', obj.matchText.length %% spaces.length)
      obj.replace(text)

  # Replaces all leading tabs with spaces in the given buffer.
  #
  # @private
  # @param [TextBuffer] buffer Buffer within which to replace tabs with spaces.
  replaceTabsWithSpaces: (buffer) ->
    @replaceTextInBuffer buffer, /^\t+/g, (obj) =>
      obj.replace(@multiplyText(spaces, obj.matchText.length))

  # Replaces all text that matches the `regex` in `buffer` based on `callback`.
  #
  # @param [TextBuffer] buffer Buffer in which to replace text.
  # @param [RegExp] regex Regular expression to match. **Must be a global regular expression.**
  # @param [Function] callback Callback that matches the signature of the `TextBuffer.scan()`
  #   callback.
  replaceTextInBuffer: (buffer, regex, callback) ->
    buffer.transact ->
      buffer.scan regex, (obj) ->
        callback(obj)

  # Sets the number of spaces to replace a single tab character with.
  #
  # @private
  # @param [String] spcs Text to replace a single tab character with.
  setSpaces: (spcs) ->
    spaces = spcs

module.exports = new TabsToSpaces
