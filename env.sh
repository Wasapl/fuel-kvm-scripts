#!/bin/bash
set -x


source functions/vm.sh

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

# echo ${env[$1]}

# 1. shutdown all VM (so there is no Envs running on same KVM simultaneously)
# stop only those VM enlisted in envs, so we do not stop something else
running=$(get_vms_running)
echo running
for k in ${!env[@]}; do
    # echo ${env[$k]}
    for node in ${env[$k]}; do
        echo $node
        # stop only those VMs that running
        if [[ $running ~= "^$node$" ]]; then
            echo "virsh stop $node"
            # virsh stop $node
        fi
    done
done

# 2. revert VMs to snapshots with clear deploy.



# 3. start VMs. wait till it starts normally.

# 4. do tests (if any)

# 5. create snapshots of VMs and make them available as artifacts in Jenkins.
