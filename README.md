# playbook-gen
Simple shell-script to create skeleton of ansible playbook

## Installation
Add playbook-gen.sh to your `$PATH`

## Example
```
$ playbook-gen.sh new_playbook
Playbook new_playbook is created.
$ tree -a --dirsfirst new_playbook/
new_playbook/
├── group_vars
│   └── all.yml
├── host_vars
├── roles
│   └── requirements.yml
├── ansible.cfg
├── .gitignore
├── inventory
├── main.yml
├── README.md
└── .vault_pass

3 directories, 8 files
$ cat new_playbook/README.md 
new_playbook
========================

### Examples:
\```
# Install/update roles
ansible-galaxy -r roles/requirements.yml install --force

# Play roles
ansible-playbook main.yml
\```
$ cat new_playbook/.vault_pass 
OHduhGBJP16IFg//fRMTYg==
```
