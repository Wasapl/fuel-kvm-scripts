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
env[eceph]="4.1-compute-ceph-eph
4.1-controller-ceph-eph
4.1-compute-ceph-eph-2
4.1-controller-ceph-eph-2"


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
snapshots[4.1-compute-ceph-eph]="clean-install"
snapshots[4.1-controller-ceph-eph]="clean-install"
snapshots[4.1-compute-ceph-eph-2]="clean-install"
snapshots[4.1-controller-ceph-eph-2]="clean-install"
