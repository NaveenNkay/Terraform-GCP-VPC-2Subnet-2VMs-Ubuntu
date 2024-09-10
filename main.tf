resource "google_compute_instance" "my-linux-vm1" {
  name         = "Linux-vm-1"
  machine_type = "e2-standard-4"
  zone         = "us-central1-c"

  tags = ["linux", "devops"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20240731"
      labels = {
        my_label = "ubuntu"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "google_compute_network.vpc_network"
    subnetwork = "google_compute_subnetwork.subnetwork1"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    linux = "devops"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = linux-service-acc@terraform-nk.iam.gserviceaccount.com
    scopes = ["cloud-platform"]
  }
}
resource "google_compute_instance" "my-linux-vm2" {
  name         = "Linux-vm-2"
  machine_type = "e2-standard-4"
  zone         = "asia-east1-a"

  tags = ["linux", "devops"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20240731"
      labels = {
        my_label = "ubuntu"
      }
    }
  }

  // Local SSD disk drive
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "google_compute_network.vpc_network"
    subnetwork = "google_compute_subnetwork.subnetwork2"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    linux = "devops"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = linux-service-acc@terraform-nk.iam.gserviceaccount.com
    scopes = ["cloud-platform"]
  }
}
resource "google_compute_network" "vpc_network" {
name = "terraform-nk-VPC"
}
resource "google_compute_subnetwork" "subnetwork1" {
name = "terraform-subnetwork-1"
ip_cidr_range = "10.1.0.0/16"
region = "us-central1"
network = google_compute_network.vpc_network.name
}
resource "google_compute_subnetwork" "subnetwork2" {
name = "terraform-subnetwork-2"
ip_cidr_range = "10.2.0.0/16"
region = "asia-east1"
network = google_compute_network.vpc_network.name
}
