#!/bin/bash

# Proxy
[ -f /vagrant/proxy.env ] && source /vagrant/proxy.env

pushd /home/vagrant
if [ ! -d todomvc-embercli ]; then
  sudo ember new todomvc-embercli
  sudo chown -R vagrant: .config todomvc-embercli
  [ -f /tmp/millis-test-sync ] && sudo chown vagrant: /tmp/millis-test-sync
fi

DATE="`date +%y%m%d%H%M`"

if [ -d todomvc-embercli ]; then 
  sudo chown -R vagrant: .config todomvc-embercli /tmp/millis-test-sync
  git remote -v | grep 'https://github.com/anthshor/todomvc-embercli.git'
  if [ $? -eq 0 ]; then
    git pull
    if [ $? -ne 0 ]; then
       echo "git pull failed"
       echo "review manually and fix the error"
       exit 2
    fi
  else
    git clone https://github.com/anthshor/todomvc-embercli.git app
  fi
  [ -f /tmp/millis-test-sync ] && sudo chown vagrant: /tmp/millis-test-sync
  ember server
else
  echo "folder todomvc-embercli not found!!"
  exit 1
fi
