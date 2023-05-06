#!/bin/bash

#shellcheck source=home/nodo/common.sh
. /home/nodo/common.sh

function get_index() {
  local -n my_array=$1 # use -n for a reference to the array
  for i in "${!my_array[@]}"; do
    if [[ ${my_array[i]} = "$2" ]]; then
      printf '%s\n' "$i"
      return
    fi
  done
  return 1
}


MODES=('safe:sync' 'fast:sync' 'fast:async')

function cycle() {
	current=$(getvar "sync_mode")
	i=$(get_index MODES "$current")
	i=$((i + $1))
	i=$((i % 3)) # 3 = array length
	return "${MODES[$i]}"
}

putvar "sync_mode" "$(cycle 1)"
