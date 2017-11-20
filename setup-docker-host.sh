#!/usr/bin/env bash
# remove old version of docker
apt-get update
apt-get remove docker docker-engine docker.io
# install recommended pkgs and needed to add the docker repo
apt-get install \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
# import and verify the docker key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
# add the repository
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
# install docker
apt-get update
apt-get install docker-ce
