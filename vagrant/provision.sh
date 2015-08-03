#!/bin/bash
# 31/07 - Added npm install and bower install after git clone

# Proxy
[ -f /vagrant/proxy.env ] && source /vagrant/proxy.env

pushd /home/vagrant
if [ ! -d todomvc-embercli ]; then
  sudo ember new todomvc-embercli
  sudo chown -R vagrant: todomvc-embercli
  [ -f /tmp/millis-test-sync ] && sudo chown vagrant: /tmp/millis-test-sync
  [ -f .config ] && sudo chown vagrant: .config
fi

DATE="`date +%y%m%d%H%M`"
# Don't want to provision app yet
exit

if [ -d todomvc-embercli ]; then 
  sudo chown -R vagrant: todomvc-embercli 
  [ -f /tmp/millis-test-sync ] && sudo chown vagrant: /tmp/millis-test-sync
  [ -f .config ] && sudo chown vagrant: .config
  git remote -v | grep 'https://github.com/anthshor/todomvc-embercli.git'
  if [ $? -eq 0 ]; then
    pushd todomvc-embercli
    git pull origin master
    if [ $? -ne 0 ]; then
       echo "git pull failed"
       echo "review manually and fix the error"
       exit 2
    fi
  else
    git clone https://github.com/anthshor/todomvc-embercli.git
    pushd todomvc-embercli
    npm install 
    bower install 
  fi
  [ -f /tmp/millis-test-sync ] && sudo chown vagrant: /tmp/millis-test-sync
  ember server
else
  echo "folder todomvc-embercli not found!!"
  exit 1
fi
