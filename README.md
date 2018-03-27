## Standalone GSTORE Deployment

- Expects Ansible 2.4.3.0
- Expects Fully patched Ubuntu 14.04 hosts


__Install Steps__


1. Setup passwordless sudo using ssh keypairs for the hosts you wish to install on.
    * Set up keypairs for the user you intend to log into the targets with.
    * Grant this user sudo on the remote machines.
    * Allow user to sudo without a passoword. (NOPASSWD:ALL in /etc/sudoers)
2. Edit group_vars/all with the dbnames and passwords of your choosing.

3. Edit the "hosts" inventory file by changing the IP addresses to the associated addresses of the target server or servers.


3. From within the repo directory, run this command: 

   > ./ansible-playbook -i hosts gstore.yml



