"""Sublime Text plugin to find the Chromium OWNERS for the current file.

In a Chromium checkout, this will search for the closest OWNERS file and list
its contents. Select an entry to copy to the clipboard. You can also open the
displayed OWNERS file, or walk up the directory tree to the next OWNERS file.
"""

import os
import sublime
import sublime_plugin


class FindOwnersCommand(sublime_plugin.WindowCommand):
  """Implements the Find Owners command."""

  def run(self):
    self.find_owners(self.window.active_view().file_name())

  def find_owners(self, start_path):
    current_directory = start_path
    while True:
      new_directory = os.path.dirname(current_directory)
      if new_directory == current_directory:
        sublime.error_message('No OWNERS file found for "%s".'% start_path)
        return
      current_directory = new_directory
      current_owners_file_path = os.path.join(current_directory, 'OWNERS')
      if os.path.exists(current_owners_file_path):
        self.last_directory = current_directory
        self.owners_file_path = current_owners_file_path
        with open(self.owners_file_path, 'r') as owners_file:
          sublime.status_message('Found OWNERS file: "%s".' %
                                 self.owners_file_path)
          data = owners_file.read()
          self.lines = data.strip().split('\n')
          self.lines.insert(0, '[Show parent OWNERS file]')
          self.lines.insert(1, '[Open this OWNERS file]')
          self.lines.insert(2, '----- (select owner below to copy) -----')
          self.window.show_quick_panel(self.lines,
                                       self.on_select,
                                       sublime.MONOSPACE_FONT)
        return

  def on_select(self, index):
    # Show parent OWNERS file.
    if index == 0:
      self.find_owners(self.last_directory)
    # Open this OWNERS file.
    elif index == 1:
      self.window.open_file(self.owners_file_path)
    # Copy this line to clipboard.
    elif index > 2:
      sublime.set_clipboard(self.lines[index])
      sublime.status_message('Copied "%s" to clipboard.' % self.lines[index])
