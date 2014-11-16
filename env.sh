#!/bin/bash
# set +x

source functions/vm.sh
source functions/env.sh
source functions/snapshot.sh

arrays=./$(hostname)-vms.sh
if [ ! -f $arrays ]; then
  echo "There is no array declarations for host '$(hostname)'"
  echo "Please provide it in file '$arrays'"
  exit 1
fi
source ./$(hostname)-vms.sh


#creating list of all known envs
env_names=""
for K in "${!env[@]}"; do
    if [ -z "$env_names" ]; then env_names=$K;
    else env_names="$env_names | $K";
    fi;
done

ENV1_NAME=$1
ENV2_NAME=$2

# Check if $ENV1_NAME and $ENV2_NAME is given
if [ -z $ENV1_NAME  || -z $ENV2_NAME ]; then
    echo "Usage:
    $0 dest_env source_env"
    exit 1
fi

# Check if $ENV1_NAME contains right Env names.
if [ ! ${env[${ENV1_NAME}-1]+abc} ]; then
    echo "there is no such Env as '$ENV1_NAME'"
    exit 1
fi

# Check if $ENV2_NAME contains right Env names.
if [ ! ${env[${ENV2_NAME}-2]+abc} ]; then
    echo "there is no such Env as '$ENV2_NAME'"
    exit 1
fi

# 1. shutdown all VM (so there is no Envs running on same KVM simultaneously)
stop_all_env $env

# 2. revert VMs to snapshots with clear deploy.
cleanup_env ${ENV1_NAME}-1 $env
cleanup_env ${ENV2_NAME}-2 $env

# 3. start VMs. wait till it starts normally.
start_env ${ENV1_NAME}-1 $env
start_env ${ENV2_NAME}-2 $env

# 4. do tests (if any)
echo "do some tests (if any)"

# 5. create snapshots of VMs so we could make them available as artifacts in Jenkins.
make_snapshots_env ${ENV1_NAME}-1 "trololo`date +%F-%H-%M-%S`" $env
make_snapshots_env ${ENV1_NAME}-2 "trololo`date +%F-%H-%M-%S`" $env

