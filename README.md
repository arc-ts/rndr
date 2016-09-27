# Rndr
A small ruby based cli application that renders discovered ruby templates.
Files and directories can be ignored by creating a `.rndrignore` file within the directory it is being executed.


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
  m, [--merge], [--no-merge]  # Recursively merge variables instead of replacing.
                              # Default: true
  t, [--template=TEMPLATE]    # Path to erb template or directory.
                              # Default: /Users/bob/projects/ruby/rndr
  V, [--vars=VARS]            # Path to var file or directory.
                              # Default: /Users/bob/projects/ruby/rndr/vars

Verifies discovered erb templates.
...
```

### List

```
$ bin/rndr help list
Usage:
  rndr list

Options:
  e, [--extension=EXTENSION]  # Extension of templates.
                              # Default: erb
  t, [--template=TEMPLATE]    # Path to erb template or directory.
                              # Default: /Users/bob/projects/ruby/rndr

List discovered templates.
...
```

### Render

```
$ bin/rndr help render
Usage:
  rndr render

Options:
  e, [--extension=EXTENSION]  # Extension of templates.
                              # Default: erb
  m, [--merge], [--no-merge]  # Recursively merge variables instead of replacing.
                              # Default: true
  t, [--template=TEMPLATE]    # Path to erb template or directory.
                              # Default: /Users/bob/projects/ruby/rndr
  V, [--vars=VARS]            # Path to var file or directory.
                              # Default: /Users/bob/projects/ruby/rndr/vars

Renders discovered templates.
...
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
                              # Default: /Users/bob/projects/ruby/rndr/vars

Lists Combined Variables.
...
```