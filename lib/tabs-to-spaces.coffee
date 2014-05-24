#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

{Subscriber} = require 'emissary'

# Public: Handles the interface between Atom and the Tabs to Spaces package.
class TabsToSpaces
  Subscriber.includeInto(this)

  spaces = null

  # Public: Converts all leading spaces to tabs in the current buffer.
  tabify: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    @setSpaces(@multiplyText(' ', atom.config.get('editor.tabLength')))
    buffer = editor.buffer

    @replaceSpacesWithTabs(buffer)

  # Public: Converts all leading tabs to spaces in the current editor.
  untabify: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    @setSpaces(@multiplyText(' ', atom.config.get('editor.tabLength')))
    buffer = editor.buffer

    @replaceTabsWithSpaces(buffer)

  # Private: Sets up event handlers.
  #
  # editor - {Editor} to attach the event handlers to.
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

  # Private: Creates a string containing `text` concatenated `count` times.
  #
  # text - {String} to repeat.
  # count - {Number} of times to repeat.
  #
  # Returns a {String} with the repeated text.
  multiplyText: (text, count) ->
    Array(count + 1).join(text)

  # Private: Replaces leading spaces with an integral number of tabs plus
  # a number of spaces necessary to fill in the rest of the space.
  #
  # buffer - {TextBuffer} containing the text to replace spaces with tabs.
  replaceSpacesWithTabs: (buffer) ->
    @replaceTextInBuffer buffer, /^ +/g, (obj) =>
      tabs = @multiplyText("\t", obj.matchText.length // spaces.length)
      text = tabs + @multiplyText(' ', obj.matchText.length %% spaces.length)
      obj.replace(text)

  # Private: Replaces all leading tabs with spaces in the given buffer.
  #
  # buffer - {TextBuffer} containing the text to replace tabs with spaces.
  replaceTabsWithSpaces: (buffer) ->
    @replaceTextInBuffer buffer, /^\t+/g, (obj) =>
      obj.replace(@multiplyText(spaces, obj.matchText.length))

  # Private: Replaces all text that matches the `regex` in `buffer` based on `callback`.
  #
  # buffer - {TextBuffer} in which to replace text.
  # regex - {RegExp} to match. **Must be a global regular expression.**
  # callback - Callback {Function} that matches the signature of the {TextBuffer::scan()} callback.
  replaceTextInBuffer: (buffer, regex, callback) ->
    buffer.transact ->
      buffer.scan regex, (obj) ->
        callback(obj)

  # Private: Sets the number of spaces to replace a single tab character with.
  #
  # spcs - {String} to replace a single tab character with.
  setSpaces: (spcs) ->
    spaces = spcs

module.exports = TabsToSpaces
