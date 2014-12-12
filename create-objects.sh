#!/bin/bash -x

#ssh controller

# 1. create tenants [admin, testtenant]
PREFIX=DEMO
if keystone tenant-create --name ${PREFIX}prj --description 'Test project for migration'; then
    tid=$( keystone tenant-get ${PREFIX}prj |awk 'BEGIN{FS="|"}$2~/ id /{gsub(/^[ \t]+|[ \t]+$/, "", $3);print $3;}' )

    #   create couple users 
    for user in u1 u2; do
        keystone user-create --name ${PREFIX}$user --tenant_id $tid --pass PASSWORD 
    done

    OS_TENANT_NAME=${PREFIX}prj
    OS_USERNAME=${PREFIX}u1
    OS_PASSWORD=PASSWORD

    # 4. create routers: [r1, r2]
    for r in R1 R2; do
        quantum router-create ${PREFIX}$r
    done

    # 2. create networks [net1, net2]
    i=1
    for net in net1 net2; do
        quantum net-create --tenant-id $tid ${PREFIX}$net 
        # 3. create subnetworks: net1: [subnet1, subnet2] , net2: [subnet3, subnet4]
        for sub in sub1 sub2; do
            snetid=$( quantum subnet-create --tenant-id $tid demo-net 10.5.$1.0/24 --gateway 10.5.$1.1 --name ${PREFIX}${net}$sub \
                | awk 'BEGIN{FS="|"}$2~/ id /{gsub(/^[ \t]+|[ \t]+$/, "", $3);print $3;}' )
            quantum router-interface-add ${PREFIX}R1 $snetid
            quantum router-interface-add ${PREFIX}R2 $snetid
        done
        let 'i = i + 1'
    done


    # 5. create Security groups [SG1, SG2]
    for sg in SG1 SG2; do
        nova secgroup-create ${PREFIX}$sg "${PREFIX} $sg"
        # 6. create rules in each SG: TCP in and out, UDP in and out
        nova secgroup-add-rule ${PREFIX}$sg tcp 443 443 0.0.0.0/0
        nova secgroup-add-rule ${PREFIX}$sg udp 443 443 0.0.0.0/0
    done

    # 10. create 2 keypair
    for kp in KP1 KP2; do
        nova keypair-add ${PREFIX}$kp
    done


fi

# 8. create 2 images
glance image-create --name "Ubuntu 14.04 server-amd64" --disk-format iso --copy-from http://releases.ubuntu.com/14.04/ubuntu-14.04.1-server-amd64.iso --is-public True
# 9. create 2 volumes

# 11. create flavor with ephem drive, mem 1GB, rootdisk 1G
nova flavor-create v1.little auto 1024 0 1 --ephemeral 10 
# 12. create instance booted from image with flavor from step 11. shut it off
# 13. create instance booted from volume with flavor from step 11. shut it off
# 7. create 2 floating IP
#nova add-floating-ip <server> <address>