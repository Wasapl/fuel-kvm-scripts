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

ENV_NAME=${1-${SRC_ENV}}
ENV_NAME=${ENV_NAME}-1

# Check if $ENV_NAME contains right Env names.
if [ ! ${env[$ENV_NAME]+abc} ]; then
    echo "there is no such Env as '$ENV_NAME'"
    exit 1
fi

cleanup_env $ENV_NAME $env
start_env $ENV_NAME $env

echo "sleep for 4 minutes in order to let Env spawn up before testing it"
sleep 240

#test Env operability
if [ ! ${fuel[$ENV_NAME]+abc} ]; then
    echo "There is no fuel node for this Env. Skip test Env operability."
else
    read fuelhost envid <<< "${fuel[$ENV_NAME]}"
    source poke-ostf.sh $fuelhost $envid
fi


