#!/bin/bash
# set +x

source functions/vm.sh
source functions/env.sh
source functions/snapshot.sh
source vms.sh

ENV_NAME=$1

# Check if $ENV_NAME is given
if [ -z $ENV_NAME ]; then
    env_names=""
    for K in "${!env[@]}"; do
        if [ -z "$env_names" ]; then env_names=$K;
        else env_names="$env_names | $K";
        fi;
    done
    echo "Usage:
    $0 [ $env_names ]"
    exit 1
fi

# Check if $ENV_NAME contains right Env names.
if [ ! ${env[$ENV_NAME]+abc} ]; then
    echo "there is no such Env as '$ENV_NAME'"
    exit 1
fi

# 1. shutdown all VM (so there is no Envs running on same KVM simultaneously)
stop_all_env $env

# 2. revert VMs to snapshots with clear deploy.
cleanup_env $ENV_NAME $env

# 3. start VMs. wait till it starts normally.
start_env $ENV_NAME $env

# 4. do tests (if any)
echo "do some tests (if any)"

# 5. create snapshots of VMs so we could make them available as artifacts in Jenkins.
make_snapshots_env $ENV_NAME "trololo`date +%F-%H-%M-%S`" $env
