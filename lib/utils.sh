#!/bin/bash

is_installed() {
    dpkg -s "$1" &> /dev/null
}

is_debian_like() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        [[ "$ID_LIKE" == *debian* || "$ID" == "debian" ]] && return 0
    fi
    return 1
}