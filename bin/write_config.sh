#!/usr/bin/env bash

#
# Write a dynomite configuration file from environment variables.
#
# Environment variables namespaced with `MESOS_DYNOMITE_`
#
set -o errexit
set -o nounset

# Redis/Memcached server list
: ${MESOS_DYNOMITE_BACKEND_SERVERS:=localhost}

__MESOS_DYNOMITE_SERVERS=""
for server in ${MESOS_DYNOMITE_BACKEND_SERVERS}
do
  __MESOS_DYNOMITE_SERVERS="${__MESOS_DYNOMITE_SERVERS} - ${server}"$'\n'
done

# Redis/Memcached Server to be used as backend
MESOS_DYNOMITE_SERVER_IP=$(dig +short ${MESOS_DYNOMITE_SERVER_NAME})
MESOS_DYNOMITE_SERVER_PORT=$(dig +short SRV ${MESOS_DYNOMITE_SERVER_NAME} | awk '{print $3}')

# Weight of the Redis/Memcached Server
: ${MESOS_DYNOMITE_SERVER_WEIGHT:=1}

# Location where config should be written
: ${MESOS_DYNOMITE_CONFIG_LOCATION:=conf/dynomite.yml}

# These may be specified by the scheduler
MESOS_DYNOMITE_PEER_LISTEN_PORT=${PORT0:-8101}
MESOS_DYNOMITE_CLIENT_LISTEN_PORT=${PORT1:-8102}

# IP Address for peer communication
: ${MESOS_DYNOMITE_PEER_LISTEN_IP:=127.0.0.1}

# IP Address for client communication
: ${MESOS_DYNOMITE_CLIENT_LISTEN_IP:=127.0.0.1}

# Name of the datacenter the dynomite instance should be part of
: ${MESOS_DYNOMITE_DATACENTER:=dc}

# Name of the rack the dynomite instance should be part of
: ${MESOS_DYNOMITE_RACK:=rack}

# Provider to use to get the list of seed nodes
: ${MESOS_DYNOMITE_SEED_PROVIDER:=simple_provider}

# Token owned by the node
: ${MESOS_DYNOMITE_TOKENS:=0}

# Sercure Server Option
: ${MESOS_DYNOMITE_SECURE_SERVER_OPTION:=datacenter}

# Pem key file
: ${MESOS_DYNOMITE_PEM_KEY_FILE:=conf/dynomite.pem}

# Integer value that controls whether the server pool speak redis(0)
# or memcached(1) or other protocol
: ${MESOS_DYNOMITE_DATA_STORE:=0}

# Write configuration

printf "Writing configuration to file ${MESOS_DYNOMITE_CONFIG_LOCATION}\n"
cat > ${MESOS_DYNOMITE_CONFIG_LOCATION} <<- EndOfConfig
# Dynomite Configuration File
# ---------------------------

dyn_o_mite:
  datacenter: ${MESOS_DYNOMITE_DATACENTER}
  rack: ${MESOS_DYNOMITE_RACK}
  dyn_listen: ${MESOS_DYNOMITE_PEER_LISTEN_IP}:${MESOS_DYNOMITE_PEER_LISTEN_PORT}
  dyn_seed_provider: ${MESOS_DYNOMITE_SEED_PROVIDER}
  listen: ${MESOS_DYNOMITE_CLIENT_LISTEN_IP}:${MESOS_DYNOMITE_CLIENT_LISTEN_PORT}
  servers:
  - ${MESOS_DYNOMITE_SERVER_IP}:${MESOS_DYNOMITE_SERVER_PORT}:${MESOS_DYNOMITE_SERVER_WEIGHT}
  tokens: '${MESOS_DYNOMITE_TOKENS}'
  secure_server_option: ${MESOS_DYNOMITE_SECURE_SERVER_OPTION}
  pem_key_file: ${MESOS_DYNOMITE_PEM_KEY_FILE}
  data_store: ${MESOS_DYNOMITE_DATA_STORE}
EndOfConfig
