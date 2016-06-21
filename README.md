# AutomaticMigrationScripts v1.0
Created by TrentoNodeTeam (Trentino Network Srl)

It's important to create a keypair shared from the OLD node and the NEW node.

##create_backup_all_vm.sh
This script do the following steps :
- clean all previous old snapshot made with the migration scripts
- create the snapshots of all VMs
- download all snapshots
- upload the snapshots to the new node

The snapshots could be filtered by compute hust adding --host nodeXX.domain.tld in the command nova list --all-tenants

##create_image_from_backup.sh
Run this script in order to create the script to upload all the snapshots moved on the new node.
The scirpt have to be copied on the new node and run on it


##keypair_backup.sh
Create 2 scripts that can be found on the new node. It's enough to run the script "create_keypairs_from_backup.sh" and all the keypairs will be uploaded and associated to the users


##resource_backup.sh
Create 2 scripts that have to be copied and run on the NEW node . The quota will be restored on the new node as previously configured in the "old" node.
