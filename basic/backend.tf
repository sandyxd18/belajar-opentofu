terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"

    endpoint = "http://localhost:8080"

    access_key = "<YOUR_ACCESS_KEY_HERE>"
    secret_key = "<YOUR_SECRET_KEY_HERE>"

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}