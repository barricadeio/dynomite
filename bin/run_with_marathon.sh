#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

function run_dynomite() {
  /dynomite/src/dynomite --conf-file=/dynomite/conf/dynomite.yml -v11
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
