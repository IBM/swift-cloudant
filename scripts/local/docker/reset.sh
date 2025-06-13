#!/bin/bash

alias docker="podman"

# run the stop script
zsh ./scripts/local/docker/stop.sh &&

printf "\nre-running installation and container start script..\n"

# run install script
zsh ./scripts/local/docker/pull-run-couch-latest.sh

printf "\ndocker env configuration reset completed.\n\n"