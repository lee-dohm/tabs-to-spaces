#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

TextBuffer = require 'text-buffer'

TabsToSpaces = require '../lib/tabs-to-spaces'
tabsToSpaces = new TabsToSpaces()

describe 'TabsToSpaces', ->
  describe 'replaceSpacesWithTabs', ->
    it 'throws on null', ->
      expect( ->
        tabsToSpaces.replaceSpacesWithTabs(null)
      ).toThrow()

    it 'throws on undefined', ->
      expect( ->
        tabsToSpaces.replaceSpacesWithTabs(undefined)
      ).toThrow()

    it 'does not change the empty string', ->
      buffer = new TextBuffer('')

      tabsToSpaces.replaceSpacesWithTabs(buffer)

      expect(buffer.getText()).toEqual('')

    it 'does not change spaces at the end of a string', ->
      buffer = new TextBuffer('foobarbaz    ')

      tabsToSpaces.replaceSpacesWithTabs(buffer)

      expect(buffer.getText()).toEqual('foobarbaz    ')

    it 'does not change spaces in the middle of the string', ->
      buffer = new TextBuffer('foo  bar  baz')

      tabsToSpaces.replaceSpacesWithTabs(buffer)

      expect(buffer.getText()).toEqual('foo  bar  baz')

    it 'changes one tab worth of spaces to a tab', ->
      tabsToSpaces.setSpaces('  ')
      buffer = new TextBuffer('  foo')

      tabsToSpaces.replaceSpacesWithTabs(buffer)

      expect(buffer.getText()).toEqual("\tfoo")

    it 'changes almost two tabs worth of spaces to one tab and some spaces', ->
      tabsToSpaces.setSpaces('    ')
      buffer = new TextBuffer('       foo')

      tabsToSpaces.replaceSpacesWithTabs(buffer)

      expect(buffer.getText()).toEqual("\t   foo")

    it 'changes multiple lines of leading spaces to tabs', ->
      tabsToSpaces.setSpaces('    ')
      buffer = new TextBuffer('    foo\n       baz')

      tabsToSpaces.replaceSpacesWithTabs(buffer)

      expect(buffer.getText()).toEqual("\tfoo\n\t   baz")

    it 'leaves successive newlines alone', ->
      tabsToSpaces.setSpaces('  ')
      buffer = new TextBuffer('  foo\n\n  bar\n\n  baz\n\n')

      tabsToSpaces.replaceSpacesWithTabs(buffer)

      expect(buffer.getText()).toEqual("\tfoo\n\n\tbar\n\n\tbaz\n\n")

  describe 'replaceTabsWithSpaces', ->
    it 'throws on null', ->
      expect( ->
        tabsToSpaces.replaceTabsWithSpaces(null)
      ).toThrow()

    it 'throws on undefined', ->
      expect( ->
        tabsToSpaces.replaceTabsWithSpaces(undefined)
      ).toThrow()

    it 'does not change the empty string', ->
      buffer = new TextBuffer('')

      tabsToSpaces.replaceTabsWithSpaces(buffer)

      expect(buffer.getText()).toEqual('')

    it 'does not change tabs at the end of a string', ->
      buffer = new TextBuffer("foobarbaz\t")

      tabsToSpaces.replaceTabsWithSpaces(buffer)

      expect(buffer.getText()).toEqual("foobarbaz\t")

    it 'does not change tabs in the middle of a string', ->
      buffer = new TextBuffer("foo\tbar\tbaz")

      tabsToSpaces.replaceTabsWithSpaces(buffer)

      expect(buffer.getText()).toEqual("foo\tbar\tbaz")

    it 'changes one tab to the correct number of spaces', ->
      tabsToSpaces.setSpaces('  ')
      buffer = new TextBuffer("\tfoo")

      tabsToSpaces.replaceTabsWithSpaces(buffer)

      expect(buffer.getText()).toEqual('  foo')

    it 'changes two tabs to the correct number of spaces', ->
      tabsToSpaces.setSpaces('  ')
      buffer = new TextBuffer("\t\tfoo")

      tabsToSpaces.replaceTabsWithSpaces(buffer)

      expect(buffer.getText()).toEqual('    foo')

    it 'changes multiple lines of leading tabs to spaces', ->
      tabsToSpaces.setSpaces('  ')
      buffer = new TextBuffer("\t\tfoo\n\t\tfoo")

      tabsToSpaces.replaceTabsWithSpaces(buffer)

      expect(buffer.getText()).toEqual('    foo\n    foo')
