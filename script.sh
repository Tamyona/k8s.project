#!/bin/bash

function prep_bastion() {
  sudo apt update
  sudo apt install ansible terraform -y
}

function create_instances() {
  cd terraform
  terraform init
  terraform apply --auto-approve
}

function update_ips() {
    HOSTS_FILE="../ansible/hosts"
    
    echo "[master]" > "$HOSTS_FILE"
    echo "[workers]" >> "$HOSTS_FILE"
    echo "master ansible_host=$(terraform output -raw master_ip)" >> "$HOSTS_FILE"
    echo "worker1 ansible_host=$(terraform output -raw worker1_ip)" >> "$HOSTS_FILE"
    echo "worker2 ansible_host=$(terraform output -raw worker2_ip)" >> "$HOSTS_FILE"

}

function ansible() {
  cd ../ansible
  ansible-playbook main.yml -i /home/ubuntu/k8s.project/terraform/inventory.ini
}

prep_bastion
create_instances
update_ips
ansible