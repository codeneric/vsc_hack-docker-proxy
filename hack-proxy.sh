#!/usr/bin/env bash

# This is the proxy. You'll want to configure your IDE settings in such way that it points to this file instead of the actual binary.
# This file has to be copy-pasted for each binary. 
# For example, the VS Code Reason plugin needs paths to numerous binaries, such as opam, remft and so on. 
# You would need to have a file such as this one for each of them and replacing "ORIGINAL_COMMAND" with "opam" or "remft".
# The "$@" is a forward of all parameters

# We are ignoring the --format command, since it breaks the code in the used version. 
# set -euo pipefail

# echo "NUM of ARGS: $#" >> /home/denis/Projects/phmm-2/hack-proxy.log
# echo "ARGS: $@" >> /home/denis/Projects/phmm-2/hack-proxy.log
# echo "PROXY INVOKED ($@)" >> /home/denis/Projects/phmm-2/hack-proxy.log
MY_PATH="`dirname \"$0\"`"
LOG_PATH=$MY_PATH/hack-proxy.log 

if [ "$1" = "start" ]
then 
    bash $MY_PATH/start-hack.sh
    exit 0
fi

if [ "$1" = "--format" ]
then 
    # echo "ERROR OUT ($@)" >> /home/denis/Projects/phmm-2/hack-proxy.log
    # echo "PROXY ENDED ($@)" >> /home/denis/Projects/phmm-2/hack-proxy.log
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
    # echo "STDIN OPEN ($@)" >> /home/denis/Projects/phmm-2/hack-proxy.log
    # RES=$( cat - | docker exec -i hack hh_client $@ )
    cat - | docker exec -i hack hh_client $@ 
    # echo "STDIN CLOSED ($@)" >> /home/denis/Projects/phmm-2/hack-proxy.log
elif [ ${stdin_required["$1"]} = 0 ]
then
    # echo "NO STDIN OPEN ($@)" >> /home/denis/Projects/phmm-2/hack-proxy.log
    # RES=$( docker exec hack hh_client $@ )
    
    docker exec hack hh_client $@ 2>&1
    # echo "COMMAND DONE ($@)" >> /home/denis/Projects/phmm-2/hack-proxy.log
else
    echo "unhandled command: ($@)" >> $LOG_PATH
fi

# echo "RES $RES" >> /home/denis/Projects/phmm-2/hack-proxy.log
# echo "$RES"
# echo "PROXY ENDED ($@)" >> /home/denis/Projects/phmm-2/hack-proxy.log
