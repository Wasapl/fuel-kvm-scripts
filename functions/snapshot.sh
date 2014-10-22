#1/bin/bash
set -x

# This file contains the functions to manage VMs images through Qemu-img

QEMUIMG=/usr/bin/qemu-img
PATH_IMG=/home/kvm/

snapshot_list() {
    imgname=$1
}

snapshot_revert () {
    vmname=$1
    imgname=$2
    snapshotname=$3
}

snapshot_create () {
    vmname=$1
    imgname=$2
}

