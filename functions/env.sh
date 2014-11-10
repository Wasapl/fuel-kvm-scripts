#!/bin/bash
# set -x

# This file contains the functions to manage Environments

stop_env(){
    env_name=$1
    for node in ${env[$env_name]}; do
        echo "Stopping VM $node"
        stop_vm $node
    done
}

stop_all_env(){
    # stop only those VM enlisted in envs, so we do not stop something else
    echo "Stopping all VMs..."
    running=$(get_vms_running)
    # echo "all running: $running"
    for k in ${!env[@]}; do
        # echo ${env[$k]}
        for node in ${env[$k]}; do
            # stop only those VMs that running
            if [[ $running = *$node* ]]; then
                echo "Stopping VM $node"
                virsh stop $node
            fi
        done
    done
}

start_env(){
    env_name=$1
    env=$2
    echo "Starting env '$env_name'..."
    for node in ${env[env_name]}; do
        echo "Starting VM $node..."
        start_vm $node
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
            echo "Reverting '${snapshots[$node]}' snapshot for '$imgname'..."
            snapshot_revert $imgname ${snapshots[$node]}
        fi
    done
}

make_snapshots_env() {
    env_name=$1
    snapshot_name=$2
    for node in ${env[$env_name]}; do
        imgname=$(get_vm_disk $node)
        echo "Creating snapshot for '$imgname'..."
        snapshot_create $imgname $snapshot_name
    done
}
