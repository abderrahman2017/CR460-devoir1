resource "google_compute_instance" "chien" {
  name         = "chien"
  machine_type = "f1-micro"
  zone         = "us-east1-b"
  tags         = ["public"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.prod-dmz.name
    access_config {

    }
  }


  metadata_startup_script = "apt-get -y update && apt-get -y upgrade && apt-get -y install apache2 && systemctl start apache2"
}


resource "google_compute_instance" "chat" {
  name         = "chat"
  machine_type = "CoreOs 2514.1.0"
  zone         = "us-east1-b"
  tags         = ["public"]

  boot_disk {
    initialize_params {
      image = "fedora-coreos-cloud/fedora-coreos-stable"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.prod-interne.name
    access_config {

    }
  }
}


resource "google_compute_instance" "perroquet" {
  name         = "perroquet"
  machine_type = "f1-micro"
  zone         = "us-east1-b"
  tags         = ["workload"]

  boot_disk {
    initialize_params {
      image = "Ubuntu 16.04.4"
    }
  }
  network_interface {
     # A default network is created for all GCP projects
     network       = "default"
     access_config {
     }
   }
}

/*  name   = "cr460-autoscaler"
  zone   = "us-east1-c"
  target = google_compute_instance_group_manager.cr460-workload-gm.self_link

  autoscaling_policy {
    max_replicas    = 10
    min_replicas    = 4
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}
/*resource "google_compute_autoscaler" "cr460-autoscaler" {
  name   = "cr460-autoscaler"
  zone   = "us-east1-c"
  target = google_compute_instance_group_manager.cr460-workload-gm.self_link

  autoscaling_policy = {
    max_replicas    = 5
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}*/
