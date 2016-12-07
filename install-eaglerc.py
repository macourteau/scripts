#!/usr/bin/env python

import os
import re
import shutil
import sys

STRIP_NUMBER_RE = re.compile('^(.*)\.[0-9]+$')
EXTRACT_NUMBER_RE = re.compile('^.*\.([0-9]+)$')


def sort_order(lhs, rhs):
  """Compare function for eaglerc file lines.

  This will make sure that keys that end with a number are sorted correctly.

  Args:
    lhs: The left-hand part of the comparison.
    rhs: The right-hand part of the comparison.

  Returns:
    A negative value if |lhs| is smaller than |rhs|, zero if they are equal and
    a positive value if |lhs| is greater than |rhs|.
  """
  lhs_key = lhs.split('=')[0].strip()
  rhs_key = rhs.split('=')[0].strip()
  try:
    if STRIP_NUMBER_RE.sub(r'\1', lhs_key) == STRIP_NUMBER_RE.sub(r'\1', rhs_key):
      lhs_number = int(EXTRACT_NUMBER_RE.sub(r'\1', lhs_key))
      rhs_number = int(EXTRACT_NUMBER_RE.sub(r'\1', rhs_key))
      return cmp(lhs_number, rhs_number)
  except ValueError:
    pass
  return cmp(lhs, rhs)


def main(argv):
  input_file = os.path.join(os.path.dirname(__file__), 'eaglerc')
  with open(input_file, 'r') as f:
    lines = [stripped_line for stripped_line in (line.strip() for line in f)
             if stripped_line != '']

    # Collect the 'root' paths to update.
    paths = set()
    for line in lines:
      path, value = line.split('=')
      key = STRIP_NUMBER_RE.sub(r'\1', path.strip())
      if key.strip() != path.strip():
        paths.add(re.escape(key) + r'\.[0-9]+')
      else:
        paths.add(re.escape(key))

    # Get the correct path to the eaglerc file.
    if os.name == 'posix':
      target_file = os.path.expandvars('$HOME/.eaglerc')
    else:
      target_file = os.path.expandvars(r'%APPDATA%/CadSoft/EAGLE/eaglerc.usr')

    print 'Target file: "%s"' % target_file

    # Generate a regular expression to match the lines that need to be replaced.
    strip_line_re = re.compile('^[ ]*(%s)' % '|'.join(paths))

    # Load the target file, but skip the lines that will be replaced.
    new_lines = []
    with open(target_file, 'r') as tf:
      new_lines = [line.strip() for line in tf if not strip_line_re.match(line)]

    # Add the new lines to the list.
    new_lines.extend(lines)

    # Sort all the lines but skip the file header.
    new_lines[2:] = sorted(new_lines[2:], sort_order)

    # Make a backup copy of the target file.
    shutil.copy(target_file, target_file + '.bak')

    # Write the new file out.
    with open(target_file, 'w') as tf:
      tf.write('\n'.join(new_lines))
      tf.write('\n')  # Terminate file with newline.


if __name__ == '__main__':
  sys.exit(main(sys.argv))
