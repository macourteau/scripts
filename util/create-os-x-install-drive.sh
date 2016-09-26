#!/bin/bash -eu

if [[ $# -ne 1 ]]; then
  echo "usage: $(basename $0) <path to InstallESD.dmg file>" 1>&2
  echo "" 1>&2
  echo "This script also expects a clean USB key mounted to /Volumes/Untitled" 1>&2
  exit 1
fi

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until we're finished
while true
do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# Attach the InstallESD.dmg image.
sudo hdiutil attach "$1"

# Restore the BaseSystem.dmg image from the InstallESD.dmg image.
sudo asr restore \
    -source /Volumes/OS\ X\ Install\ ESD/BaseSystem.dmg \
    -target /Volumes/Untitled \
    -erase \
    -format HFS+

# Remove the "Packages" symlink from the restored filesystem.
sudo rm /Volumes/OS\ X\ Base\ System/System/Installation/Packages

# Copy the Packages directory from the InstallESD.dmg image to the filesystem.
sudo cp -a \
    /Volumes/OS\ X\ Install\ ESD/Packages \
    /Volumes/OS\ X\ Base\ System/System/Installation/Packages

# Copy the BaseSystem.{chunklist,dmg} files to the filesystem.
sudo cp -a \
    /Volumes/OS\ X\ Install\ ESD/BaseSystem.chunklist \
    /Volumes/OS\ X\ Base\ System
sudo cp -a \
    /Volumes/OS\ X\ Install\ ESD/BaseSystem.dmg \
    /Volumes/OS\ X\ Base\ System

# Eject the InstallESD.dmg image.
sudo hdiutil detach /Volumes/OS\ X\ Install\ ESD

echo "All done. Eject the USB key before unplugging it!"
