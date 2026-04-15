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

output "subnet_ids" {
  value = aws_subnet.subnets[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "alb_dns" {
  value = aws_lb.main.dns_name
}