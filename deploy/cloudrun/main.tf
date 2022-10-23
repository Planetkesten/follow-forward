provider "google" {
    project = var.GCP_PROJECT_ID
}

locals {
  google_api_services = [
      "run.googleapis.com", 
      "artifactregistry.googleapis.com"
  ]
  
  operational_roles = [
     "roles/run.developer"
     "roles/artifactregistry.writer"  
  ]
}

resource "google_project_service" "project" {
  foreach = locals.google_api_services
  project = var.GCP_PROJECT_ID
  service = each.key
}

resource "google_cloud_run_service" "default" {
    name     = var.SERVICE
    location = var.REGION

    metadata {
      annotations = {
        "run.googleapis.com/client-name" = "terraform"
      }
    }

    template {
      spec {
        containers {
          image = "gcr.io/${var.PROJECT_ID}/${var.IMAGE}"
        }
      }
    }
 }

 data "google_iam_policy" "noauth" {
   binding {
     role = "roles/run.invoker"
     members = ["serviceAccount:{var.INVOKER_SERVICE_ACCOUNT}"]
   }
 }

 resource "google_cloud_run_service_iam_policy" "noauth" {
   location    = google_cloud_run_service.default.location
   project     = google_cloud_run_service.default.project
   service     = google_cloud_run_service.default.name

   policy_data = data.google_iam_policy.noauth.policy_data
}


 resource "google_service_account" "service_account" {
  account_id   = "git-actions"
  display_name = "git-actions"
}
