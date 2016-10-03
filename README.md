# Rndr
[![Build Status](https://travis-ci.org/mrbobbytables/rndr.svg?branch=master)](https://travis-ci.org/mrbobbytables/rndr)
[![Coverage Status](https://coveralls.io/repos/github/mrbobbytables/rndr/badge.svg?branch=ci)](https://coveralls.io/github/mrbobbytables/rndr?branch=ci)

Rndr is a small Ruby cli gem that provides a method of rendering discovered erb templates. Variables for use in template rendering can be used directly by providing a either a `yaml` or `json` file, or alternatively a directory may be supplied along with the variable merging strategy. Rndr supports both standard hash merges or recursive (default).

Paths can be ignored by either creating a `.rndrignore` file within the current working directly, or supplying a path to a desired ignore file.


* [Commands](#commands)
  * [Check](#check)
  * [List](#list)
  * [Render](#render)
  * [Vars](#vars)

## Commands

```
$ bin/rndr help
Commands:
  rndr check           # Verifies discovered erb templates.
  rndr help [COMMAND]  # Describe available commands or one specific command
  rndr list            # List discovered templates.
  rndr render          # Renders discovered templates.
  rndr vars            # Lists Combined Variables.
  rndr version         # Prints rndr Version Information.
...
```

### Check

```
$ bin/rndr help check
Usage:
  rndr check

Options:
  e, [--extension=EXTENSION]  # Extension of templates.
                              # Default: erb
  i, [--ignore=IGNORE]        # Path to file containing list of files to be ignored.
                              # Default: /Users/demo/ruby/rndr/.rndrignore
  m, [--merge], [--no-merge]  # Recursively merge variables instead of replacing.
                              # Default: true
  t, [--template=TEMPLATE]    # Path to erb template or directory.
                              # Default: /Users/demo/ruby/rndr/rndr
  V, [--vars=VARS]            # Path to var file or directory.
                              # Default: /Users/demo/ruby/rndr/vars

Verifies discovered erb templates.
```

### List

```
$ bin/rndr help list
Usage:
  rndr list

Options:
  e, [--extension=EXTENSION]  # Extension of templates.
                              # Default: erb
  i, [--ignore=IGNORE]        # Path to file containing list of files to be ignored.
                              # Default: /Users/demo/ruby/rndr/.rndrignore
  t, [--template=TEMPLATE]    # Path to erb template or directory.
                              # Default: /Users/demo/ruby/rndr/rndr

List discovered templates.
```

### Render

```
$ bin/rndr help render
Usage:
  rndr render

Options:
  e, [--extension=EXTENSION]  # Extension of templates.
                              # Default: erb
  i, [--ignore=IGNORE]        # Path to file containing list of files to be ignored.
                              # Default: /Users/demo/ruby/rndr/.rndrignore
  m, [--merge], [--no-merge]  # Recursively merge variables instead of replacing.
                              # Default: true
  t, [--template=TEMPLATE]    # Path to erb template or directory.
                              # Default: /Users/demo/ruby/rndr/rndr
  V, [--vars=VARS]            # Path to var file or directory.
                              # Default: /Users/demo/ruby/rndr/vars

Renders discovered templates.
```

### Vars

```
$ bin/rndr help vars
Usage:
  rndr vars

Options:
  f, [--format=FORMAT]        # Output Format [yaml|json]
                              # Default: yaml
  m, [--merge], [--no-merge]  # Recursively merge variables instead of replacing.
                              # Default: true
  V, [--vars=VARS]            # Path to var file or directory.
                              # Default: /Users/demo/ruby/rndr/vars

Lists Combined Variables.
```