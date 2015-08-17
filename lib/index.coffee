TabsToSpaces = null
tabsToSpaces = null

module.exports =
  config:
    onSave:
      type: 'string'
      default: 'none'
      enum: ['none', 'tabify', 'untabify']
      description: '''
        Setting this to anything other than "none" can significantly impact the time it takes to
        save large files.
        '''

  # Public: Activates the package.
  activate: ->
    @commands = atom.commands.add 'atom-workspace',
      'tabs-to-spaces:tabify': =>
        @loadModule()
        tabsToSpaces.tabify()

      'tabs-to-spaces:untabify': =>
        @loadModule()
        tabsToSpaces.untabify()

      'tabs-to-spaces:untabify-all': =>
        @loadModule()
        tabsToSpaces.untabifyAll()

    @editorObserver = atom.workspace.observeTextEditors (editor) =>
      @handleEvents(editor)

  deactivate: ->
    @commands.dispose()
    @editorObserver.dispose()

  # Private: Creates event handlers.
  #
  # * `editor` {TextEditor} to attach the event handlers to
  handleEvents: (editor) ->
    editor.getBuffer().onWillSave =>
      return if editor.getPath() is atom.config.getUserConfigPath()

      switch atom.config.get('tabs-to-spaces.onSave', scope: editor.getRootScopeDescriptor())
        when 'untabify'
          @loadModule()
          tabsToSpaces.untabify()
        when 'tabify'
          @loadModule()
          tabsToSpaces.tabify()

  # Private: Loads the module on-demand.
  loadModule: ->
    TabsToSpaces ?= require './tabs-to-spaces'
    tabsToSpaces ?= new TabsToSpaces()
