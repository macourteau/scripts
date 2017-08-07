"""Sublime Text plugin to do a Chromium code search.

Select one or more words, and run this command. It will open Chrome to the
results page for a search in Chromium code search for those words.
"""

import platform
import sublime_plugin
import urllib.parse
import webbrowser


def OpenInChrome(url):
  if platform.system() == 'Darwin':
    chrome_path = 'open -a /Applications/Google\\ Chrome.app %s'
  elif platform.system() == 'Windows':
    chrome_path = (
        'C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe %s')
  else:
    chrome_path = '/usr/bin/google-chrome %s'
  webbrowser.get(chrome_path).open(url)


class ChromiumSearchCommand(sublime_plugin.TextCommand):

  def run(self, edit):
    selections = self.view.sel()
    selections = [self.view.substr(self.view.word(selection)
                                   if selection.size() == 0
                                   else selection).strip()
                  for selection in selections]
    query = urllib.parse.quote(' '.join(selections))
    if query:
      OpenInChrome('https://code.google.com/p/chromium/codesearch#search/' +
                   '&q=%s&sq=package:chromium&type=cs' % query)
