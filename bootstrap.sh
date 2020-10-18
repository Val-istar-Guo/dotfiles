#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
  rsync --exclude ".DS_Store" \
    --exclude ".osx" \
    -avh --no-perms ./src/ ~;

  if [ -e ~/.after_bootstrap.sh ]; then
    echo 'run after'
    ~/.after_bootstrap.sh;
  fi;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt;
  fi;
fi;
unset doIt;
