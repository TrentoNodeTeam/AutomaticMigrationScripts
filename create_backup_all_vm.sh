#!/bin/bash

VM_FILE=/tmp/vm_file.txt
IMAGE_FILE=/tmp/image_file.txt


# Get the list of all VMs and keep IDs in a file
list_vms() {
   nova list --all-tenants |  egrep -v "(+------|\| ID)" | \
   igawk -F '|' '
   @include trims.awk
   {print trim($2)}' > $VM_FILE
   VM_NR="$(nova list --all-tenants | wc -l)"
   echo "NUMBER OF VM FOUND :  $VM_NR "
}

#list images and delete
list_images() {
   nova image-list |  grep "snapshot-" | egrep -v "(+------|\| ID)" | \
   igawk -F '|' '
   @include trims.awk
   {print trim($2)}' > $IMAGE_FILE
   IMAGE_NR="$(nova image-list |  grep "snapshot-" | wc -l)"
   echo "OLD IMAGES FOUND :  $IMAGE_NR "
}


list_vms
list_images

################
#### MAIN  #####
#remove old snapshot in order to avoid duplicated
for image in `cat $IMAGE_FILE`;
do nova image-delete $image
nova image-list | grep snapshot- | wc -l
done

# for every VM in the vm_file
for vm in `cat $VM_FILE`;
do nova image-create --show --poll $vm snapshot-$vm
glance image-download --file /var/lib/glance/image4migration/snapshot-$vm.qcow snapshot-$vm --progress
rsync -avz -e "ssh -i /root/key_cmpt" /var/lib/glance/image4migration/snapshot-$vm.qcow root@<IP_NEW_NODE>:/var/lib/glance/imagesFromICE/
rm /var/lib/glance/image4migration/snapshot-$vm.qcow
done
