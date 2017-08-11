"""Sublime Text plugin to open the file specified where the cursor is.

This plugin assumes that a sublime-project file is open, and tries to find the
file in one of the project's folders.
"""

import os
import sublime
import sublime_plugin


# Boundary characters: whitespace, ", '.
PATH_BOUNDARY_CHARACTERS = [' ', '\t', '\n', '\r', '\f', '\v', '"', '\'']


class GoToFileCommand(sublime_plugin.TextCommand):
  """Implements the Go To File command."""

  def run(self, edit):
    if len(self.view.sel()) > 1:
      raise Exception('Multiple selections are not supported')

    # Expand the region until we reach boundary characters on both sides.
    region = self.view.sel()[0]
    while self.view.substr(region.a - 1) not in PATH_BOUNDARY_CHARACTERS:
      region.a -= 1
    while self.view.substr(region.b) not in PATH_BOUNDARY_CHARACTERS:
      region.b += 1

    file_path = self.view.substr(region)

    # Try to find a folder in which this file exists, and open it.
    for folder in self.view.window().folders():
      potential_path = os.path.join(folder, file_path)
      if os.path.exists(potential_path):
        sublime.run_command('new_window')
        sublime.active_window().open_file(potential_path)
        return

  def is_enabled(self):
    return True if self.view.window().folders() else False
