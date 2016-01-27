#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

function run_dynomite() {
  /dynomite/src/dynomite --conf-file=/dynomite/conf/dynomite.yml -v${MESOS_DYNOMITE_LOGLEVEL}
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
