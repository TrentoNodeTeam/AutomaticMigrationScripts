# AutomaticMigrationScripts

#create_backup_all_vm.sh
This script do the follow step :
- clean all old snapshot made with the migration scripts
- create the snapshots of all VMs
- download all snapshots
- upload the snapshots to the new node

It's important to create a keypair shared from the OLD node and the NEW node in order to send the snapshots.
The snapshots could be filtered by compute hust adding --host nodeXX.domain.tld in the command nova list --all-tenants
