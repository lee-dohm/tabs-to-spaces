/** @babel */

/**
 * Indicates whether `element` has a command named `name`.
 *
 * * `element` {HTMLElement} on which to search commands
 * * `name` {String} name of command to search for
 *
 * Returns {Boolean} indicating whether the command is present on `element`.
 */
export function hasCommand (element, name) {
  const commands = atom.commands.findCommands({ target: element })

  for (let command of commands) {
    if (command.name === name) {
      return true
    }
  }

  return false
}
