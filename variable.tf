variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "garagemanagement"
}

variable "db_username" {
  description = "Usuário root para o banco de dados RDS."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Senha root para o banco de dados RDS."
  type        = string
  sensitive   = true
}
