#!/bin/bash

alias docker="podman"

printf "\nstopping and removing container..\n"

# stop container
docker stop couchdb

# rm container
docker rm couchdb