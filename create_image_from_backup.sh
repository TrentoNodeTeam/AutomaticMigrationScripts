#!/bin/bash


LOG=/tmp/log.txt
VM_FILE=/tmp/vm_file_4images.txt
TENANT_FILE=/root/scripts/CMD_image_create_from_backup_file.sh

echo "#!/bin/bash" > $TENANT_FILE

# for every VM in the vm_file
for vm in `cat $VM_FILE`;
do
TENANT_ID=`nova show $vm | grep tenant_id  | \
   igawk -F '|' '
   @include trims.awk
   END {print trim($3)}'` #> $TENANT_ID

VM_NAME=`nova show $vm | grep '| name'  | \
  igawk -F '|' '
  @include trims.awk
  {print trim($3)}'`

#echo $TENANT_ID $VM_NAME
echo "glance image-create --name $VM_NAME --disk-format=qcow2 --container-format=bare --file snapshot-$vm.qcow  --is-public false --owner $TENANT_ID"  >> $TENANT_FILE "--progress"


done
