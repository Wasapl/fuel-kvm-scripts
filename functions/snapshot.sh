#1/bin/bash
# set -x

# This file contains the functions to manage VMs images through Qemu-img

snapshot_list() {
    imgname=$1
    echo `qemu-img snapshot -l $imgname|awk 'NR>2{print $2}'`
}

snapshot_list_id() {
    imgname=$1
    echo `qemu-img snapshot -l $imgname|awk 'NR>2{print $1}'`
}

snapshot_revert () {
    imgname=$1
    snapshotname=$2
    qemu-img snapshot -a $snapshotname $imgname
}

snapshot_create () {
    imgname=$2
    snapshotname=$2
    qemu-img snapshot -c $snapshotname $imgname
}


snapshot_delete () {
    imgname=$2
    snapshotname=$2
    qemu-img snapshot -d $snapshotname $imgname
}
