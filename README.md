[![Build Status](https://travis-ci.org/lee-dohm/tabs-to-spaces.svg?branch=master)](https://travis-ci.org/lee-dohm/tabs-to-spaces)

# Tabs to Spaces

An Atom package for converting between leading tabs and leading spaces.

## Installation

The package can be installed by using the Settings screen and searching for `tabs-to-spaces`.

It can also be installed from the command line with the command:

```bash
apm install tabs-to-spaces
```

## Use

It can convert between leading tabs and spaces in the current editor window. It can be executed from:

* Command Palette
    * `Tabs To Spaces: Tabify`
    * `Tabs To Spaces: Untabify`
* Packages Menu
    * `Packages > Tabs to Spaces > Tabify`
    * `Packages > Tabs to Spaces > Untabify`
* Context Menu
    * `Tabify`
    * `Untabify`

## Configuration

Tabs to Spaces uses the following configuration values:

* `editor.getTabLength()` &mdash; sets the number of space characters a tab character is equivalent to
* `tabs-to-spaces.onSave` &mdash; if set to either "tabify" or "untabify" it performs that operation on save
    * Previously this was named `on-save`, but this conflicts with the humanizing algorithm used for configuration options, so it was changed to follow the standard.

### Keybinding

I have not set keybindings for this package. They can easily be added by referencing the following commands:

* `tabs-to-spaces:tabify`
* `tabs-to-spaces:untabify`

For example, to map the Untabify command to <kbd>Cmd+Alt+T</kbd>:

```cson
'.editor:not(.mini)':
  'alt-cmd-t': 'tabs-to-spaces:untabify'
```

## Copyright

Copyright &copy; 2014 by [Lee Dohm](http://www.lee-dohm.com). See [LICENSE](https://github.com/lee-dohm/tabs-to-spaces/blob/master/LICENSE.md) for details.
