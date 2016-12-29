/** @babel */

class TabsToSpaces {
  constructor () {
    this.allWhitespace = /[ \t]+/g
    this.leadingWhitespace = /^[ \t]+/g
  }

  tabify (editor = atom.workspace.getActiveTextEditor()) {
    if (!editor) {
      return
    }

    this.replaceWhitespaceWithTabs(editor)
  }

  untabify (editor = atom.workspace.getActiveTextEditor()) {
    if (!editor) {
      return
    }

    this.replaceWhitespaceWithSpaces(editor)
  }

  untabifyAll (editor = atom.workspace.getActiveTextEditor()) {
    if (!editor) {
      return
    }

    this.replaceAllWhitespaceWithSpaces(editor)
  }

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
    editor.transact(() => {
      editor.scan(this.leadingWhitespace, ({matchText, replace}) => {
        const count = this.countSpaces(matchText, editor.getTabLength())
        replace(this.multiplyText(' ', count))
      })
    })
  }

  replaceWhitespaceWithTabs (editor) {
    let tabLength = editor.getTabLength()

    editor.transact(() => {
      editor.scan(this.leadingWhitespace, ({matchText, replace}) => {
        const count = this.countSpaces(matchText, tabLength)
        const tabs = Math.floor(count / tabLength)
        const spaces = count % tabLength
        replace(this.multiplyText('\t', tabs) + this.multiplyText(' ', spaces))
      })
    })
  }
}

module.exports = new TabsToSpaces()
