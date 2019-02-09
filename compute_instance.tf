provider "google" {
        project = "[gcp-project]"
        region  = "asia-northeast1"
  }

  resource "google_compute_instance" "vm_instance" {
        name         = "gce-terraform"
        machine_type = "g1-small"
        zone         = "asia-northeast1-b"

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

resource "google_app_engine_application" "app-terraform" {
  location_id = "asia-northeast1"
}

resource "google_sql_database_instance" "db-test" {
  name = "terra-db"
  project = "[gcp-project]"
  database_version = "MYSQL_5_7"

  settings {
    tier = "db-f1-micro"
  }
}
