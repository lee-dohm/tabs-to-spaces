#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

TextBuffer = require 'text-buffer'

TabsToSpaces = require '../lib/tabs-to-spaces'

describe 'TabsToSpaces', ->
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
