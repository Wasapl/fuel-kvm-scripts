source functions/vm.sh
source functions/env.sh
source functions/snapshot.sh
# source arrays which contains VMs and snapshots names.
arrays=./$(hostname)-vms.sh
if [ ! -f $arrays ]; then
  echo "there is no array declarations for host '$(hostname)'"
  exit 1
fi
source ./$(hostname)-vms.sh

# get all env names
env_names=""
for K in "${!env[@]}"; do
    if [ -z "$env_names" ]; then env_names=$K;
    else env_names="$env_names , $K";
    fi;
done

ENV_NAME=${1-${SRC_ENV}-1}

# Check if $ENV_NAME contains right Env names.
if [ ! ${env[$ENV_NAME]+abc} ]; then
    echo "there is no such Env as '$ENV_NAME'"
    exit 1
fi

cleanup_env $ENV_NAME $env
start_env $ENV_NAME $env

sleep 120

#test Env operability
if [ ! ${fuel[$ENV_NAME]+abc} ]; then
    echo "There is no fuel node for this Env. Skip test Env operability."
else
    ssh_options='-oConnectTimeout=5 -oStrictHostKeyChecking=no -oCheckHostIP=no -oUserKnownHostsFile=/dev/null -oRSAAuthentication=no -oPubkeyAuthentication=no'
    read fuelhost envid <<< "${fuel[$ENV_NAME]}"
    username=root
    password=r00tme
    prompt='root@fuel ~]#'
    #ssh fuel
    #fuel health --check smoke --env $envid
    result=$(
        expect << ENDOFEXPECT
        spawn ssh $ssh_options $username@$fuelhost
        expect "*?assword:*"
        send "$password\r"
        expect "$prompt"
        set timeout 360
        send "fuel health --check smoke --env $envid\r"
        expect "$prompt"
ENDOFEXPECT
    )
    echo $result

    # When you are launching command in a sub-shell, there are issues with IFS (internal field separator)
    # and parsing output as a set of strings. So, we are saving original IFS, replacing it, iterating over lines,
    # and changing it back to normal
    #
    # http://blog.edwards-research.com/2010/01/quick-bash-trick-looping-through-output-lines/
    OIFS="${IFS}"
    NIFS=$'\n'
    IFS="${NIFS}"
    #check output for 'failure'
    #exit 1 if any failures
    for line in $result; do
        IFS="${OIFS}"
        if [[ $line == *failure* ]]; then
            IFS="${NIFS}"
            echo "There were failures in health check. Exiting."
            exit 1;
        fi
        IFS="${NIFS}"
    done
fi

#create Objects
