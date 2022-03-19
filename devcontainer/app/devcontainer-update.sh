#!/bin/bash

wget --quiet -O /tmp/sidea-workspace.zip "https://github.com/franc-liuzzi/sidea-web-academy-devcontainer/blob/master/sidea-workspace.zip?raw=true"
rm /workspace/.devcontainer/*
unzip -o /tmp/sidea-workspace.zip -d /workspace
