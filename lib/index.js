/** @babel */

let commands = null
let editorObserver = null
let tabsToSpaces = null

export function activate () {
  commands = atom.commands.add('atom-workspace', {
    'tabs-to-spaces:tabify': () => {
      loadModule()
      tabsToSpaces.tabify()
    },
    'tabs-to-spaces:untabify': () => {
      loadModule()
      tabsToSpaces.untabify()
    },
    'tabs-to-spaces:untabify-all': () => {
      loadModule()
      tabsToSpaces.untabifyAll()
    }
  })

  editorObserver = atom.workspace.observeTextEditors((editor) => {
    handleEvents(editor)
  })
}

export function deactivate () {
  if (editorObserver) {
    editorObserver.dispose()
  }

  if (commands) {
    commands.dispose()
  }
}

function handleEvents (editor) {
  editor.getBuffer().onWillSave(() => {
    if (editor.getPath() === atom.config.getUserConfigPath()) {
      return
    }

    let onSave = atom.config.get('tabs-to-spaces.onSave', { scope: editor.getRootScopeDescriptor() })
    if (onSave === 'tabify') {
      loadModule()
      tabsToSpaces.tabify()
    } else if (onSave === 'untabify') {
      loadModule()
      tabsToSpaces.untabify()
    }
  })
}

function loadModule () {
  if (!tabsToSpaces) {
    tabsToSpaces = require('./tabs-to-spaces')
  }
}
