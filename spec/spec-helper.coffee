module.exports =
  # Public: Indicates whether an element has a command.
  #
  # * `element` An {HTMLElement} to search.
  # * `name` A {String} containing the command name.
  #
  # Returns a {Boolean} indicating if it has the given command.
  hasCommand: (element, name) ->
    commands = atom.commands.findCommands(target: element)
    found = true for command in commands when command.name is name

    found
