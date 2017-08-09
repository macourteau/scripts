"""Sublime Text plugin to open files changed in the current branch.

This plugin assumes that a sublime-project file is open, and assumes that the
root directory is the first directory in the project whose last element is
'src'.

This plugin will figure out how many revisions ahead of the upstream branch
the current branch is, then figure out which files have changed since the
revision this was branched from on the upstream branch. It will then open a new
window, and open all those files in that window.
"""

import os
import re
import sublime
import sublime_plugin
import subprocess


class OpenChangedFilesInNewWindowCommand(sublime_plugin.WindowCommand):
  """Implements the Open Changed Files In New Window command."""

  def run(self):
    files = self.get_changed_files_since_upstream_()
    self.open_in_new_window_(files)

  def get_root_directory_(self):
    for directory in self.window.folders():
      if os.path.basename(directory) == 'src':
        print('root directory: %s' % directory)
        return directory
    raise Exception('Failed to find root directory; folders = %s' %
                    self.window.folders())

  def run_command_(self, cmd):
    cwd = self.get_root_directory_()
    process = subprocess.Popen(
        cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=cwd)

    (stdout, stderr) = process.communicate()
    if process.returncode != 0:
      raise Exception('subprocess exited with code %d\ncommand = %s' %
                      (process.returncode, cmd))

    return (stdout.decode('utf-8'), stderr.decode('utf-8'))

  def get_number_of_revisions_ahead_of_upstream_(self):
    (stdout, _) = self.run_command_(
        ['git', 'rev-list', '--left-right', '--count', '@{u}...HEAD'])

    before_after = re.search(r'(\d+)\s+(\d+)', stdout)
    if not before_after:
      raise Exception('re.search returned no matches for %s' % stdout)

    return int(before_after.group(2))

  def get_changed_files_since_upstream_(self):
    revs = self.get_number_of_revisions_ahead_of_upstream_()
    (stdout, _) = self.run_command_(
        ['git', 'diff', '--name-only', 'HEAD~%d' % revs])
    return stdout.strip().split('\n')

  def open_in_new_window_(self, items):
    if not items:
      print('No files to open!')
      return

    current_project_data = sublime.active_window().project_data()

    root_directory = self.get_root_directory_()
    sublime.run_command('new_window')
    window = sublime.active_window()
    window.set_project_data(current_project_data)
    for item in items:
      window.open_file(os.path.join(root_directory, item))
    window.focus_sheet(window.sheets()[0])
