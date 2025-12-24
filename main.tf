provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "base" {
  backend = "s3"
  config = {
    bucket = "garagemanagement-terraform-backend-1"
    key    = "garage-management-infra/terraform.tfstate"
    region = var.aws_region
  }
}

module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  db_username  = var.db_username
  db_password  = var.db_password

  public_subnet_ids = data.terraform_remote_state.base.outputs.public_subnet_ids
  rds_sg_id         = data.terraform_remote_state.base.outputs.rds_security_group_id
}
