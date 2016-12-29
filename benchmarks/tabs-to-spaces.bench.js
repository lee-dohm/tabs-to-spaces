/** @babel */

import fs from 'fs'
import path from 'path'

export default async function () {
  const tabsToSpaces = require('../lib/tabs-to-spaces')
  await atom.workspace.open(path.join(__dirname, '../sample/jquery-git2.js.txt'))
  let editor = atom.workspace.getActiveTextEditor()

  const t0 = window.performance.now()

  tabsToSpaces.oldReplaceWhitespaceWithTabs(editor)

  const t1 = window.performance.now()

  editor.setText(fs.readFileSync(path.join(__dirname, '../sample/jquery-git2.js.txt'), 'utf8'))

  const t2 = window.performance.now()

  tabsToSpaces.replaceWhitespaceWithTabs(editor)

  const t3 = window.performance.now()

  return [
    { name: 'tabify-old', duration: t1 - t0 },
    { name: 'tabify-new', duration: t3 - t2 }
  ]
}
