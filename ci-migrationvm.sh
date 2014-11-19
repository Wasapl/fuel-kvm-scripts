#!/bin/bash

source functions/vm.sh

MVM=migartion-vm
MDISK=$(get_vm_disk $MVM)
MSNAPSHOT=1406748150

stop_vm $MVM
snapshot_revert $MDISK $MSNAPSHOT
start_vm $MVM