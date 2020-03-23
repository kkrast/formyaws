Set of selected Ansible playbooks, used to automate some manipulations on AWS Linux instances

Main goals achieved with the below published group of playbooks:

1. Change the old nv-xyz SSH authorization key inside the .ssh/authorized_keys file on every EC2 Linux instance. This goal is reached by these main sub-steps, each one implemented within separate playbook:
1.1. _check_for_authorized_key.yml: determine which instances have only one ssh key (namedly - only the nv-xyz key, which to exchange with the xyz-sofia key), and also the instances having more than one authorized key, in order to be checked manually for keys that are not needed any more
1.2. _add_authorized_key.yml: add the new SSH public key for xyz-sofia into the authorized_keys files on AWS instances
1.3. _del_authorized_key.yml: delete the old nv_xyz SSH public key inside the authorized_keys files on AWS instances
2. _add_swap.yml: Add empty binary /swapfile with automaticaly defined size, and activate a Linux swap onto it. This have been implemented only for low-class EC2 instances, with low sustem memory, and which does not have system swap - t2.small, t3.small, etc. :
3. _execute_script_in_shell.yml: Execute a bash script (in this case: install_consul.sh for installation of Consul agent) on the remote hosts.
