/** @babel */

import fs from 'fs'
import path from 'path'

export default async function () {
  const tabsToSpaces = require('../lib/tabs-to-spaces')
  await atom.workspace.open(path.join(__dirname, '../sample/jquery-git2.js.txt'))
  let editor = atom.workspace.getActiveTextEditor()

  const t0 = window.performance.now()

  tabsToSpaces.replaceWhitespaceWithTabs(editor)

  const t1 = window.performance.now()

  return [
    { name: 'tabify', duration: t1 - t0 }
  ]
}
