provider "google" {
  project = "GANTI-DENGAN-PROJECT-ID-ANDA" # Ambil dari dashboard Qwiklabs
  region  = "us-central1"
}

# Task 1: Cloud Storage Bucket
resource "google_storage_bucket" "task1_bucket" {
  name          = "qwiklabs-gcp-00-d76a50dc29a9-bucket"
  location      = "US"
  force_destroy = true
}

# Task 2: Persistent Disk
resource "google_compute_disk" "task2_disk" {
  name = "mydisk"
  type = "pd-balanced"
  zone = "us-central1-a"
  size = 200
}

# Task 2 & 3: VM Instance & NGINX
resource "google_compute_instance" "task2_vm" {
  name         = "my-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Memberikan IP Publik
    }
  }

  attached_disk {
    source = google_compute_disk.task2_disk.id
  }

  # Task 3: Install NGINX otomatis
  metadata_startup_script = "sudo apt-get update && sudo apt-get install -y nginx"

  tags = ["http-server"]
}

# Firewall agar port 80 terbuka
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-nginx"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}