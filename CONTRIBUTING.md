# CONTRIBUTING

:+1::tada: First off, thanks for taking the time to contribute! :tada::+1:

These are just guidelines, not rules, use your best judgement and feel free to propose changes to this document in a pull request.

## Submitting Issues

* Check the [debugging guide](https://atom.io/docs/latest/debugging) for tips on debugging. You might be able to find the cause of the problem and fix things yourself.
* Include the version of Atom you are using and the OS.
* Include screenshots and animated GIFs whenever possible; they are immensely helpful.
* Include the behavior you expected.
* Check the dev tools (<kbd>Cmd+Alt+I</kbd>) for errors to include. If the dev tools are open *before* the error is triggered, a full stack trace for the error will be logged. If you can reproduce the error, use this approach to get the full stack trace and include it in the issue.
* Perform a cursory search to see if a similar issue has already been submitted.
* Please setup a [profile picture](https://help.github.com/articles/how-do-i-set-up-my-profile-picture) to make yourself recognizable and so we can all get to know each other better.

## Pull Requests

* Include screenshots and animated GIFs in your pull request whenever possible
* Follow the [CoffeeScript](#coffeescript-styleguide), [JavaScript](https://github.com/styleguide/javascript), and [CSS](https://github.com/styleguide/css) styleguides
* Include thoughtfully-worded, well-structured [Jasmine](http://jasmine.github.io/) specs
* Document new code based on the [Documentation Styleguide](#documentation-styleguide)
* End files with a newline
* Place requires in the following order:
    * Built in Node Modules (such as `path`)
    * Built in Atom and Atom Shell Modules (such as `atom`, `shell`)
    * Local Modules (using relative paths)
* Place class properties in the following order:
    * Class methods and properties (methods starting with a `@`)
    * Instance methods and properties
* Avoid platform-dependent code:
    * Use `require('atom').fs.getHomeDirectory()` to get the home directory.
    * Use `path.join()` to concatenate filenames.
    * Use `os.tmpdir()` rather than `/tmp` when you need to reference the temporary directory.
* Use a plain `return` when returning explicitly at the end of a function.
    * Not `return null`, `return undefined`, `null`, or `undefined`

## Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally
* Consider starting the commit message with an applicable emoji:
    * :lipstick: `:lipstick:` when improving the format/structure of the code
    * :racehorse: `:racehorse:` when improving performance
    * :non-potable_water: `:non-potable_water:` when plugging memory leaks
    * :memo: `:memo:` when writing docs
    * :penguin: `:penguin:` when fixing something on Linux
    * :apple: `:apple:` when fixing something on Mac OS
    * :checkered_flag: `:checkered_flag:` when fixing something on Windows
    * :bug: `:bug:` when fixing a bug
    * :fire: `:fire:` when removing code or files
    * :green_heart: `:green_heart:` when fixing the CI build
    * :white_check_mark: `:white_check_mark:` when adding tests
    * :lock: `:lock:` when dealing with security
    * :arrow_up: `:arrow_up:` when upgrading dependencies

## CoffeeScript Styleguide

* Use parentheses if it improves code clarity
* Prefer alphabetic keywords to symbolic keywords:
    * `a is b` instead of `a == b`
* Avoid spaces inside the curly-braces of hash literals:
    * `{a: 1, b: 2}` instead of `{ a: 1, b: 2 }`
* Include a single line of whitespace between methods

## Documentation Styleguide

* Use [AtomDoc](https://github.com/atom/atomdoc).
* Use [Markdown](https://daringfireball.net/projects/markdown).
* Reference methods and classes in markdown with the custom `{}` notation:
    * Reference classes with `{ClassName}`
    * Reference instance methods with `{ClassName::methodName}`
    * Reference class methods with `{ClassName.methodName}`

### Example

```coffee
# Public: Disable the package with the given name.
#
# * `name`    The {String} name of the package to disable.
# * `options` (optional) The {Object} with disable options (default: {}):
#     * `trackTime`     A {Boolean}, `true` to track the amount of time taken.
#     * `ignoreErrors`  A {Boolean}, `true` to catch and ignore errors thrown.
# * `callback` The {Function} to call after the package has been disabled.
#
# Returns `undefined`.
disablePackage: (name, options, callback) ->
```
