#!/bin/bash


#
# Kevin Zuern   - 10134425
# Deven Bernard - 10099810
# Marissa Huang - 10179169
#


function show_help() {
  echo "help"
}

function show_permission_diff() {
  echo "show"
}

function reset_permissions() {
  echo "reset"
}

function snapshot_permissions() {
  traverse_all_child_files
}

########################################
########################################
########################################

function getFileName() {
  snapshotNumber=""

  if [ ! -f $(pwd)/savedPermissions ]; then
    touch savedPermissions
  else
    snapshotNumber="$(find savedPermissions* | wc -l )"
  fi

  echo "savedPermissions$snapshotNumber"
}

function traverse_all_child_files() {
  # find all child files & dirs
  find $(pwd) | while read file; do
    ls -al $file | awk '{print $1 " " $9}' >> .permissionsTemp
  done

  savedPermissions="$(getFileName)"

  while read entry; do
    
    if [[ ! $entry =~ total 
       && ! $entry =~ ^.{10}\ \.\.?
       && ! $entry =~ permissionsSaver
       && ! $entry =~ savedPermissions ]]; then
      echo $entry >> $savedPermissions  
    fi
  
  done <.permissionsTemp

  rm .permissionsTemp
  cat $savedPermissions

}

########################################
########################################
########################################

if [[ $1 =~ ^\-s$ ]]; then
  show_permission_diff
elif [[ $1 =~ ^\-r$ ]]; then
  reset_permissions
elif [[ $1 =~ (^\-\-help$)|(^\-h$) ]]; then
  show_help
elif [[ $1 =~ '' ]]; then
  snapshot_permissions
else
  echo "Invalid arguments specified"
  show_help
fi
