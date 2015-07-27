#!/bin/bash -eux

# Install node.js
curl -sL https://deb.nodesource.com/setup_0.12 | bash -
apt-get install -y nodejs

# install required packages 
apt-get -y install git g++ autoconf automake

#Install ember
npm install -g ember-cli

# Create framework
pushd /home/vagrant
sudo ember new todomvc-embercli
sudo chown -R vagrant: todomvc-embercli
