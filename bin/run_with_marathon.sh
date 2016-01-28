#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

EXTRA_FLAGS=""
if [ $MESOS_DYNOMITE_ENABLE_GOSSIP == "true" ]
then
  EXTRA_FLAGS="-g"
fi

function run_dynomite() {
  /dynomite/src/dynomite --conf-file=/dynomite/conf/dynomite.yml -v${MESOS_DYNOMITE_LOGLEVEL} ${EXTRA_FLAGS}
}

function run_consul_template() {
  service consul-template start
}

function run_florida() {
  nodejs /dynomite/scripts/Florida/florida.js 1> /var/log/florida.out 2> /var/log/florida.err &
}

function run() {
  run_consul_template
  run_florida
  run_dynomite
}

run
