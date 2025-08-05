#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

print_msg() {
    local level="$1"; shift
    local message="$*"
    local color label

    case "$level" in
        "info")
            color="${CYAN}"
            label="INFO"
            ;;
        "success")
            color="${GREEN}"
            label="SUCCESS"
            ;;
        "warning")
            color="${YELLOW}"
            label="WARNING"
            ;;
        "error")
            color="${RED}"
            label="ERROR"
            ;;
        *)
            color="${CYAN}"
            label="INFO"
            ;;
    esac

    echo -e "${color}[$label] $message${RESET}"
    sleep 2
}