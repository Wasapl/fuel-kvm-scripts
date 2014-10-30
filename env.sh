#!/bin/bash
set +x

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

# declaring array with snapshots 
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
    echo "Usage:
    $0 <Env>"
    exit 1
fi

# Check if $1 contains right Env names.
if [ ! ${env[$1]+abc} ]; then
    echo "there is no such Env as '$1'"
    exit 1
fi
# echo ${env[$1]}


# 1. shutdown all VM (so there is no Envs running on same KVM simultaneously)
# stop only those VM enlisted in envs, so we do not stop something else
running=$(get_vms_running)
# echo $running
for k in ${!env[@]}; do
    # echo ${env[$k]}
    for node in ${env[$k]}; do
        # echo $node
        # stop only those VMs that running
        regexp="^$node$"
        if [[ $running =~ $regexp ]]; then
            echo "virsh stop $node"
            # virsh stop $node
        fi
    done
done


# 2. revert VMs to snapshots with clear deploy.
for node in ${env[$1]}; do
    if [ ! ${snapshots[$node]+abc} ]; then
        echo "Cannot find snapshot for '$node'"
    else
        imgname=`virsh dumpxml fuel-4.1|grep -A4 "<disk type='file' device='disk'>"|grep "<source file='"|cut -d"'" -f 2`
        echo snapshot_revert  $imgname ${snapshots[$node]}
        # snapshot_revert $imgname $snapshotname
    fi
done


# 3. start VMs. wait till it starts normally.
for node in ${env[$1]}; do
    echo start_vm $node
    # start_vm $node
done


# 4. do tests (if any)
echo "do some tests (if any)"


# 5. create snapshots of VMs and make them available as artifacts in Jenkins.
for node in ${env[$1]}; do
    echo snapshot_create $node 

done







