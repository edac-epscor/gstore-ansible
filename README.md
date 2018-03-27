## Standalone GSTORE Deployment

- Expects Ansible 2.4.3.0
- Expects Fully patched Ubuntu 14.04 hosts


__Install Steps__


1. On remote hosts, setup passwordless sudo using ssh keypairs.
    * Set up keypairs for the sudouser you intend to log into the targets with.
    * Grant this user sudo on the remote machines.
    * Allow sudouser to sudo without a passoword. (NOPASSWD:ALL in /etc/sudoers)
2. On local system, edit group_vars/all with the dbnames and passwords , and sudouser of your choosing.

3. On local system edit the "hosts" inventory file by changing the IP addresses to the associated addresses of the target server or servers.


4. From within the repo directory, run this command: 
   >
   > ansible-playbook -i hosts ./gstore.yml
   >


