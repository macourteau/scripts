#!/bin/bash -eu

readonly APP_SUPPORT="$HOME/Library/Application Support"
readonly SUBLIME_USER_DIRECTORY="$APP_SUPPORT/Sublime Text 3/Packages/User"

ls *.py | while read x; do
  target_path="${SUBLIME_USER_DIRECTORY}/${x}"
  echo "${x} -> ${target_path}"
  cp "${x}" "${target_path}"
done
