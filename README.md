## Standalone GSTORE Deployment

- Expects Ansible 2.4.3.0
- Expects Fully patched Ubuntu 14.04 hosts


__Install Steps__


1. Ensure you have ssh keypair auth setup with the host\hosts you wish to install on.

2. Edit group_vars/all with the dbnames and passwords of your choosing.

3. Edit the "hosts" inventory file by changing the IP addresses to the associated addresses of the target server or servers.


3. From within the repo directory, run this command: 

   > ./ansible-playbook -i hosts gstore.yml



