# Public: Handles the interface between Atom and the Tabs to Spaces package.
class TabsToSpaces
  # Private: Regular expression for matching a chunk of whitespace on a line.
  allWhitespace: /[ \t]+/gm

  # Private: Regular expression for matching leading whitespace on a line.
  leadingWhitespace: /^[ \t]+/gm

  # Public: Converts all leading spaces to tabs in the current buffer.
  #
  # * `editor` (optional) {TextEditor} to tabify. Defaults to the active editor.
  tabify: (@editor=atom.workspace.getActiveTextEditor()) ->
    return unless @editor?
    @replaceWhitespaceWithTabs(@editor)

  # Public: Converts all leading tabs to spaces in the current editor.
  #
  # * `editor` (optional) {TextEditor} to untabify. Defaults to the active editor.
  untabify: (@editor=atom.workspace.getActiveTextEditor()) ->
    return unless @editor?
    @replaceWhitespaceWithSpaces(@editor)

  # Public: Converts all tabs to spaces in the current editor.
  #
  # * `editor` (optional) {TextEditor} to untabify. Defaults to the active editor.
  untabifyAll: (@editor=atom.workspace.getActiveTextEditor()) ->
    return unless @editor?
    @replaceAllWhitespaceWithSpaces(@editor)

  # Private: Counts the number of spaces required to replicate the whitespace combination.
  #
  # * `text` {String} of whitespace to count the spaces in.
  #
  # Returns the {Number} of spaces represented.
  countSpaces: (text) ->
    count = 0
    tabLength = @editor.getTabLength()

    for ch in text
      switch ch
        when ' ' then count += 1
        when '\t' then count += tabLength

    count

  # Private: Creates a string containing `text` repeated `count` times.
  #
  # * `text` {String} to repeat.
  # * `count` {Number} of times to repeat.
  #
  # Returns a {String} with the repeated text.
  multiplyText: (text, count) ->
    Array(count + 1).join(text)

  # Private: Replaces all whitespace with the appropriate number of spaces.
  #
  # * `editor` {TextEditor} in which to perform the replacement.
  replaceAllWhitespaceWithSpaces: (editor) ->
    originalText = editor.getText()
    newText = originalText.replace @allWhitespace, (match) =>
      count = @countSpaces(match)
      @multiplyText(' ', count)

    if newText isnt originalText
      editor.setText(newText)

  # Private: Replaces leading whitespace with the appropriate number of spaces.
  #
  # * `editor` {TextEditor} in which to perform the replacement.
  replaceWhitespaceWithSpaces: (editor) ->
    originalText = editor.getText()
    newText = originalText.replace @leadingWhitespace, (match) =>
      count = @countSpaces(match)
      @multiplyText(' ', count)

    if newText isnt originalText
      editor.setText(newText)

  # Private: Replaces leading whitespace with the appropriate number of tabs and spaces.
  #
  # Calculates the maximum number of tabs and the minimum number of spaces to fill the whitespace
  # requirement. It then creates a string with that number of tabs followed by that number of
  # spaces.
  #
  # * `editor` {TextEditor} in which to perform the replacement.
  replaceWhitespaceWithTabs: (editor) ->
    originalText = editor.getText()
    newText = originalText.replace @leadingWhitespace, (match) =>
      count = @countSpaces(match)
      tabs = count // editor.getTabLength()
      spaces = count %% editor.getTabLength()
      "#{@multiplyText('\t', tabs)}#{@multiplyText(' ', spaces)}"

    if newText isnt originalText
      editor.setText(newText)

module.exports = new TabsToSpaces
