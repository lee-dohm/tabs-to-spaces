# CHANGELOG

## **v1.0.3** &mdash; *Released: 2016-12-29*

* [#49](https://github.com/lee-dohm/tabs-to-spaces/issues/49) &mdash; Convert to line-by-line processing for functions that work with leading whitespace because it is somewhat faster
* Convert package code to JavaScript

## **v1.0.2** &mdash; *Released: 2016-02-15*

* [#41](https://github.com/lee-dohm/tabs-to-spaces/issues41) &mdash; Revert performance improvement from v1.0.0 because it was causing cursors to get pushed to the end of the file when the contents were changed

## **v1.0.1** &mdash; *Released: 2015-11-19*

* [#38](https://github.com/lee-dohm/tabs-to-spaces/issues/38) &mdash; Fix crash when upgrading the package from inside Atom

## **v1.0.0** &mdash; *Released: 2015-11-18*

* *Significant* performance improvement on large files &mdash; 2.11s &rarr; 0.448s tabifying the test file `sample/jquery-git2.js.txt`
* Cleaned up the specs to make them less brittle
* Updated the `onSave` configuration description to use Markdown for better emphasis

## **v0.11.1** &mdash; *Released: 2015-08-17*

* Added a warning to the Settings View description for the `onSave` setting that this setting can significantly impact save performance for large files

## **v0.11.0** &mdash; *Released: 2015-05-25*

* Stopped using undocumented interface
* [#28](https://github.com/lee-dohm/tabs-to-spaces/issues/28) &mdash; Change the extension of the sample JavaScript file to prevent strange error message

## **v0.10.0** &mdash; *Released: 2015-05-01*

* Clean up for Deprecation Day

## **v0.9.2** &mdash; *Released: 2015-03-30*

* Added keywords to the `package.json`

## **v0.9.1** &mdash; *Released: 2015-03-29*

* [#27](https://github.com/lee-dohm/tabs-to-spaces/pull/27) by [@Hurtak](https://github.com/Hurtak) &mdash; Grouped context menu items into a submenu

## **v0.9.0** &mdash; *Released: 2015-03-18*
ˆ
* [#21](https://github.com/lee-dohm/tabs-to-spaces/issues/21) &mdash; Added "Untabify All" command to convert *all* tabs in a document to spaces

## **v0.8.1** &mdash; *Released: 2015-02-02*

* Updated to only support post-API-freeze versions of Atom
* Fixed all the latest deprecations

## **v0.8.0** &mdash; *Released: 2014-12-07*

* Cleaned up all deprecations

## **v0.7.1** &mdash; *Released: 2014-10-22*

* [#11](https://github.com/lee-dohm/tabs-to-spaces/issues/11) - Disable onSave tabification or untabification of `config.cson`

## **v0.7.0** &mdash; *Released: 2014-10-17*

* Add support for language-specific configuration for `onSave` [#9](https://github.com/lee-dohm/tabs-to-spaces/issues/9)
* Skipped v0.6.0 due to publishing issue

## **v0.5.1** &mdash; *Released: 2014-10-05*

* Use new configuration schema to turn the `onSave` setting into a dropdown

## **v0.5.0** &mdash; *Released: 2014-10-03*

* :bug: Fix [#7](https://github.com/lee-dohm/tabs-to-spaces/issues/7) - Handles any mixture of tabs or spaces at the beginning of lines

## **v0.4.2** &mdash; *Released: 2014-07-29*

* :bug: Fix [#5](https://github.com/lee-dohm/tabs-to-spaces/issues/5) - Remove dependency on `fs-plus` because it was generating some sort of strange build error

## **v0.4.1** &mdash; *Released: 2014-07-21*

* [#4](https://github.com/lee-dohm/tabs-to-spaces/pull/4) by [@Zren](https://github.com/Zren) - Add default value for `onSave` so that it always shows up in the Settings View

## **v0.4.0** &mdash; *Released: 2014-06-28*

* Add support for editor-specific tab length settings [#1](https://github.com/lee-dohm/tabs-to-spaces/issues/1)

## **v0.3.4** &mdash; *Released: 2014-05-25*

* :bug: Fix [#2](https://github.com/lee-dohm/tabs-to-spaces/issues/2) - Dereference of `null` in `handleEvents()`

## **v0.3.3** &mdash; *Released: 2014-05-24*

* :bug: Fixed the on save event handlers
