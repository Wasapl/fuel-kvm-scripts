# This file contains VMs and snapshots names.
# It could be different from host to host


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
4.1-cont-ephem-ceph
4.1-compute-ephem-ceph-2
4.1-cont-ephem-ceph-2"
env[folsom]="compute_nova_volume
controller_nova_volume
compute_nova_volume_ubuntu
controller_nova_volume_ubuntu"


# declaring array with revert snapshots 
declare -A snapshots
#lvm
snapshots[4.1-compute-lvm]="clean-install"
snapshots[4.1-controller-lvm]="clean-install"
snapshots[4.1-compute-lvm-2]="clean-install"
snapshots[4.1-controller-lvm-2]="clean-install"
#ceph
snapshots[4.1-compute-ceph]="clean-install"
snapshots[4.1-controller-ceph]="clean-install"
snapshots[4.1-compute-ceph-2]="clean-install"
snapshots[4.1-controller-ceph-2]="clean-install"
#eceph
snapshots[4.1-compute-ephem-ceph]="clean-install"
snapshots[4.1-cont-ephem-ceph]="clean-install"
snapshots[4.1-compute-ephem-ceph-2]="clean-install"
snapshots[4.1-cont-ephem-ceph-2]="clean-install"
#folsom
snapshots[compute_nova_volume]="clean-install"
snapshots[controller_nova_volume]="clean-install"
snapshots[compute_nova_volume_ubuntu]="clean-install"
snapshots[controller_nova_volume_ubuntu]="clean-install"
