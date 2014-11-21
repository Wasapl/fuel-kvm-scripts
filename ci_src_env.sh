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

# Check if $SRC_ENV contains right Env names.
if [ ! ${env[${SRC_ENV}-1]+abc} ]; then
    echo "there is no such Env as '$SRC_ENV'"
    exit 1
fi

cleanup_env ${ENV1_NAME}-1 $env
start_env ${ENV1_NAME}-1 $env

#test Env operability

#create Objects
