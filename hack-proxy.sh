#!/usr/bin/env bash

# This is the proxy. You'll want to configure your IDE settings in such way that it points to this file instead of the actual binary.
# This file has to be copy-pasted for each binary. 
# For example, the VS Code Reason plugin needs paths to numerous binaries, such as opam, remft and so on. 
# You would need to have a file such as this one for each of them and replacing "ORIGINAL_COMMAND" with "opam" or "remft".
# The "$@" is a forward of all parameters

# We are ignoring the --format command, since it breaks the code in the used version. 
# set -euo pipefail

MY_PATH="`dirname \"$0\"`"
LOG_PATH=$MY_PATH/hack-proxy.log 
CONT_NAME="hack"

if [ "$1" = "start" ]
then 
    docker rm -f ${CONT_NAME} 2>/dev/null
    docker run -t -d -v $(pwd):$(pwd) \
        -u $UID \
        --name ${CONT_NAME} \
        codeneric/hack-transpiler
    exit 0
fi

if [ "$1" = "--format" ]
then 
    exit 1
fi

declare -A stdin_required
stdin_required["check"]=0
stdin_required["--color"]=0
stdin_required["--type-at-pos"]=0
stdin_required["--outline"]=1
stdin_required["--search"]=0
stdin_required["--ide-find-refs"]=1
stdin_required["--ide-highlight-refs"]=1
stdin_required["--ide-get-definition"]=1
stdin_required["--auto-complete"]=1
 

if [ ${stdin_required["$1"]} = 1 ]
then 
    cat - | docker exec -i hack hh_client $@ 
elif [ ${stdin_required["$1"]} = 0 ]
then    
    docker exec hack hh_client $@ 2>&1
else
    echo "unhandled command: ($@)" >> $LOG_PATH
fi

