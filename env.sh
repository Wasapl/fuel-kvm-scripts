#!/bin/bash
# set +x

source functions/vm.sh
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

stop_env(){
    env_name=$1
    for node in ${env[$env_name]}; do
        echo stop_vm $node
        # stop_vm $node
    done
}

stop_all_env(){
    # stop only those VM enlisted in envs, so we do not stop something else
    running=$(get_vms_running)
    # echo "all running: $running"
    # echo
    for k in ${!env[@]}; do
        # echo ${env[$k]}
        for node in ${env[$k]}; do
            # stop only those VMs that running
            if [[ $running = *$node* ]]; then
                echo "virsh stop $node"
                # virsh stop $node
            fi
        done
    done
}

start_env(){
    env_name=$1
    for node in ${env[env_name]}; do
        echo start_vm $node
    done
    #TODO Should poke some api's to make shure it's working
}

cleanup_env(){
    env_name=$1

    for node in ${env[$env_name]}; do
        if [ ! ${snapshots[$node]+abc} ]; then
            echo "Don't know revert snapshot for '$node'"
        else
            imgname=$(get_vm_disk $node)
            echo snapshot_revert $imgname ${snapshots[$node]}
        fi
    done
}

make_snapshots_env() {
    env_name=$1
    snapshot_name=$2
    for node in ${env[$env_name]}; do
        imgname=$(get_vm_disk $node)
        echo snapshot_create $imgname $snapshot_name
    done
}

# 1. shutdown all VM (so there is no Envs running on same KVM simultaneously)
stop_all_env

# 2. revert VMs to snapshots with clear deploy.
cleanup_env $1


# 3. start VMs. wait till it starts normally.
start_env $1

# 4. do tests (if any)
echo "do some tests (if any)"

# 5. create snapshots of VMs so we could make them available as artifacts in Jenkins.
make_snapshots_env $1 "trololo`date +%F-%H-%M-%S`"
