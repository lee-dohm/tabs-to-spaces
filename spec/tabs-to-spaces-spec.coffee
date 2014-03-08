#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

TabsToSpaces = require '../lib/tabs-to-spaces'

class MockSelection
  constructor: (@text) ->

  clear: ->

  getText: ->
    @text

  insertText: (@text) ->

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
      sel = new MockSelection('')
      TabsToSpaces.replaceTabsWithSpaces(sel)

      expect(sel.getText()).toEqual('')

    it 'does not change tabs at the end of a string', ->
      sel = new MockSelection("foobarbaz\t")
      TabsToSpaces.replaceTabsWithSpaces(sel)

      expect(sel.getText()).toEqual("foobarbaz\t")

    it 'does not change tabs in the middle of a string', ->
      sel = new MockSelection("foo\tbar\tbaz")
      TabsToSpaces.replaceTabsWithSpaces(sel)

      expect(sel.getText()).toEqual("foo\tbar\tbaz")

    it 'changes one tab to the correct number of spaces', ->
      TabsToSpaces.setSpaces('  ')
      sel = new MockSelection("\tfoo")
      TabsToSpaces.replaceTabsWithSpaces(sel)

      expect(sel.getText()).toEqual('  foo')

    it 'changes two tabs to the correct number of spaces', ->
      TabsToSpaces.setSpaces('  ')
      sel = new MockSelection("\t\tfoo")
      TabsToSpaces.replaceTabsWithSpaces(sel)

      expect(sel.getText()).toEqual('    foo')
