#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

# Public: Handles the interface between Atom and the Tabs to Spaces package.
module.exports =
class TabsToSpaces
  # Public: Converts all leading spaces to tabs in the current buffer.
  tabify: (@editor=atom.workspace.getActiveEditor()) ->
    return unless @editor?
    @replaceWhitespaceWithTabs(@editor.buffer)

  # Public: Converts all leading tabs to spaces in the current editor.
  untabify: (@editor=atom.workspace.getActiveEditor()) ->
    return unless @editor?
    @replaceWhitespaceWithSpaces(@editor.buffer)

  # Private: Counts the number of spaces required to replicate the whitespace combination.
  #
  # text - {String} of whitespace to count the spaces in.
  #
  # Returns the {Number} of spaces represented.
  countSpaces: (text) ->
    count = 0
    for i in [0..text.length]
      switch text[i]
        when ' ' then count += 1
        when '\t' then count += @editor.getTabLength()

    count

  # Private: Creates a string containing `text` concatenated `count` times.
  #
  # text - {String} to repeat.
  # count - {Number} of times to repeat.
  #
  # Returns a {String} with the repeated text.
  multiplyText: (text, count) ->
    Array(count + 1).join(text)

  # Private: Replaces leading whitespace with the appropriate number of spaces.
  #
  # buffer - {TextBuffer} in which to perform the replacement.
  replaceWhitespaceWithSpaces: (buffer) ->
    buffer.transact =>
      buffer.scan /^([ \t]+)/g, ({match, replace}) =>
        count = @countSpaces(match[0])
        replace("#{@multiplyText(' ', count)}")

  # Private: Replaces leading whitespace with the appropriate number of tabs and spaces.
  #
  # Calculates the maximum number of tabs and the minimum number of spaces to fill the whitespace
  # requirement. It then creates a string with that number of tabs followed by that number of
  # spaces.
  #
  # buffer - {TextBuffer} in which to perform the replacement.
  replaceWhitespaceWithTabs: (buffer) ->
    buffer.transact =>
      buffer.scan /^([ \t]+)/g, ({match, replace}) =>
        count = @countSpaces(match[0])
        tabs = count // @editor.getTabLength()
        spaces = count %% @editor.getTabLength()
        replace("#{@multiplyText('\t', tabs)}#{@multiplyText(' ', spaces)}")
