## Standalone GSTORE Deployment

- Expects Ansible 2.4.3.0
- Expects Ubuntu 14.04 hosts

Ensure you have ssh keypair auth setup with the host\hosts you wish to install on.

Edit group_vars/all with the dbnames and passwords of your choosing.



##Multi Server###
Edit the "hosts" inventory file by changing the IP addresses to the assicated addresses of the target servers.


Run the following:
ansible-playbook -i hosts gstore.yml



