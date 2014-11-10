#!/bin/bash
# set +x

source functions/vm.sh
source functions/env.sh
source functions/snapshot.sh

# declaring array with environments
declare -A env
env[lvm]="4.1-compute-lvm
4.1-controller-lvm
4.1-compute-lvm-2
4.1-controller-lvm-2"
env[ceph]="4.1-compute-ceph
4.1-controller-ceph
4.1-compute-ceph-2
4.1-controller-ceph-2"
env[eceph]="4.1-compute-ephem-ceph
4.1-controller-ephem-ceph
4.1-compute-ephem-ceph-2
4.1-controller-ephem-ceph-2"
env[folsom]="compute_nova_volume
controller_nova_volume
compute_nova_volume_ubuntu
controller_nova_volume_ubuntu"
env[ih-lvm]="5.1-compute-lvm-1
5.1-controller-lvm-1
5.1-compute-lvm-2
5.1-controller-lvm-2"


# declaring array with revert snapshots 
declare -A snapshots
snapshots[4.1-compute-lvm]="snap-4.1-compute-lvm"
snapshots[4.1-controller-lvm]="snap-4.1-controller-lvm"
snapshots[4.1-compute-lvm-2]="snap-4.1-compute-lvm-2"
snapshots[4.1-controller-lvm-2]="snap-4.1-controller-lvm-2"
snapshots[4.1-compute-ceph]="snap-4.1-compute-ceph"
snapshots[4.1-controller-ceph]="snap-4.1-controller-ceph"
snapshots[4.1-compute-ceph-2]="snap-4.1-compute-ceph-2"
snapshots[4.1-controller-ceph-2]="snap-4.1-controller-ceph-2"
snapshots[4.1-compute-ephem-ceph]="snap-4.1-compute-ephem-ceph"
snapshots[4.1-controller-ephem-ceph]="snap-4.1-controller-ephem-ceph"
snapshots[4.1-compute-ephem-ceph-2]="snap-4.1-compute-ephem-ceph-2"
snapshots[4.1-controller-ephem-ceph-2]="snap-4.1-controller-ephem-ceph-2"
snapshots[compute_nova_volume]="snap-compute_nova_volume"
snapshots[controller_nova_volume]="snap-controller_nova_volume"
snapshots[compute_nova_volume_ubuntu]="snap-compute_nova_volume_ubuntu"
snapshots[controller_nova_volume_ubuntu]="snap-controller_nova_volume_ubuntu"

# Check if $1 is given
if [ -z $1 ]; then
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

# Check if $1 contains right Env names.
if [ ! ${env[$1]+abc} ]; then
    echo "there is no such Env as '$1'"
    exit 1
fi

# 1. shutdown all VM (so there is no Envs running on same KVM simultaneously)
stop_all_env $env

# 2. revert VMs to snapshots with clear deploy.
cleanup_env $1 $env


# 3. start VMs. wait till it starts normally.
start_env $1 $env

# 4. do tests (if any)
echo "do some tests (if any)"

# 5. create snapshots of VMs so we could make them available as artifacts in Jenkins.
make_snapshots_env $1 $env "trololo`date +%F-%H-%M-%S`"
