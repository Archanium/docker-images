FROM ubuntu:20.04
RUN apt-get update -y && apt-get install -y curl
ENV EXTRA_KEYS=""
ENV GITHUB_MEMBERS=""
WORKDIR "/workdir"
COPY ./script.sh .
CMD [ "/usr/bin/bash", "/workdir/script.sh"]