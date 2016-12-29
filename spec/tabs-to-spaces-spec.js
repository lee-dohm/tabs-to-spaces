/** @babel */

import fs from 'fs'
import path from 'path'
import temp from 'temp'

const rimraf = require('rimraf')
const tabsToSpaces = require('../lib/tabs-to-spaces')
const helper = require('./spec-helper')

describe('Tabs To Spaces', function () {
  let directory, editor, filePath, workspaceElement

  beforeEach(function () {
    directory = temp.mkdirSync()
    atom.project.setPaths([directory])
    workspaceElement = atom.views.getView(atom.workspace)
    filePath = path.join(directory, 'tabs-to-spaces.txt')

    fs.writeFileSync(filePath, '')
    atom.config.set('editor.tabLength', 4)

    waitsForPromise(() => {
      return Promise.all([
        atom.workspace.open(filePath).then((e) => {
          editor = e
        }),
        atom.packages.activatePackage('tabs-to-spaces'),
        atom.packages.activatePackage('language-javascript')
      ])
    })
  })

  afterEach(() => {
    rimraf.sync(directory)
  })

  describe('activate', function () {
    it('creates the commands', function () {
      expect(helper.hasCommand(workspaceElement, 'tabs-to-spaces:tabify')).toBeTruthy()
      expect(helper.hasCommand(workspaceElement, 'tabs-to-spaces:untabify')).toBeTruthy()
      expect(helper.hasCommand(workspaceElement, 'tabs-to-spaces:untabify-all')).toBeTruthy()
    })
  })

  describe('deactivate', function () {
    beforeEach(function () {
      atom.packages.deactivatePackage('tabs-to-spaces')
    })

    it('destroys the commands', function () {
      expect(helper.hasCommand(workspaceElement, 'tabs-to-spaces:tabify')).toBeFalsy()
      expect(helper.hasCommand(workspaceElement, 'tabs-to-spaces:untabify')).toBeFalsy()
      expect(helper.hasCommand(workspaceElement, 'tabs-to-spaces:untabify-all')).toBeFalsy()
    })
  })

  describe('tabify', function () {
    beforeEach(function () {
      editor.setTabLength(3)
    })

    it('does not change an empty file', function () {
      tabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe('')
    })

    it('does not change spaces at the end of a line', function () {
      editor.setText('foobarbaz     ')
      tabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe('foobarbaz     ')
    })

    it('does not change spaces in the middle of a line', function () {
      editor.setText('foo    bar    baz')
      tabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe('foo    bar    baz')
    })

    it('converts one tab worth of spaces to a single tab', function () {
      editor.setTabLength(2)
      editor.setText('  foo')
      tabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe('\tfoo')
    })

    it('converts almost two tabs worth of spaces to one tab and some spaces', function () {
      editor.setTabLength(4)
      editor.setText('       foo')
      tabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe('\t   foo')
    })

    it('changes multiple lines of leading spaces to tabs', function () {
      editor.setTabLength(4)
      editor.setText('    foo\n       bar')
      tabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe('\tfoo\n\t   bar')
    })

    it('leaves successive newlines alone', function () {
      editor.setTabLength(2)
      editor.setText('  foo\n\n  bar\n\n  baz\n\n')
      tabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe('\tfoo\n\n\tbar\n\n\tbaz\n\n')
    })

    it('changes mixed spaces and tabs to uniform whitespace', function () {
      editor.setTabLength(2)
      editor.setText('\t \tfoo\n')
      tabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe('\t\t foo\n')
    })
  })

  describe('untabify', function () {
    beforeEach(function () {
      editor.setTabLength(3)
    })

    it('does not change an empty file', function () {
      tabsToSpaces.untabify(editor)
      expect(editor.getText()).toBe('')
    })

    it('does not change tabs at the end of a string', function () {
      editor.setText('foobarbaz\t')
      tabsToSpaces.untabify(editor)
      expect(editor.getText()).toBe('foobarbaz\t')
    })

    it('does not change tabs in the middle of a string', function () {
      editor.setText('foo\tbar\tbaz')
      tabsToSpaces.untabify(editor)
      expect(editor.getText()).toBe('foo\tbar\tbaz')
    })

    it('changes one tab to the correct number of spaces', function () {
      editor.setTabLength(2)
      editor.setText('\tfoo')
      tabsToSpaces.untabify(editor)
      expect(editor.getText()).toBe('  foo')
    })

    it('changes two tabs to the correct number of spaces', function () {
      editor.setTabLength(2)
      editor.setText('\t\tfoo')
      tabsToSpaces.untabify(editor)
      expect(editor.getText()).toBe('    foo')
    })

    it('changes multiple lines of leading whitespace to spaces', function () {
      editor.setTabLength(2)
      editor.setText('\t\tfoo\n\t\tbar\n\n')
      tabsToSpaces.untabify(editor)
      expect(editor.getText()).toBe('    foo\n    bar\n\n')
    })

    it('changes mixed spaces and tabs to uniform whitespace', function () {
      editor.setTabLength(2)
      editor.setText(' \t foo\n')
      tabsToSpaces.untabify(editor)
      expect(editor.getText()).toBe('    foo\n')
    })
  })

  describe('untabify all', function () {
    beforeEach(function () {
      editor.setTabLength(3)
    })

    it('does not change an empty file', function () {
      tabsToSpaces.untabifyAll(editor)
      expect(editor.getText()).toBe('')
    })

    it('does change tabs at the end of a string', function () {
      editor.setText('foobarbaz\t')
      tabsToSpaces.untabifyAll(editor)
      expect(editor.getText()).toBe('foobarbaz   ')
    })

    it('does change tabs in the middle of a string', function () {
      editor.setText('foo\tbar\tbaz')
      tabsToSpaces.untabifyAll(editor)
      expect(editor.getText()).toBe('foo   bar   baz')
    })

    it('changes one tab to the correct number of spaces', function () {
      editor.setTabLength(2)
      editor.setText('\tfoo')
      tabsToSpaces.untabifyAll(editor)
      expect(editor.getText()).toBe('  foo')
    })

    it('changes two tabs to the correct number of spaces', function () {
      editor.setTabLength(2)
      editor.setText('\t\tfoo')
      tabsToSpaces.untabifyAll(editor)
      expect(editor.getText()).toBe('    foo')
    })

    it('changes multiple lines of tabs to spaces', function () {
      editor.setTabLength(2)
      editor.setText('\t\tfoo\n\t\tbar\n\n')
      tabsToSpaces.untabifyAll(editor)
      expect(editor.getText()).toBe('    foo\n    bar\n\n')
    })

    it('changes mixed spaces and tabs to uniform whitespace', function () {
      editor.setTabLength(2)
      editor.setText(' \t foo\n')
      tabsToSpaces.untabifyAll(editor)
      expect(editor.getText()).toBe('    foo\n')
    })
  })

  describe('on save', function () {
    beforeEach(function () {
      atom.config.set('tabs-to-spaces.onSave', 'untabify')
    })

    it('will untabify before an editor save a buffer', function () {
      atom.config.set('tabs-to-spaces.onSave', 'untabify')
      editor.setText('\t\tfoo\n\t\tbar\n\n')
      editor.save()
      expect(editor.getText()).toBe('        foo\n        bar\n\n')
    })

    it('will tabify before an editor saves a buffer', function () {
      atom.config.set('tabs-to-spaces.onSave', 'tabify')
      editor.setText('        foo\n        bar\n\n')
      editor.save()
      expect(editor.getText()).toBe('\t\tfoo\n\t\tbar\n\n')
    })

    describe('with scope-specific configuration', function () {
      beforeEach(function () {
        atom.config.set('editor.tabLength', 2, { scope: '.text.plain' })
        atom.config.set('tabs-to-spaces.onSave', 'tabify', { scope: '.text.plain' })
        const filePath = path.join(directory, 'sample.txt')
        fs.writeFileSync(filePath, 'Some text.\n')

        waitsForPromise(() => {
          return atom.workspace.open(filePath).then((e) => {
            editor = e
          })
        })

        runs(() => {
          buffer = editor.getBuffer()
        })
      })

      it('respects the overridden configuration', function () {
        editor.setText('    foo\n    bar\n\n')
        editor.save()
        expect(editor.getText()).toBe('\t\tfoo\n\t\tbar\n\n')
      })

      it('does not modify the contents of the user configuration file', function () {
        spyOn(atom.config, 'getUserConfigPath').andReturn(filePath)
        spyOn(editor, 'getPath').andReturn(filePath)

        editor.setText('    foo\n    bar\n\n')
        editor.save()
        expect(editor.getText()).toBe('    foo\n    bar\n\n')
      })
    })
  })

  describe('invariants', function () {
    beforeEach(function () {
      editor.setText(fs.readFileSync(__filename, 'utf8'))
    })

    it('does not move the position of the cursor', function () {
      editor.setCursorBufferPosition([0, 5])
      tabsToSpaces.tabify(editor)
      tabsToSpaces.untabify(editor)

      pos = editor.getCursorBufferPosition()
      expect(pos.row).toBe(0)
      expect(pos.column).toBe(5)
    })
  })
})
