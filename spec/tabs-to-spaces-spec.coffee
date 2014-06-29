fs              = require 'fs-plus'
path            = require 'path'
temp            = require 'temp'
{WorkspaceView} = require 'atom'

describe 'Tabs to Spaces', ->
  [editor, buffer] = []

  beforeEach ->
    directory = temp.mkdirSync()
    atom.project.setPath(directory)
    atom.workspaceView = new WorkspaceView()
    atom.workspace = atom.workspaceView.model
    filePath = path.join(directory, 'tabs-to-spaces.txt')
    fs.writeFileSync(filePath, '')
    fs.writeFileSync(path.join(directory, 'sample.txt'), 'Some text.\n')
    atom.config.set('editor.tabLength', 3)

    waitsForPromise ->
      atom.workspace.open(filePath).then (e) ->
        editor = e
        buffer = editor.getBuffer()
        editor.setTabLength(2)

    waitsForPromise ->
      atom.packages.activatePackage('tabs-to-spaces')

  describe 'tabify', ->
    it 'does not change an empty file', ->
      atom.workspaceView.trigger 'tabs-to-spaces:tabify'
      expect(editor.getText()).toBe ''

    it 'does not change spaces at the end of a line', ->
      editor.insertText('foobarbaz     ')
      atom.workspaceView.trigger 'tabs-to-spaces:tabify'
      expect(editor.getText()).toBe 'foobarbaz     '

    it 'does not change spaces in the middle of a line', ->
      editor.insertText('foo  bar  baz')
      atom.workspaceView.trigger 'tabs-to-spaces:tabify'
      expect(editor.getText()).toBe 'foo  bar  baz'

    it 'converts one tab worth of spaces to a tab', ->
      editor.setTabLength(2)
      editor.insertText('  foo')
      atom.workspaceView.trigger 'tabs-to-spaces:tabify'
      expect(editor.getText()).toBe '\tfoo'

    it 'converts almost two tabs worth of spaces to one tab and some spaces', ->
      editor.setTabLength(4)
      editor.insertText('       foo')
      atom.workspaceView.trigger 'tabs-to-spaces:tabify'
      expect(editor.getText()).toBe '\t   foo'

    it 'changes multiple lines of leading spaces to tabs', ->
      editor.setTabLength(4)
      editor.insertText('    foo\n       bar')
      atom.workspaceView.trigger 'tabs-to-spaces:tabify'
      expect(editor.getText()).toBe '\tfoo\n\t   bar'

    it 'leaves successive newlines alone', ->
      editor.setTabLength(2)
      editor.insertText('  foo\n\n  bar\n\n  baz\n\n')
      atom.workspaceView.trigger 'tabs-to-spaces:tabify'
      expect(editor.getText()).toBe '\tfoo\n\n\tbar\n\n\tbaz\n\n'

  describe 'untabify', ->
    it 'does not change an empty file', ->
      atom.workspaceView.trigger 'tabs-to-spaces:untabify'
      expect(editor.getText()).toBe ''

    it 'does not change tabs at the end of a string', ->
      editor.insertText('foobarbaz\t')
      atom.workspaceView.trigger 'tabs-to-spaces:untabify'
      expect(editor.getText()).toBe 'foobarbaz\t'

    it 'does not change tabs in the middle of a string', ->
      editor.insertText('foo\tbar\tbaz')
      atom.workspaceView.trigger 'tabs-to-spaces:untabify'
      expect(editor.getText()).toBe 'foo\tbar\tbaz'

    it 'changes one tab to the correct number of spaces', ->
      editor.setTabLength(2)
      editor.insertText('\tfoo')
      atom.workspaceView.trigger 'tabs-to-spaces:untabify'
      expect(editor.getText()).toBe '  foo'

    it 'changes two tabs to the correct number of spaces', ->
      editor.setTabLength(2)
      editor.insertText('\t\tfoo')
      atom.workspaceView.trigger 'tabs-to-spaces:untabify'
      expect(editor.getText()).toBe '    foo'

    it 'changes multiple lines of leading tabs to spaces', ->
      editor.setTabLength(2)
      editor.insertText('\t\tfoo\n\t\tbar\n\n')
      atom.workspaceView.trigger 'tabs-to-spaces:untabify'
      expect(editor.getText()).toBe '    foo\n    bar\n\n'

  describe 'on save', ->
    it 'will untabify before an editor saves a buffer', ->
      atom.config.set('tabs-to-spaces.onSave', 'untabify')
      editor.insertText('\t\tfoo\n\t\tbar\n\n')
      editor.save()
      expect(editor.getText()).toBe '    foo\n    bar\n\n'

    it 'will tabify before an editor saves a buffer', ->
      atom.config.set('tabs-to-spaces.onSave', 'tabify')
      editor.insertText('    foo\n    bar\n\n')
      editor.save()
      expect(editor.getText()).toBe '\t\tfoo\n\t\tbar\n\n'
