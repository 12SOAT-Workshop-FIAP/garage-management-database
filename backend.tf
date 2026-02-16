terraform {
  backend "s3" {
    bucket = "garagemanagement-terraform-backend-4"
    key    = "garage-management-database/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "garagemanagement-terraform-locks"
    encrypt        = true
  }
}
