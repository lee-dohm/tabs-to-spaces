fs = require 'fs'
path = require 'path'
temp = require 'temp'

TabsToSpaces = require '../lib/tabs-to-spaces'

helper = require './spec-helper'

describe 'Tabs to Spaces', ->
  [directory, editor, filePath, workspaceElement] = []

  beforeEach ->
    directory = temp.mkdirSync()
    atom.project.setPaths(directory)
    workspaceElement = atom.views.getView(atom.workspace)
    filePath = path.join(directory, 'tabs-to-spaces.txt')
    fs.writeFileSync(filePath, '')
    atom.config.set('editor.tabLength', 4)

    waitsForPromise ->
      atom.workspace.open(filePath).then (e) ->
        editor = e

    waitsForPromise ->
      atom.packages.activatePackage('tabs-to-spaces')

    waitsForPromise ->
      atom.packages.activatePackage('language-javascript')

  describe 'activate', ->
    it 'creates the commands', ->
      expect(helper.hasCommand(workspaceElement, 'tabs-to-spaces:tabify')).toBeTruthy()
      expect(helper.hasCommand(workspaceElement, 'tabs-to-spaces:untabify')).toBeTruthy()
      expect(helper.hasCommand(workspaceElement, 'tabs-to-spaces:untabify-all')).toBeTruthy()

  describe 'deactivate', ->
    beforeEach ->
      atom.packages.deactivatePackage('tabs-to-spaces')

    it 'destroys the commands', ->
      expect(helper.hasCommand(workspaceElement, 'tabs-to-spaces:tabify')).toBeFalsy()
      expect(helper.hasCommand(workspaceElement, 'tabs-to-spaces:untabify')).toBeFalsy()
      expect(helper.hasCommand(workspaceElement, 'tabs-to-spaces:untabify-all')).toBeFalsy()

  describe 'tabify', ->
    beforeEach ->
      editor.setTabLength(3)

    it 'does not change an empty file', ->
      TabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe ''

    it 'does not change spaces at the end of a line', ->
      editor.setText('foobarbaz     ')
      TabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe 'foobarbaz     '

    it 'does not change spaces in the middle of a line', ->
      editor.setText('foo  bar  baz')
      TabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe 'foo  bar  baz'

    it 'converts one tab worth of spaces to a tab', ->
      editor.setTabLength(2)
      editor.setText('  foo')
      TabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe '\tfoo'

    it 'converts almost two tabs worth of spaces to one tab and some spaces', ->
      editor.setTabLength(4)
      editor.setText('       foo')
      TabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe '\t   foo'

    it 'changes multiple lines of leading spaces to tabs', ->
      editor.setTabLength(4)
      editor.setText('    foo\n       bar')
      TabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe '\tfoo\n\t   bar'

    it 'leaves successive newlines alone', ->
      editor.setTabLength(2)
      editor.setText('  foo\n\n  bar\n\n  baz\n\n')
      TabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe '\tfoo\n\n\tbar\n\n\tbaz\n\n'

    it 'changes mixed spaces and tabs to uniform whitespace', ->
      editor.setTabLength(2)
      editor.setText('\t \tfoo\n')
      TabsToSpaces.tabify(editor)
      expect(editor.getText()).toBe '\t\t foo\n'

  describe 'untabify', ->
    beforeEach ->
      editor.setTabLength(3)

    it 'does not change an empty file', ->
      TabsToSpaces.untabify(editor)
      expect(editor.getText()).toBe ''

    it 'does not change tabs at the end of a string', ->
      editor.setText('foobarbaz\t')
      TabsToSpaces.untabify(editor)
      expect(editor.getText()).toBe 'foobarbaz\t'

    it 'does not change tabs in the middle of a string', ->
      editor.setText('foo\tbar\tbaz')
      TabsToSpaces.untabify(editor)
      expect(editor.getText()).toBe 'foo\tbar\tbaz'

    it 'changes one tab to the correct number of spaces', ->
      editor.setTabLength(2)
      editor.setText('\tfoo')
      TabsToSpaces.untabify(editor)
      expect(editor.getText()).toBe '  foo'

    it 'changes two tabs to the correct number of spaces', ->
      editor.setTabLength(2)
      editor.setText('\t\tfoo')
      TabsToSpaces.untabify(editor)
      expect(editor.getText()).toBe '    foo'

    it 'changes multiple lines of leading tabs to spaces', ->
      editor.setTabLength(2)
      editor.setText('\t\tfoo\n\t\tbar\n\n')
      TabsToSpaces.untabify(editor)
      expect(editor.getText()).toBe '    foo\n    bar\n\n'

    it 'changes mixed spaces and tabs to uniform whitespace', ->
      editor.setTabLength(2)
      editor.setText(' \t foo\n')
      TabsToSpaces.untabify(editor)
      expect(editor.getText()).toBe '    foo\n'

  describe 'untabify all', ->
    beforeEach ->
      editor.setTabLength(3)

    it 'does not change an empty file', ->
      TabsToSpaces.untabifyAll(editor)
      expect(editor.getText()).toBe ''

    it 'does change tabs at the end of a string', ->
      editor.setText('foobarbaz\t')
      TabsToSpaces.untabifyAll(editor)
      expect(editor.getText()).toBe 'foobarbaz   '

    it 'does change tabs in the middle of a string', ->
      editor.setText('foo\tbar\tbaz')
      TabsToSpaces.untabifyAll(editor)
      expect(editor.getText()).toBe 'foo   bar   baz'

    it 'changes one tab to the correct number of spaces', ->
      editor.setTabLength(2)
      editor.setText('\tfoo')
      TabsToSpaces.untabifyAll(editor)
      expect(editor.getText()).toBe '  foo'

    it 'changes two tabs to the correct number of spaces', ->
      editor.setTabLength(2)
      editor.setText('\t\tfoo')
      TabsToSpaces.untabifyAll(editor)
      expect(editor.getText()).toBe '    foo'

    it 'changes multiple lines of leading tabs to spaces', ->
      editor.setTabLength(2)
      editor.setText('\t\tfoo\n\t\tbar\n\n')
      TabsToSpaces.untabifyAll(editor)
      expect(editor.getText()).toBe '    foo\n    bar\n\n'

    it 'changes mixed spaces and tabs to uniform whitespace', ->
      editor.setTabLength(2)
      editor.setText(' \t foo\n')
      TabsToSpaces.untabifyAll(editor)
      expect(editor.getText()).toBe '    foo\n'

  describe 'on save', ->
    beforeEach ->
      atom.config.set('tabs-to-spaces.onSave', 'none')

    it 'will untabify before an editor saves a buffer', ->
      atom.config.set('tabs-to-spaces.onSave', 'untabify')
      editor.setText('\t\tfoo\n\t\tbar\n\n')
      editor.save()
      expect(editor.getText()).toBe '        foo\n        bar\n\n'

    it 'will tabify before an editor saves a buffer', ->
      atom.config.set('tabs-to-spaces.onSave', 'tabify')
      editor.setText('        foo\n        bar\n\n')
      editor.save()
      expect(editor.getText()).toBe '\t\tfoo\n\t\tbar\n\n'

    describe 'with scope-specific configuration', ->
      beforeEach ->
        atom.config.set('editor.tabLength', 2, scope: '.text.plain')
        atom.config.set('tabs-to-spaces.onSave', 'tabify', scope: '.text.plain')
        filePath = path.join(directory, 'sample.txt')
        fs.writeFileSync(filePath, 'Some text.\n')

        waitsForPromise ->
          atom.workspace.open(filePath).then (e) -> editor = e

        runs ->
          buffer = editor.getBuffer()

      it 'respects the overridden configuration', ->
        editor.setText('    foo\n    bar\n\n')
        editor.save()
        expect(editor.getText()).toBe '\t\tfoo\n\t\tbar\n\n'

      it 'does not modify the contents of the user configuration file', ->
        spyOn(atom.config, 'getUserConfigPath').andReturn(filePath)
        spyOn(editor, 'getPath').andReturn(filePath)

        editor.setText('    foo\n    bar\n\n')
        editor.save()
        expect(editor.getText()).toBe '    foo\n    bar\n\n'

  describe 'invariants', ->
    beforeEach ->
      editor.setText(fs.readFileSync(__filename, 'utf8'))

    it 'does not move the position of the cursor', ->
      editor.setCursorBufferPosition([0, 5])
      TabsToSpaces.tabify(editor)
      TabsToSpaces.untabify(editor)

      pos = editor.getCursorBufferPosition()
      expect(pos.row).toBe 0
      expect(pos.column).toBe 5
