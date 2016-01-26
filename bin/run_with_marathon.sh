#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

function run_dynomite() {
  /dynomite/src/dynomite --conf-file=/dynomite/conf/dynomite.yml -v11
}

function run_florida() {

}

function run() {
  run_dynomite
  run_florida
}

run
