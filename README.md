# Tabs to Spaces

[![Build Status](https://img.shields.io/travis/lee-dohm/tabs-to-spaces.svg)](https://travis-ci.org/lee-dohm/tabs-to-spaces)
[![Package Version](https://img.shields.io/apm/v/tabs-to-spaces.svg)](https://atom.io/packages/tabs-to-spaces)
[![Package Downloads](https://img.shields.io/apm/dm/tabs-to-spaces.svg)](https://atom.io/packages/tabs-to-spaces)
[![Dependency Status](https://img.shields.io/david/lee-dohm/tabs-to-spaces.svg)](https://david-dm.org/lee-dohm/tabs-to-spaces)

An Atom package for converting leading whitespace to either all spaces or all tabs.

## Usage

It can convert any form of leading whitespace to either all spaces (Untabify) or the maximum number of tabs and minimum number of spaces with tabs up front (Tabify) to fill the same space. It can also convert all tabs in a document to spaces (Untabify All).

It will also, with configuration, convert to your preferred method of leading whitespace on save.

### Commands

* `tabs-to-spaces:tabify` &mdash; Converts leading whitespace to tabs
* `tabs-to-spaces:untabify` &mdash; Converts leading whitespace to spaces
* `tabs-to-spaces:untabify-all` &mdash; Converts all whitespace on a line to spaces

### Configuration

Tabs to Spaces uses the following configuration values:

* `editor.tabLength` &mdash; sets the number of space characters a tab character is equivalent to
* `tabs-to-spaces.onSave` &mdash; if set to either `tabify` or `untabify` it performs that operation on save. :rotating_light: **Warning:** :rotating_light: Setting this to anything other than `none` can **significantly** impact performance when saving large files.

The package also supports language-specific configuration for the `onSave` setting. For example, the following configuration will tabify all file types on save except for JavaScript files:

```coffee
'*':
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

Copyright &copy; 2014-2016 by [Lee Dohm](http://www.lee-dohm.com) and [Lifted Studios](http://www.liftedstudios.com). See [LICENSE](https://github.com/lee-dohm/tabs-to-spaces/blob/master/LICENSE.md) for details.
