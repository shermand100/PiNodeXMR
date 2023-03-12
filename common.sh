#!/bin/bash
#Common variables and functions

DEBUG_LOG=/home/nanode/debug.log

showtext() {
	log "$*"
	echo -e "\e[32m$*\e[0m"
}

log() {
	echo "$*" | tee -a "$DEBUG_LOG"
}

export -f log
export -f showtext
export DEBUG_LOG
