#!/bin/bash

ssh controller

# 1. create tenants [admin, testtenant]
keystone tenant-create --name new-project --description 'my new project'
#   create couple users 
keystone user-create --name new-user --tenant_id 1a4a0618b306462c9830f876b0bd6af2 --pass PASSWORD 
# 2. create networks [net1, net2]
neutron net-create --tenant-id DEMO_TENANT_ID demo-net SPECIAL_OPTIONS
# 3. create subnetworks: net1: [subnet1, subnet2] , net2: [subnet3, subnet4]
neutron subnet-create --tenant-id DEMO_TENANT_ID demo-net 10.5.5.0/24 --gateway 10.5.5.1
# 4. create routers: [r1, r2]
neutron router-create R1
neutron router-interface-add EXT_TO_INT_ID DEMO_NET_SUBNET_ID
# 5. create Security groups [SG1, SG2]
nova secgroup-create SG1 "SG1"
# 6. create rules in each SG: TCP in and out, UDP in and out
nova secgroup-add-rule SG1 tcp 443 443 0.0.0.0/0
nova secgroup-add-rule SG1 udp 443 443 0.0.0.0/0
# 7. create 2 floating IP
nova add-floating-ip <server> <address>
# 8. create 2 images
glance
# 9. create 2 volumes

# 10. create 2 keypair

# 11. create flavor with ephem drive, mem 1GB, rootdisk 1G
nova flavor-create FLAVOR_NAME FLAVOR_ID RAM_IN_MB ROOT_DISK_IN_GB NUMBER_OF_VCPUS
# 12. create instance booted from image with flavor from step 11. shut it off
# 13. create instance booted from volume with flavor from step 11. shut it off
