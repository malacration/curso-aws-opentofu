output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "regiao_atual" {
  value = data.aws_region.current.id
}