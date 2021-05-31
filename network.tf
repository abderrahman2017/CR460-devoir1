resource "google_compute_network" "devoir1" {
  name                    = "devoir1"
  auto_create_subnetworks = "false"
}


resource "google_compute_subnetwork" "prod-interne" {
  name          = "prod-interne"
  ip_cidr_range = "172.16.20.0/24"
  region        = "us-east1"
  network       = google_compute_network.devoir1.self_link
}

resource "google_compute_subnetwork" "prod-dmz" {
  name          = "prod-dmz"
  ip_cidr_range = "192.168.65.0/24"
  network       = google_compute_network.devoir1.self_link
  region        = "us-east1"
}

resource "google_compute_subnetwork" "prod-traitement" {
  name          = "prod-traitement"
  ip_cidr_range = "10.0.128.0/24"
  region        = "us-east1"
  network       = google_compute_network.devoir1.self_link
}




resource "google_compute_firewall" "ssh-public" {
  name    = "ssh-public"
  network = google_compute_network.devoir1.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags=["public"]
}

resource "google_compute_firewall" "web-public" {
  name    = "web-public"
  network = google_compute_network.devoir1.name
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  target_tags=["public"]
}

resource "google_compute_firewall" "ssh-workload" {
  name    = "ssh-workload"
  network = google_compute_network.devoir1.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags=["workload"]
}

resource "google_compute_firewall" "internal-control" {
  name    = "internal-control"
  network = google_compute_network.devoir1.name

  allow {
    protocol = "tcp"
    ports    = ["4444", "5126"]
  }

  source_ranges = ["10.0.128.0/24"]
  target_tags = ["backend"]
}
