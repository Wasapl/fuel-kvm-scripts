#!/bin/bash -x

#ssh controller

PREFIX=DEMO
NEUTRON=quantum

# create flavor with ephem drive, mem 1GB, rootdisk 1G
nova flavor-create v1.little auto 1024 0 1 --ephemeral 10

# create tenants [admin, testtenant]

if keystone tenant-create --name ${PREFIX}prj --description 'Test project for migration'; then
    tid=$( keystone tenant-get ${PREFIX}prj |awk 'BEGIN{FS="|"}$2~/ id /{gsub(/^[ \t]+|[ \t]+$/, "", $3);print $3;}' )

    #   create couple users 
    for user in u1 u2; do
        keystone user-create --name ${PREFIX}$user --tenant_id $tid --pass PASSWORD 
    done

    OS_TENANT_NAME=${PREFIX}prj
    OS_USERNAME=${PREFIX}u1
    OS_PASSWORD=PASSWORD

    # create routers: [r1, r2]
    for r in R1 R2; do
        $NEUTRON router-create ${PREFIX}$r
    done

    # create networks [net1, net2]
    i=1
    for net in net1 net2; do
        $NEUTRON net-create --tenant-id $tid ${PREFIX}$net 
        # create subnetworks: net1: [subnet1, subnet2] , net2: [subnet3, subnet4]
        for sub in sub1 sub2; do
            snetid=$( $NEUTRON subnet-create --tenant-id $tid demo-net 10.5.$1.0/24 --gateway 10.5.$1.1 --name ${PREFIX}${net}$sub \
                | awk 'BEGIN{FS="|"}$2~/ id /{gsub(/^[ \t]+|[ \t]+$/, "", $3);print $3;}' )
            $NEUTRON router-interface-add ${PREFIX}R1 $snetid
            $NEUTRON router-interface-add ${PREFIX}R2 $snetid
        done
        let 'i = i + 1'
    done


    # create Security groups [SG1, SG2]
    for sg in SG1 SG2; do
        nova secgroup-create ${PREFIX}$sg "${PREFIX} $sg"
        # create rules in each SG: TCP in and out, UDP in and out
        nova secgroup-add-rule ${PREFIX}$sg tcp 443 443 0.0.0.0/0
        nova secgroup-add-rule ${PREFIX}$sg udp 443 443 0.0.0.0/0
    done

    # create 2 keypair
    for kp in KP1 KP2; do
        nova keypair-add ${PREFIX}$kp
    done

    # create instance booted from image with flavor from step 11. shut it off
    nova boot --flavor v1.little --image TestVM --key-name ${PREFIX}KP1 ${PREFIX}-VM
    # create instance booted from volume with flavor from step 11. shut it off
    # create 2 floating IP
    #nova add-floating-ip <server> <address>
fi

# create 2 images
glance image-create --name "Ubuntu 14.04 server-amd64" --disk-format iso --copy-from http://releases.ubuntu.com/14.04/ubuntu-14.04.1-server-amd64.iso --is-public True
# create 2 volumes



