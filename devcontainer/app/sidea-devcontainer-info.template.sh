#!/bin/bash
cat << EOF
  ______ _     _                                          
 / _____|_)   | |                                         
( (____  _  __| |_____ _____  ____  ____ ___  _   _ ____  
 \____ \| |/ _  | ___ (____ |/ _  |/ ___) _ \| | | |  _ \ 
 _____) ) ( (_| | ____/ ___ ( (_| | |  | |_| | |_| | |_| |
(______/|_|\____|_____)_____|\___ |_|   \___/|____/|  __/ 
                            (_____|                |_|    
              ---- Fullstack Web Academy ----
Sidea Devcontainer version: $SIDEA_DEVCONTAINER_VERSION

######### MYSQL CONNECTION PARAMS #########
HOST: $MYSQL_HOST
PORT: $MYSQL_PORT
USER: $MYSQL_USER
PASSWORD: $MYSQL_PWD

PhpMyAdmin GUI URL: http://localhost:8888/

############# EXERCISM SETUP ##############
exercism c -w /workspace/exercism -t <auth-token from https://exercism.org/settings/api_cli>

########## UPDATING DEVCONTAINER ##########
1. run in terminal \`sidea-devcontainer-update\`
2. in vscode \`Ctrl + shift + P\` and execute command \"Remote-Containers: Rebuild Container\"
EOF