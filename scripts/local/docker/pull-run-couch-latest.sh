#!/bin/bash

# source env vars
source ./scripts/local/local-vars.sh

# required since docker desktop is no longer used
alias docker="podman"

# pull the latest couchdb image 
docker pull couchdb

# and run with env from local-vars
docker run \
	--name couchdb \
	-d \
	-p 5984:5984 -p 8080:80 \
	-e COUCHDB_USER=$SERVER_USER \
	-e COUCHDB_PASSWORD=$SERVER_PASSWORD \
	couchdb:latest &&

# brief pause to let service come online
sleep 1 &&

# configure couchdb as single node to finalize setup
curl -X POST $SERVER_URL/_cluster_setup \
	-H 'Content-Type: application/json' \
	-H 'Authorization: Basic YWRtaW46cEBzc3cwcmQ=' \
	-d '{"action":"enable_single_node","bind_address": "0.0.0.0"}'