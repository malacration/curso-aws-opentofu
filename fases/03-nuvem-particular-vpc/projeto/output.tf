output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "regiao_atual" {
  value = data.aws_region.current.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "quantidade_zonas_disponibilidade" {
  value = length(data.aws_availability_zones.available.names)
}

output "zonas_disponibilidade" {
  value = data.aws_availability_zones.available.names
}