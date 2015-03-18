fs              = require 'fs'
path            = require 'path'
temp            = require 'temp'

helper = require './spec-helper'

describe 'Tabs to Spaces', ->
  [buffer, directory, editor, filePath, workspaceElement] = []

  beforeEach ->
    directory = temp.mkdirSync()
    atom.project.setPaths(directory)
    workspaceElement = atom.views.getView(atom.workspace)
    filePath = path.join(directory, 'tabs-to-spaces.txt')
    fs.writeFileSync(filePath, '')
    atom.config.set('editor.tabLength', 4)

    waitsForPromise ->
      atom.workspace.open(filePath).then (e) -> editor = e

    runs ->
      buffer = editor.getBuffer()

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
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:tabify')
      expect(editor.getText()).toBe ''

    it 'does not change spaces at the end of a line', ->
      buffer.setText('foobarbaz     ')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:tabify')
      expect(editor.getText()).toBe 'foobarbaz     '

    it 'does not change spaces in the middle of a line', ->
      buffer.setText('foo  bar  baz')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:tabify')
      expect(editor.getText()).toBe 'foo  bar  baz'

    it 'converts one tab worth of spaces to a tab', ->
      editor.setTabLength(2)
      buffer.setText('  foo')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:tabify')
      expect(editor.getText()).toBe '\tfoo'

    it 'converts almost two tabs worth of spaces to one tab and some spaces', ->
      editor.setTabLength(4)
      buffer.setText('       foo')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:tabify')
      expect(editor.getText()).toBe '\t   foo'

    it 'changes multiple lines of leading spaces to tabs', ->
      editor.setTabLength(4)
      buffer.setText('    foo\n       bar')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:tabify')
      expect(editor.getText()).toBe '\tfoo\n\t   bar'

    it 'leaves successive newlines alone', ->
      editor.setTabLength(2)
      buffer.setText('  foo\n\n  bar\n\n  baz\n\n')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:tabify')
      expect(editor.getText()).toBe '\tfoo\n\n\tbar\n\n\tbaz\n\n'

    it 'changes mixed spaces and tabs to uniform whitespace', ->
      editor.setTabLength(2)
      buffer.setText('\t \tfoo\n')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:tabify')
      expect(editor.getText()).toBe '\t\t foo\n'

  describe 'untabify', ->
    beforeEach ->
      editor.setTabLength(3)

    it 'does not change an empty file', ->
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:untabify')
      expect(editor.getText()).toBe ''

    it 'does not change tabs at the end of a string', ->
      buffer.setText('foobarbaz\t')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:untabify')
      expect(editor.getText()).toBe 'foobarbaz\t'

    it 'does not change tabs in the middle of a string', ->
      buffer.setText('foo\tbar\tbaz')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:untabify')
      expect(editor.getText()).toBe 'foo\tbar\tbaz'

    it 'changes one tab to the correct number of spaces', ->
      editor.setTabLength(2)
      buffer.setText('\tfoo')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:untabify')
      expect(editor.getText()).toBe '  foo'

    it 'changes two tabs to the correct number of spaces', ->
      editor.setTabLength(2)
      buffer.setText('\t\tfoo')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:untabify')
      expect(editor.getText()).toBe '    foo'

    it 'changes multiple lines of leading tabs to spaces', ->
      editor.setTabLength(2)
      buffer.setText('\t\tfoo\n\t\tbar\n\n')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:untabify')
      expect(editor.getText()).toBe '    foo\n    bar\n\n'

    it 'changes mixed spaces and tabs to uniform whitespace', ->
      editor.setTabLength(2)
      buffer.setText(' \t foo\n')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:untabify')
      expect(editor.getText()).toBe '    foo\n'

  describe 'untabify all', ->
    beforeEach ->
      editor.setTabLength(3)

    it 'does not change an empty file', ->
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:untabify-all')
      expect(editor.getText()).toBe ''

    it 'does change tabs at the end of a string', ->
      buffer.setText('foobarbaz\t')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:untabify-all')
      expect(editor.getText()).toBe 'foobarbaz   '

    it 'does change tabs in the middle of a string', ->
      buffer.setText('foo\tbar\tbaz')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:untabify-all')
      expect(editor.getText()).toBe 'foo   bar   baz'

    it 'changes one tab to the correct number of spaces', ->
      editor.setTabLength(2)
      buffer.setText('\tfoo')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:untabify-all')
      expect(editor.getText()).toBe '  foo'

    it 'changes two tabs to the correct number of spaces', ->
      editor.setTabLength(2)
      buffer.setText('\t\tfoo')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:untabify-all')
      expect(editor.getText()).toBe '    foo'

    it 'changes multiple lines of leading tabs to spaces', ->
      editor.setTabLength(2)
      buffer.setText('\t\tfoo\n\t\tbar\n\n')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:untabify-all')
      expect(editor.getText()).toBe '    foo\n    bar\n\n'

    it 'changes mixed spaces and tabs to uniform whitespace', ->
      editor.setTabLength(2)
      buffer.setText(' \t foo\n')
      atom.commands.dispatch(workspaceElement, 'tabs-to-spaces:untabify-all')
      expect(editor.getText()).toBe '    foo\n'

  describe 'on save', ->
    beforeEach ->
      atom.config.set('tabs-to-spaces.onSave', 'none')

    it 'will untabify before an editor saves a buffer', ->
      atom.config.set('tabs-to-spaces.onSave', 'untabify')
      buffer.setText('\t\tfoo\n\t\tbar\n\n')
      editor.save()
      expect(editor.getText()).toBe '        foo\n        bar\n\n'

    it 'will tabify before an editor saves a buffer', ->
      atom.config.set('tabs-to-spaces.onSave', 'tabify')
      buffer.setText('        foo\n        bar\n\n')
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
        buffer.setText('    foo\n    bar\n\n')
        editor.save()
        expect(editor.getText()).toBe '\t\tfoo\n\t\tbar\n\n'

      it 'does not modify the contents of the user configuration file', ->
        spyOn(atom.config, 'getUserConfigPath').andReturn(filePath)
        spyOn(editor, 'getPath').andReturn(filePath)

        buffer.setText('    foo\n    bar\n\n')
        editor.save()
        expect(editor.getText()).toBe '    foo\n    bar\n\n'
