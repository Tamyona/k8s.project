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
    
    # Start fresh with [bastion] since it's static
    echo "[bastion]" > "$HOSTS_FILE"
    echo "localhost ansible_connection=local" >> "$HOSTS_FILE"
    echo "" >> "$HOSTS_FILE"

    # Add master node
    echo "[master]" >> "$HOSTS_FILE"
    echo "master ansible_host=$(terraform output -raw master_ip)" >> "$HOSTS_FILE"
    echo "" >> "$HOSTS_FILE"

    # Add worker nodes
    echo "[workers]" >> "$HOSTS_FILE"
    echo "worker1 ansible_host=$(terraform output -raw worker1_ip)" >> "$HOSTS_FILE"
    echo "worker2 ansible_host=$(terraform output -raw worker2_ip)" >> "$HOSTS_FILE"
}

function ansible() {
  cd ../ansible
  ansible-playbook main.yml 
}

function generate_cluster() {
  # Store the IPs as variables
  MASTER_IP=$(terraform output -raw master_ip)
  WORKER1_IP=$(terraform output -raw worker1_ip)
  WORKER2_IP=$(terraform output -raw worker2_ip)

  cd ../terraform-cluster/
  terraform init
  terraform apply --auto-approve -var="master_ip=$MASTER_IP" -var="worker1_ip=$WORKER1_IP" -var="worker2_ip=$WORKER2_IP"
}

function rke_up() {
  sudo terraform output -raw kube_config | sudo tee ~/.kube/config > /dev/null
  kubectl get nodes
}



prep_bastion
create_instances
update_ips
ansible
generate_cluster
sleep 10
rke_up