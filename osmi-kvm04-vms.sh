# This file contains VMs and snapshots names.
# It could be different from host to host


# declaring array with environments
declare -A env
env[lvm-1]="4.1-compute-lvm
4.1-controller-lvm"
env[lvm-2]="4.1-compute-lvm-2
4.1-controller-lvm-2"

env[lvmnovanet-1]="4.1-compute-lvm-novanet
4.1-controller-lvm-novanet"
env[lvmnovanet-2]="4.1-compute-lvm-novanet-vlan
4.1-controller-lvm-novanet-vlan"

env[ceph-1]="4.1-compute-ceph
4.1-controller-ceph"
env[ceph-2]="4.1-compute-ceph-2
4.1-controller-ceph-2"

env[eceph-1]="4.1-compute-ceph-ephem
4.1-controller-ceph-ephem"
env[eceph-2]="4.1-compute-ceph-ephem-2
4.1-controller-ceph-ephem-2"



# declaring array with revert snapshots 
declare -A snapshots
#lvm
snapshots[4.1-compute-lvm]="clean-install"
snapshots[4.1-controller-lvm]="clean-install"
snapshots[4.1-compute-lvm-2]="clean-install"
snapshots[4.1-controller-lvm-2]="clean-install"
#lvmnovanet
snapshots[4.1-compute-lvm-novanet]="clean-install"
snapshots[4.1-controller-lvm-novanet]="clean-install"
snapshots[4.1-compute-lvm-novanet-vlan]="clean-install"
snapshots[4.1-controller-lvm-novanet-vlan]="clean-install"
#ceph
snapshots[4.1-compute-ceph]="clean-install"
snapshots[4.1-controller-ceph]="clean-install"
snapshots[4.1-compute-ceph-2]="clean-install"
snapshots[4.1-controller-ceph-2]="clean-install"
#eceph
snapshots[4.1-compute-ceph-ephem]="clean-install"
snapshots[4.1-controller-ceph-ephem]="clean-install"
snapshots[4.1-compute-ceph-ephem-2]="clean-install"
snapshots[4.1-controller-ceph-ephem-2]="clean-install"
