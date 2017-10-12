#!/usr/bin/env python

"""Utility script to convert filenames to lowercase, and remove whitespace."""

import argparse
import os
import re


def RenameFile(path, filename):
  new_filename = re.sub(r'\s', '_', filename.lower())
  old_path = os.path.join(path, filename)
  new_path = os.path.join(path, new_filename)
  if old_path != new_path:
    os.rename(old_path, new_path)


def main():
  parser = argparse.ArgumentParser(description='Recursively convert filenames '
                                   'to lowercase and replace whitespace with '
                                   'underscores')
  parser.add_argument('-a', '--all', action='store_true', help='Convert files '
                      'whose name starts with a dot (.) too')
  args = parser.parse_args()

  top_path = os.getcwd()
  for root, _, files in os.walk(top_path):
    current_path = os.path.join(top_path, root)
    for filename in files:
      if args.all or not filename.startswith('.'):
        RenameFile(current_path, filename)


if __name__ == '__main__':
  main()
