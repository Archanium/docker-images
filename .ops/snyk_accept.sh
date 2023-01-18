#!/usr/bin/env bash
if [[ "${SNYK_TOKEN}x" == "x" ]]; then
  echo "SNYK_TOKEN is not configured, no reason to accept snyk license";
  export SNYK_ACCEPTED=0;
  exit 0;
fi;
mkdir -p ~/.docker/cli-plugins && \
curl https://github.com/docker/scan-cli-plugin/releases/latest/download/docker-scan_linux_amd64 -L -s -S -o ~/.docker/cli-plugins/docker-scan && \
chmod +x ~/.docker/cli-plugins/docker-scan
#docker scan --accept-license --token "${SNYK_TOKEN}" --login
#docker scan --version
export SNYK_ACCEPTED=1;