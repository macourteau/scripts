#!/bin/bash -e

# This script is based on the instructions for uninstallation found here:
# http://kb.vmware.com/selfservice/search.do?cmd=displayKC&docType=kc&docTypeID=DT_KB_1_1&externalId=1017838

dry_run=y
if [[ $# -eq 1 ]]; then
  if [[ "$1" == "--no-dry-run" ]]; then
    dry_run=n
  else
    echo "usage: $(basename $0) (--no-dry-run|--help)" 1>&2
    exit
  fi
fi

to_remove=(
  "/Library/Application Support/VMware"
  "/Library/Application Support/VMware Fusion"
  "/Library/Preferences/VMware Fusion"
  "${HOME}/Library/Application Support/VMware Fusion"
  "${HOME}/Library/Caches/com.vmware.fusion"
  "${HOME}/Library/Preferences/VMware Fusion"
  "${HOME}/Library/Preferences/com.vmware.fusion.LSSharedFileList.plist"
  "${HOME}/Library/Preferences/com.vmware.fusion.LSSharedFileList.plist.lockfile"
  "${HOME}/Library/Preferences/com.vmware.fusion.plist"
  "${HOME}/Library/Preferences/com.vmware.fusion.plist.lockfile"
  "${HOME}/Library/Preferences/com.vmware.fusionDaemon.plist"
  "${HOME}/Library/Preferences/com.vmware.fusionDaemon.plist.lockfile"
  "${HOME}/Library/Preferences/com.vmware.fusionStartMenu.plist"
  "${HOME}/Library/Preferences/com.vmware.fusionStartMenu.plist.lockfile"
  "/Applications/VMware Fusion.app"
)

if [[ "${dry_run}" != "n" ]]; then
  echo "*** this is a dry run; run with \"--no-dry-run\" to actually uninstall"
fi

i=0
while [[ "x${to_remove[i]}" != "x" ]]; do
  if [[ -e "${to_remove[i]}" ]]; then
    echo -n "Removing \"${to_remove[i]}\"... "
    if [[ "${dry_run}" != "n" ]]; then
      echo "(dry run)"
    else
      sudo rm -rf "${to_remove[i]}"
      echo "done."
    fi
  fi
  i=$(( $i + 1 ))
done
