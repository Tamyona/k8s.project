terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
      version = "~> 1.4.0"
    }
  }
}

provider "rke" {
  log_file = "rke_debug.log"
}

# Create a new RKE cluster using arguments
resource "rke_cluster" "cluster" {
  enable_cri_dockerd = true
  
  nodes {
    address = var.master_ip
    user    = "rke"
    role    = ["controlplane", "etcd"]
    ssh_key = file("~/.ssh/id_rsa")
  }

  nodes {
    address = var.worker1_ip
    user    = "rke"
    role    = ["controlplane", "worker", "etcd"]
    ssh_key = file("~/.ssh/id_rsa")
  }

  nodes {
    address = var.worker2_ip
    user    = "rke"
    role    = ["controlplane", "worker", "etcd"]
    ssh_key = file("~/.ssh/id_rsa")
  }

  upgrade_strategy {
      drain = true
      max_unavailable_worker = "20%"
  }
}