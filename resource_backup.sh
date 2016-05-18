#!/bin/bash

NOVA=$( mysql nova -Ne 'select "nova quota-update ",resource,hard_limit,project_id from quotas where deleted=0 order by project_id;')
echo "#!/bin/bash" > "/root/scripts/nova_quota.sh"
echo "$NOVA" >> "/root/scripts/nova_quota.sh"

sed -i -e 's/instances/--instances/g' /root/scripts/nova_quota.sh
sed -i -e 's/cores/ --cores/g' /root/scripts/nova_quota.sh
sed -i -e 's/ram/ --ram/g' /root/scripts/nova_quota.sh
sed -i -e 's/floating_ips/ --floating_ips/g' /root/scripts/nova_quota.sh

NEUTRON=$(mysql neutron -Ne 'select "neutron quota-update --flotaing_ips ",`limit`," --tenant_id ",tenant_id from quotas;')
echo "#!/bin/bash" > "/root/scripts/neutron_quota.sh"
echo "$NEUTRON" >> "/root/scripts/neutron_quota.sh"

sed -i -e 's/--flotaing_ips/--floatingip/g' /root/scripts/neutron_quota.sh
