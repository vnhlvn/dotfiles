#!/usr/bin/env bash

rm -rf ~/.tmux.conf
ln -s $(pwd)/.tmux.conf ~

rm -rf ~/weather.sh
ln -s $(pwd)/weather.sh ~
