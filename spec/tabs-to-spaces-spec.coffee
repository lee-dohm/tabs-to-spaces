#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

TextBuffer = require 'text-buffer'

TabsToSpaces = require '../lib/tabs-to-spaces'

describe 'TabsToSpaces', ->
  describe 'replaceSpacesWithTabs', ->
    it 'throws on null', ->
      expect( ->
        TabsToSpaces.replaceSpacesWithTabs(null)
      ).toThrow()

    it 'throws on undefined', ->
      expect( ->
        TabsToSpaces.replaceSpacesWithTabs(undefined)
      ).toThrow()

    it 'does not change the empty string', ->
      buffer = new TextBuffer('')

      TabsToSpaces.replaceSpacesWithTabs(buffer)

      expect(buffer.getText()).toEqual('')

    it 'does not change spaces at the end of a string', ->
      buffer = new TextBuffer('foobarbaz    ')

      TabsToSpaces.replaceSpacesWithTabs(buffer)

      expect(buffer.getText()).toEqual('foobarbaz    ')

    it 'does not change spaces in the middle of the string', ->
      buffer = new TextBuffer('foo  bar  baz')

      TabsToSpaces.replaceSpacesWithTabs(buffer)

      expect(buffer.getText()).toEqual('foo  bar  baz')

    it 'changes one tab worth of spaces to a tab', ->
      TabsToSpaces.setSpaces('  ')
      buffer = new TextBuffer('  foo')

      TabsToSpaces.replaceSpacesWithTabs(buffer)

      expect(buffer.getText()).toEqual("\tfoo")

    it 'changes almost two tabs worth of spaces to one tab and some spaces', ->
      TabsToSpaces.setSpaces('    ')
      buffer = new TextBuffer('       foo')

      TabsToSpaces.replaceSpacesWithTabs(buffer)

      expect(buffer.getText()).toEqual("\t   foo")

    it 'changes multiple lines of leading spaces to tabs', ->
      TabsToSpaces.setSpaces('    ')
      buffer = new TextBuffer('    foo\n       baz')

      TabsToSpaces.replaceSpacesWithTabs(buffer)

      expect(buffer.getText()).toEqual("\tfoo\n\t   baz")

    it 'leaves successive newlines alone', ->
      TabsToSpaces.setSpaces('  ')
      buffer = new TextBuffer('  foo\n\n  bar\n\n  baz\n\n')

      TabsToSpaces.replaceSpacesWithTabs(buffer)

      expect(buffer.getText()).toEqual("\tfoo\n\n\tbar\n\n\tbaz\n\n")

  describe 'replaceTabsWithSpaces', ->
    it 'throws on null', ->
      expect( ->
        TabsToSpaces.replaceTabsWithSpaces(null)
      ).toThrow()

    it 'throws on undefined', ->
      expect( ->
        TabsToSpaces.replaceTabsWithSpaces(undefined)
      ).toThrow()

    it 'does not change the empty string', ->
      buffer = new TextBuffer('')

      TabsToSpaces.replaceTabsWithSpaces(buffer)

      expect(buffer.getText()).toEqual('')

    it 'does not change tabs at the end of a string', ->
      buffer = new TextBuffer("foobarbaz\t")

      TabsToSpaces.replaceTabsWithSpaces(buffer)

      expect(buffer.getText()).toEqual("foobarbaz\t")

    it 'does not change tabs in the middle of a string', ->
      buffer = new TextBuffer("foo\tbar\tbaz")

      TabsToSpaces.replaceTabsWithSpaces(buffer)

      expect(buffer.getText()).toEqual("foo\tbar\tbaz")

    it 'changes one tab to the correct number of spaces', ->
      TabsToSpaces.setSpaces('  ')
      buffer = new TextBuffer("\tfoo")

      TabsToSpaces.replaceTabsWithSpaces(buffer)

      expect(buffer.getText()).toEqual('  foo')

    it 'changes two tabs to the correct number of spaces', ->
      TabsToSpaces.setSpaces('  ')
      buffer = new TextBuffer("\t\tfoo")

      TabsToSpaces.replaceTabsWithSpaces(buffer)

      expect(buffer.getText()).toEqual('    foo')

    it 'changes multiple lines of leading tabs to spaces', ->
      TabsToSpaces.setSpaces('  ')
      buffer = new TextBuffer("\t\tfoo\n\t\tfoo")

      TabsToSpaces.replaceTabsWithSpaces(buffer)

      expect(buffer.getText()).toEqual('    foo\n    foo')
