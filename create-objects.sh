#!/bin/bash

#ssh controller

# 1. create tenants [admin, testtenant]
tname=testproject
if keystone tenant-create --name $tname --description 'Test project for migration'; then
    tid=$( keystone tenant-get $tname |awk 'BEGIN{FS="|"}$2~/ id /{gsub(/^[ \t]+|[ \t]+$/, "", $3);print $3;}' )

    #   create couple users 
    for user in user1 user2; do
        keystone user-create --name $user --tenant_id $tid --pass PASSWORD 
    done

    # 4. create routers: [r1, r2]
    for r in R1 R2; do
        neutron router-create $r
    done

    # 2. create networks [net1, net2]
    i=1
    for net in net1 net2; do
        neutron net-create --tenant-id $tid $net 
        # 3. create subnetworks: net1: [subnet1, subnet2] , net2: [subnet3, subnet4]
        for sub in subnet1 subnet2; do
            snetid=$( neutron subnet-create --tenant-id $tid demo-net 10.5.$1.0/24 --gateway 10.5.$1.1 --name ${net}subnet1 \
                | awk 'BEGIN{FS="|"}$2~/ id /{gsub(/^[ \t]+|[ \t]+$/, "", $3);print $3;}' )
            neutron router-interface-add R1 $snetid
            neutron router-interface-add R2 $snetid
        done
        let 'i = i + 1'
    done
fi


# 5. create Security groups [SG1, SG2]
for sg in SG1 SG2; do
    nova secgroup-create $sg "$sg"
done
# 6. create rules in each SG: TCP in and out, UDP in and out
nova secgroup-add-rule SG1 tcp 443 443 0.0.0.0/0
nova secgroup-add-rule SG1 udp 443 443 0.0.0.0/0


# 7. create 2 floating IP
nova add-floating-ip <server> <address>
# 8. create 2 images
glance
# 9. create 2 volumes

# 10. create 2 keypair
for kp in KP1 KP2; do
    nova keypair-add $kp
done

# 11. create flavor with ephem drive, mem 1GB, rootdisk 1G
nova flavor-create v1.medium_small auto 1024 0 1 --ephemeral 10 
# 12. create instance booted from image with flavor from step 11. shut it off
# 13. create instance booted from volume with flavor from step 11. shut it off
