#!/bin/bash

if [ "$(cat /workspace/.devcontainer/sidea-devcontainer.version)" == \
    "$(curl -s https://raw.githubusercontent.com/franc-liuzzi/sidea-web-academy-devcontainer/master/.devcontainer/sidea-devcontainer.version)" ]; then
    echo "You're already using the latest version";
    exit 0
fi

wget --quiet -O /tmp/sidea-workspace.zip "https://raw.githubusercontent.com/franc-liuzzi/sidea-web-academy-devcontainer/master/sidea-workspace.zip"
rm -rf /workspace/.devcontainer/* /workspace/.vscode/*
unzip -o /tmp/sidea-workspace.zip -d /workspace
echo ""
echo "Devcontainer updated. Now you can restart your dev environment."
echo "In vscode \`Ctrl + shift + P\` and execute command \"Remote-Containers: Rebuild Container\""