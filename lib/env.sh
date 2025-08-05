#!/bin/bash

USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)