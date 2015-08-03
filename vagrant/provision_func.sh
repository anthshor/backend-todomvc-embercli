#!/bin/bash

DATE="`date +%y%m%d%H%M`"

##############
#
# Functions
#
##############

f_proxy(){
# Proxy
[ -f /vagrant/proxy.env ] && source /vagrant/proxy.env
}

f_emberInitApp(){
  pushd /home/vagrant
  sudo ember new $1
  sudo chown -R vagrant: .config $1
  [ -f /tmp/millis-test-sync ] && sudo chown vagrant: /tmp/millis-test-sync
}

f_emberStartApp(){
if [ -d $1 ]; then 
  sudo chown -R vagrant: .config $1 
  [ -f /tmp/millis-test-sync ] && sudo chown vagrant: /tmp/millis-test-sync
  pushd $1 
  ember server
# Start bulk comment
: '
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
'
# - End bulk comment
else
  echo "folder ${1} not found!!"
  exit 1
fi
}

##########
#
# Main
#
##########

# Set proxy if required
f_proxy

# Initialize app if it doesn't exist
[ ! -d todomvc-embercli ] && f_emberInitApp todomvc-embercli

# Start the app if set in Vagrantfile
if [ $1 == "Y" ]; then
  echo "Starting app"
  f_emberStartApp todomvc-embercli
else
  echo "Not starting app"
fi
