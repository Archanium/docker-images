#!/usr/bin/env bash
if [[ "${SNYK_TOKEN}x" == "x" ]]; then
  echo "SNYK_TOKEN is not configured, no reason to accept snyk license";
  export SNYK_ACCEPTED=0;
  exit 0;
fi;
docker scan --accept-license --token "${SNYK_TOKEN}" --login
docker scan --version
export SNYK_ACCEPTED=1;