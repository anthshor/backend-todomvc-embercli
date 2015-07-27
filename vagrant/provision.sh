#!/bin/bash

# Proxy
[ -f /vagrant/proxy.env ] && source /vagrant/proxy.env

pushd /home/vagrant
if [ ! -d helloapp ]; then
  sudo ember new helloapp
  sudo chown -R vagrant: .config helloapp
  [ -f /tmp/millis-test-sync ] && sudo chown vagrant: /tmp/millis-test-sync
fi

DATE="`date +%y%m%d%H%M`"

if [ -d helloapp ]; then 
  sudo chown -R vagrant: .config helloapp /tmp/millis-test-sync
  pushd helloapp
  if [ -d app ]; then 
    pushd app
    git remote -v | grep 'https://github.com/anthshor/emberjs-app1.git'
    if [ $? -eq 0 ]; then
      git pull
      if [ $? -ne 0 ]; then
        echo "git pull failed"
        echo "review manually and fix the error"
        exit 2
      fi
    else
      popd
      mv app app.${DATE}
      git clone https://github.com/anthshor/emberjs-app1.git app
    fi
  else
    git clone https://github.com/anthshor/emberjs-app1.git app
  fi
  [ -f /tmp/millis-test-sync ] && sudo chown vagrant: /tmp/millis-test-sync
  ember server
else
  echo "folder helloapp not found!!"
  exit 1
fi
