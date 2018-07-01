#!/bin/bash

function create_folders_tree() {
    mkdir ./$1
    for DIR in group_vars host_vars roles; do
        mkdir ./$1/$DIR
    done
}

function create_ansible_cfg() {
    cat > ./$1/ansible.cfg << EOF
[defaults]
vault_password_file     = .vault_pass.txt
inventory               = inventory
roles_path              = roles/
forks                   = 100
ansible_managed         = Ansible managed
retry_files_enabled     = False
host_key_checking       = False
remote_port             = 22
module_lang             = en_US.UTF-8
deprecation_warnings    = True
system_warnings         = True
stdout_callback         = debug

[ssh_connection]
ssh_args                = -o ControlMaster=auto -o ControlPersist=30m -o ForwardAgent=yes
control_path            = /tmp/ansible-%%h-%%p-%%r
pipelining              = True
scp_if_ssh              = True
retries                 = 2

[diff]
always                  = yes
context                 = 3
EOF
}

function create_readme() {
    cat > ./$1/README.md << EOF
$1
========================

### Examples:
\`\`\`
# Install/update roles
ansible-galaxy -r roles/requirements.yml install --force

# Play roles
ansible-playbook main.yml
\`\`\`
EOF
}

function create_gitignore() {
    cat > ./$1/.gitignore << EOF
# Ansible
!roles/requirements.yml
.vault_pass.txt
ansible.log
roles/*
*.retry
*.log
EOF
}

function create_playbook_files() {
    for FILE in main.yml roles/requirements.yml group_vars/all.yml; do
        echo -e "---\n\n" >> ./$1/$FILE
    done
    touch ./$1/inventory
}

function create_vault_pass_file() {
    openssl rand -base64 16 > ./$1/.vault_pass
}

for PLAYBOOK_NAME in "$@"; do
    create_folders_tree $PLAYBOOK_NAME
    create_playbook_files $PLAYBOOK_NAME
    create_ansible_cfg $PLAYBOOK_NAME
    create_gitignore $PLAYBOOK_NAME
    create_vault_pass_file $PLAYBOOK_NAME
    create_readme $PLAYBOOK_NAME
    echo "Playbook $PLAYBOOK_NAME is created."
done
