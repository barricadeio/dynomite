#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

function run_dynomite() {
  # verbosity flag sets logging level (default: 5, min: 0, max: 11)
  /dynomite/src/dynomite --daemonize --conf-file=/dynomite/conf/dynomite.yml --verbosity=11
}

function run_consul_template() {
  service consul-template start
}

function run_florida() {
  nodejs /dynomite/scripts/Florida/florida.js
}

function run() {
  run_dynomite
  run_consul_template
  run_florida
}

run
