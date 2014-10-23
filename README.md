[![Build Status](https://travis-ci.org/lee-dohm/tabs-to-spaces.svg?branch=master)](https://travis-ci.org/lee-dohm/tabs-to-spaces)

# Tabs to Spaces

An Atom package for converting leading whitespace to either all spaces or all tabs.

## Installation

The package can be installed by using the Settings screen and searching for `tabs-to-spaces`.

It can also be installed from the command line with the command:

```bash
apm install tabs-to-spaces
```

## Use

It can convert any form of leading whitespace to either all spaces (Untabify) or the maximum number of tabs and minimum number of spaces with tabs up front (Tabify) to fill the same space. It will also, with configuration, convert to your preferred method on save.

### Commands

* `tabs-to-spaces:tabify` &mdash; Converts leading whitespace to tabs
* `tabs-to-spaces:untabify` &mdash; Converts leading whitespace to spaces

### Configuration

Tabs to Spaces uses the following configuration values:

* `editor.tabLength` &mdash; sets the number of space characters a tab character is equivalent to
* `tabs-to-spaces.onSave` &mdash; if set to either `tabify` or `untabify` it performs that operation on save

The package also supports language-specific configuration for the `onSave` setting. For example, the following configuration will tabify all file types on save except for JavaScript files:

```coffee
'global':
  'tabs-to-spaces':
    'onSave': 'tabify'
'.source.js':
  'tabs-to-spaces':
    'onSave': 'none'
```

No matter what `tabs-to-spaces.onSave` settings you configure, your `config.cson` will not be automatically tabified or untabified.

### Keybindings

Keybindings have not been set for this package. They can easily be added by referencing the commands listed above.

## Copyright

Copyright &copy; 2014 by [Lee Dohm](http://www.lee-dohm.com). See [LICENSE](https://github.com/lee-dohm/tabs-to-spaces/blob/master/LICENSE.md) for details.
