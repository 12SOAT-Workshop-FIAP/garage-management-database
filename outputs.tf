output "db_endpoint" {
  description = "Endpoint de conexão do banco de dados."
  value       = module.rds.db_endpoint
}

output "db_name" {
  description = "Nome do banco de dados."
  value       = module.rds.db_name
}
