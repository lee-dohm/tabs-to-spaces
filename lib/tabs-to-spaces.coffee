#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

# Public: Handles the interface between Atom and the Tabs to Spaces package.
module.exports =
class TabsToSpaces
  spaces = null

  # Public: Converts all leading spaces to tabs in the current buffer.
  tabify: (@editor=atom.workspace.getActiveEditor()) ->
    return unless @editor?
    @replaceSpacesWithTabs(@editor.buffer)

  # Public: Converts all leading tabs to spaces in the current editor.
  untabify: (@editor=atom.workspace.getActiveEditor()) ->
    return unless @editor?
    @replaceTabsWithSpaces(@editor.buffer)

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
    @setSpaces()
    @replaceTextInBuffer buffer, /^ +/g, @replaceSpacesWithTabsHandler

  # Private: Handles an individual replacement of spaces with tabs.
  #
  # obj - An {Object} conforming to the interface of the {TextBuffer::scan()} callback parameter.
  replaceSpacesWithTabsHandler: (obj) =>
    tabs = @multiplyText("\t", obj.matchText.length // spaces.length)
    text = tabs + @multiplyText(' ', obj.matchText.length %% spaces.length)
    obj.replace(text)

  # Private: Replaces all leading tabs with spaces in the given buffer.
  #
  # buffer - {TextBuffer} containing the text to replace tabs with spaces.
  replaceTabsWithSpaces: (buffer) ->
    @setSpaces()
    @replaceTextInBuffer buffer, /^\t+/g, @replaceTabsWithSpacesHandler

  # Private: Handles an individual replacement of tabs with spaces.
  #
  # obj - An {Object} conforming to the interface of the {TextBuffer::scan()} callback parameter.
  replaceTabsWithSpacesHandler: (obj) =>
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
  setSpaces: ->
    spaces = @multiplyText(' ', @editor.getTabLength())
