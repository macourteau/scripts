# Sublime Text plugins for Chromium development
My collection of useful Sublime Text plugins for Chromium development. Tested
to work on a Mac -- pull requests welcome if they don't work on other platforms.

To install on a Mac:
```
$ ./install_mac.sh
```

You can then configure shortcuts to use these scripts (in Sublime >
Preferences > Key Bindings). Suggested bindings:
```
[
  { "keys": ["super+shift+s"], "command": "chromium_search" },
  { "keys": ["super+shift+o"], "command": "find_owners" },
  { "keys": ["super+shift+a"], "command": "open_changed_files_in_new_window" },
  { "keys": ["super+shift+g"], "command": "go_to_file" },
]
```
