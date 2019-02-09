provider "google" {
	project = "[PROJECT-NAME]"
	region  = "asia-northeast1"
  }

  resource "google_compute_instance" "vm_instance" {
	name         = "gce-terraform"
	machine_type = "f1-micro"
	zone         = "asia-northeast1-a"

	boot_disk {
	  initialize_params {
		size  = 10
		type  = "pd-standard"
		image = "debian-cloud/debian-9"
	  }
	}

	network_interface {
	  network       = "default"
	  access_config = {}
	}

	service_account = {
	  scopes = ["logging-write", "monitoring-write"]
	}
  }
