variable "PROJECT_ID" {}
#test
provider "google" {
        project = "${var.PROJECT_ID}"
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
  name = "terra-db2"
  project = "[project-name]"
  database_version = "MYSQL_5_7"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
  name      = "terra-database"
  instance  = "${google_sql_database_instance.db-test.name}"
  charset   = "sjis"
  collation = "sjis_japanese_ci"
}

resource "google_sql_database" "users" {
    name = "root"
    instance = "${google_sql_database_instance.db-test.name}"
}

resource "google_cloudfunctions_function" "cf-test" {
    name = "terra-functions"
    region  = "asia-northeast1"
    trigger_http  = true
    source_archive_bucket  = "${google_storage_bucket.bucket.name}"
    source_archive_object  = "${google_storage_bucket_object.archive.name}"
}

resource "google_storage_bucket" "bucket" {
  name = "cloudfunction-deploy-[project-name]"
  location = "asia-northeast1"
}

resource "google_storage_bucket_object" "archive" {
  name   = "file"
  source = "./testimage.txt"
  bucket = "${google_storage_bucket.bucket.name}"
}
