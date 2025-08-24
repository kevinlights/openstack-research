ocp endpoint list
# +----------------------------------+------------+--------------+--------------+---------+-----------+------------------------------------------+
# | ID                               | Region     | Service Name | Service Type | Enabled | Interface | URL                                      |
# +----------------------------------+------------+--------------+--------------+---------+-----------+------------------------------------------+
# | 19837ae2ae3e44e894358ae174ff2475 | microstack | nova         | compute      | True    | public    | https://10.0.2.15:8774/v2.1              |
# | 1a6359a948d2495b953bec603b13b2ce | microstack | nova         | compute      | True    | internal  | https://10.0.2.15:8774/v2.1              |
# | 2691b95b7eb94a33b0a3134269b17030 | microstack | glance       | image        | True    | public    | https://10.0.2.15:9292                   |
# | 3c5eb59b508647a88f86ff9353987024 | microstack | keystone     | identity     | True    | internal  | https://10.0.2.15:5000/v3/               |
# | 41eac0ba733048faab5a5d1ada17107c | microstack | cinderv2     | volumev2     | True    | internal  | https://10.0.2.15:8776/v2/$(project_id)s |
# | 47de5f7f868e4e638114aac8bdf3d8ba | microstack | neutron      | network      | True    | admin     | https://10.0.2.15:9696                   |
# | 49ca4c42edb74bc495566e36b27366a5 | microstack | neutron      | network      | True    | internal  | https://10.0.2.15:9696                   |
# | 4f2b4ea3db994172a633ae9caa82763b | microstack | neutron      | network      | True    | public    | https://10.0.2.15:9696                   |
# | 77c574ae8fbd4851ad229814b0d1be64 | microstack | placement    | placement    | True    | internal  | https://10.0.2.15:8778                   |
# | 930676cae034450d9282c700caaf11bb | microstack | cinderv2     | volumev2     | True    | admin     | https://10.0.2.15:8776/v2/$(project_id)s |
# | 9a4c057d2bec40b8ae52e6f79d3ccb6a | microstack | cinderv2     | volumev2     | True    | public    | https://10.0.2.15:8776/v2/$(project_id)s |
# | ae15ced7c16440e9ba93dee7665b9f04 | microstack | cinderv3     | volumev3     | True    | internal  | https://10.0.2.15:8776/v3/$(project_id)s |
# | b85ac0a0341847bf85f659865a34f1b2 | microstack | nova         | compute      | True    | admin     | https://10.0.2.15:8774/v2.1              |
# | ba54a9e066d341d08a4a659c07974b6c | microstack | glance       | image        | True    | admin     | https://10.0.2.15:9292                   |
# | bfaef5a5c087417f9eeee4bb97bf61a1 | microstack | keystone     | identity     | True    | public    | https://10.0.2.15:5000/v3/               |
# | cfa51318d1fa4b79a043fc1e0cf8ad1e | microstack | placement    | placement    | True    | admin     | https://10.0.2.15:8778                   |
# | d75764afb4ca4aa2815f000a45d693f2 | microstack | cinderv3     | volumev3     | True    | admin     | https://10.0.2.15:8776/v3/$(project_id)s |
# | dad08949971d41779bea071868449c7a | microstack | glance       | image        | True    | internal  | https://10.0.2.15:9292                   |
# | dad268842a5440da8b11982e413d83ba | microstack | cinderv3     | volumev3     | True    | public    | https://10.0.2.15:8776/v3/$(project_id)s |
# | f528926819674ee28c3ea7fa2fed0fc4 | microstack | keystone     | identity     | True    | admin     | https://10.0.2.15:5000/v3/               |
# | fbf6948ce58b41e99d6542c420e61a65 | microstack | placement    | placement    | True    | public    | https://10.0.2.15:8778                   |
# +----------------------------------+------------+--------------+--------------+---------+-----------+------------------------------------------+

# cat <<EOF | sudo tee -a /etc/hosts
# 127.0.0.1 ubuntu.myguest.virtualbox.org
# 10.0.2.15 ubuntu.myguest.virtualbox.org
# 192.168.56.108 ubuntu.myguest.virtualbox.org
# EOF
cat /etc/hosts


# ubuntu.myguest.virtualbox.org

openstack endpoint list | awk '/10.0.2.15/ {print $2}' | while read endpoint_id; do
    old_url=$(openstack endpoint show "$endpoint_id" -f value -c url)
    new_url=$(echo "$old_url" | sed 's/10.0.2.15/ubuntu.myguest.virtualbox.org/')
    echo "openstack endpoint set --url '$new_url' '$endpoint_id'" 2>&1 | tee -a update.sh
done


openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:8774/v2.1' '19837ae2ae3e44e894358ae174ff2475'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:8774/v2.1' '1a6359a948d2495b953bec603b13b2ce'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:9292' '2691b95b7eb94a33b0a3134269b17030'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:5000/v3/' '3c5eb59b508647a88f86ff9353987024'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:8776/v2/$(project_id)s' '41eac0ba733048faab5a5d1ada17107c'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:9696' '47de5f7f868e4e638114aac8bdf3d8ba'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:9696' '49ca4c42edb74bc495566e36b27366a5'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:9696' '4f2b4ea3db994172a633ae9caa82763b'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:8778' '77c574ae8fbd4851ad229814b0d1be64'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:8776/v2/$(project_id)s' '930676cae034450d9282c700caaf11bb'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:8776/v2/$(project_id)s' '9a4c057d2bec40b8ae52e6f79d3ccb6a'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:8776/v3/$(project_id)s' 'ae15ced7c16440e9ba93dee7665b9f04'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:8774/v2.1' 'b85ac0a0341847bf85f659865a34f1b2'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:9292' 'ba54a9e066d341d08a4a659c07974b6c'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:5000/v3/' 'bfaef5a5c087417f9eeee4bb97bf61a1'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:8778' 'cfa51318d1fa4b79a043fc1e0cf8ad1e'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:8776/v3/$(project_id)s' 'd75764afb4ca4aa2815f000a45d693f2'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:9292' 'dad08949971d41779bea071868449c7a'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:8776/v3/$(project_id)s' 'dad268842a5440da8b11982e413d83ba'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:5000/v3/' 'f528926819674ee28c3ea7fa2fed0fc4'
openstack endpoint set --url 'https://ubuntu.myguest.virtualbox.org:8778' 'fbf6948ce58b41e99d6542c420e61a65'


openstack endpoint list

# +----------------------------------+------------+--------------+--------------+---------+-----------+--------------------------------------------------------------+
# | ID                               | Region     | Service Name | Service Type | Enabled | Interface | URL                                                          |
# +----------------------------------+------------+--------------+--------------+---------+-----------+--------------------------------------------------------------+
# | 19837ae2ae3e44e894358ae174ff2475 | microstack | nova         | compute      | True    | public    | https://ubuntu.myguest.virtualbox.org:8774/v2.1              |
# | 1a6359a948d2495b953bec603b13b2ce | microstack | nova         | compute      | True    | internal  | https://ubuntu.myguest.virtualbox.org:8774/v2.1              |
# | 2691b95b7eb94a33b0a3134269b17030 | microstack | glance       | image        | True    | public    | https://ubuntu.myguest.virtualbox.org:9292                   |
# | 3c5eb59b508647a88f86ff9353987024 | microstack | keystone     | identity     | True    | internal  | https://ubuntu.myguest.virtualbox.org:5000/v3/               |
# | 41eac0ba733048faab5a5d1ada17107c | microstack | cinderv2     | volumev2     | True    | internal  | https://ubuntu.myguest.virtualbox.org:8776/v2/$(project_id)s |
# | 47de5f7f868e4e638114aac8bdf3d8ba | microstack | neutron      | network      | True    | admin     | https://ubuntu.myguest.virtualbox.org:9696                   |
# | 49ca4c42edb74bc495566e36b27366a5 | microstack | neutron      | network      | True    | internal  | https://ubuntu.myguest.virtualbox.org:9696                   |
# | 4f2b4ea3db994172a633ae9caa82763b | microstack | neutron      | network      | True    | public    | https://ubuntu.myguest.virtualbox.org:9696                   |
# | 77c574ae8fbd4851ad229814b0d1be64 | microstack | placement    | placement    | True    | internal  | https://ubuntu.myguest.virtualbox.org:8778                   |
# | 930676cae034450d9282c700caaf11bb | microstack | cinderv2     | volumev2     | True    | admin     | https://ubuntu.myguest.virtualbox.org:8776/v2/$(project_id)s |
# | 9a4c057d2bec40b8ae52e6f79d3ccb6a | microstack | cinderv2     | volumev2     | True    | public    | https://ubuntu.myguest.virtualbox.org:8776/v2/$(project_id)s |
# | ae15ced7c16440e9ba93dee7665b9f04 | microstack | cinderv3     | volumev3     | True    | internal  | https://ubuntu.myguest.virtualbox.org:8776/v3/$(project_id)s |
# | b85ac0a0341847bf85f659865a34f1b2 | microstack | nova         | compute      | True    | admin     | https://ubuntu.myguest.virtualbox.org:8774/v2.1              |
# | ba54a9e066d341d08a4a659c07974b6c | microstack | glance       | image        | True    | admin     | https://ubuntu.myguest.virtualbox.org:9292                   |
# | bfaef5a5c087417f9eeee4bb97bf61a1 | microstack | keystone     | identity     | True    | public    | https://ubuntu.myguest.virtualbox.org:5000/v3/               |
# | cfa51318d1fa4b79a043fc1e0cf8ad1e | microstack | placement    | placement    | True    | admin     | https://ubuntu.myguest.virtualbox.org:8778                   |
# | d75764afb4ca4aa2815f000a45d693f2 | microstack | cinderv3     | volumev3     | True    | admin     | https://ubuntu.myguest.virtualbox.org:8776/v3/$(project_id)s |
# | dad08949971d41779bea071868449c7a | microstack | glance       | image        | True    | internal  | https://ubuntu.myguest.virtualbox.org:9292                   |
# | dad268842a5440da8b11982e413d83ba | microstack | cinderv3     | volumev3     | True    | public    | https://ubuntu.myguest.virtualbox.org:8776/v3/$(project_id)s |
# | f528926819674ee28c3ea7fa2fed0fc4 | microstack | keystone     | identity     | True    | admin     | https://ubuntu.myguest.virtualbox.org:5000/v3/               |
# | fbf6948ce58b41e99d6542c420e61a65 | microstack | placement    | placement    | True    | public    | https://ubuntu.myguest.virtualbox.org:8778                   |
# +----------------------------------+------------+--------------+--------------+---------+-----------+--------------------------------------------------------------+



