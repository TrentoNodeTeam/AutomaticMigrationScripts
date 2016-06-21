#!/bin/bash
######

# extract keypair from DB
# create the file
# create the commands to upload the keypairs on the new node
# create the query to associate the keypair to the user

KP_CMD=/root/scripts/keypairs/create_keypairs_from_backup.sh
KP_LIST=/tmp/KP_LIST.txt
KP=$( mysql nova -Ne 'select id from key_pairs where deleted=0 ;')
KP_OWNER=/root/scripts/keypairs/query_update_owner_kp.sh


echo "$KP" > "/tmp/KP_LIST.txt"
sed -i -e 's/- //g' /tmp/KP_LIST.txt
echo "#!/bin/bash" > $KP_CMD
echo "#!/bin/bash" > $KP_OWNER

for id  in `cat $KP_LIST`;
do
name=$( mysql nova -Ne 'select name from key_pairs where deleted=0 and id='"$id"';')
key=$( mysql nova -Ne 'select public_key from key_pairs where deleted=0 and id='"$id"';')
echo "$key" > /root/scripts/keypairs/$name
echo "nova keypair-add --pub-key "$name" "$name >> $KP_CMD
user_id=$( mysql nova -Ne 'select user_id from key_pairs where deleted=0 and id='"$id"';')
echo $user_id" "$name" " $id
echo "mysql nova -Ne 'update key_pairs set user_id =\""$user_id"\" where name=\""$name"\";'" >> $KP_OWNER
done

echo "sh query_update_owner_kp.sh" >> $KP_CMD
scp -i /root/key_cmpt /root/scripts/keypairs/* root@<IP_NEW_NODE>:/root/scripts/keypairs/
