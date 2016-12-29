/** @babel */

/**
 * Performs all the tabs-to-spacening and vice versa.
 */
class TabsToSpaces {
  constructor () {
    this.allWhitespace = /[ \t]+/g
    this.leadingWhitespace = /^[ \t]+/g
  }

  /**
   * Public: Converts leading whitespace in `editor` to tabs.
   *
   * * `editor` The editor in which to convert leading whitespace
   */
  tabify (editor = atom.workspace.getActiveTextEditor()) {
    if (!editor) {
      return
    }

    this.replaceWhitespaceWithTabs(editor)
  }

  /**
   * Public: Converts leading whitespace in `editor` to spaces.
   *
   * * `editor` The editor in which to convert leading whitespace
   */
  untabify (editor = atom.workspace.getActiveTextEditor()) {
    if (!editor) {
      return
    }

    this.replaceWhitespaceWithSpaces(editor)
  }

  /**
   * Public: Converts all whitespace in `editor` to spaces.
   *
   * * `editor` The editor in which to convert all whitespace
   */
  untabifyAll (editor = atom.workspace.getActiveTextEditor()) {
    if (!editor) {
      return
    }

    this.replaceAllWhitespaceWithSpaces(editor)
  }

  /**
   * Private: Counts the number of character-widths of `text`.
   *
   * * `text` {String} text to measure
   * * `tabLength` {Number} width of a tab character
   *
   * Returns {Number} of character widths represented by `text`.
   */
  countSpaces (text, tabLength) {
    let count = 0

    for (let ch of text) {
      if (ch === ' ') {
        count += 1
      } else if (ch === '\t') {
        count += tabLength
      }
    }

    return count
  }

  /**
   * Private: Multiplies `text` by `count`.
   *
   * * `text` {String} to multiply
   * * `count` {Number} of times to repeat `text`
   *
   * Returns {String} of `text` repeated `count` times.
   */
  multiplyText (text, count) {
    if (isNaN(count) || count === 0) {
      return ''
    }

    return Array(count + 1).join(text)
  }

  replaceAllWhitespaceWithSpaces (editor) {
    editor.transact(() => {
      editor.scan(this.allWhitespace, ({matchText, replace}) => {
        const count = this.countSpaces(matchText, editor.getTabLength())
        replace(this.multiplyText(' ', count))
      })
    })
  }

  replaceWhitespaceWithSpaces (editor) {
    const tabLength = editor.getTabLength()
    const buffer = editor.getBuffer()

    this.processBufferByLine(buffer, ({line, row}) => {
      const match = line.match(this.leadingWhitespace)

      if (match) {
        const matchText = match[0]
        const count = this.countSpaces(matchText, tabLength)
        const replacementText = this.multiplyText(' ', count)

        buffer.setTextInRange([[row, 0], [row, matchText.length]], replacementText, { undo: 'skip' })
      }
    })
  }

  replaceWhitespaceWithTabs (editor) {
    const tabLength = editor.getTabLength()
    const buffer = editor.getBuffer()

    this.processBufferByLine(buffer, ({line, row}) => {
      const match = line.match(this.leadingWhitespace)

      if (match) {
        const matchText = match[0]
        const count = this.countSpaces(matchText, tabLength)
        const tabs = Math.floor(count / tabLength)
        const spaces = count % tabLength
        const replacementText = this.multiplyText('\t', tabs) + this.multiplyText(' ', spaces)

        buffer.setTextInRange([[row, 0], [row, matchText.length]], replacementText, { undo: 'skip' })
      }
    })
  }

  processBufferByLine (buffer, fn) {
    buffer.transact(() => {
      for (let row = 0, lineCount = buffer.getLineCount(); row < lineCount; ++row) {
        const line = buffer.lineForRow(row)

        fn({ line: line, row: row })
      }
    })
  }
}

module.exports = new TabsToSpaces()
