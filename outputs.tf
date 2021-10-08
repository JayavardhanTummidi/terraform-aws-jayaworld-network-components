output "arn" {
  description = "Amazon Resource Name (ARN) of VPC"
  value       = aws_vpc.jayaworld-aws-vpc.arn
}

output "id" {
  description = "The ID of the VPC"
  value       = aws_vpc.jayaworld-aws-vpc.id
}

output "cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.jayaworld-aws-vpc.cidr_block
}

output "main_route_table_id" {
  description = "The ID of the main route table associated with this VPC. Note that you can change a VPC's main route table by using an aws_main_route_table_association"
  value       = aws_vpc.jayaworld-aws-vpc.main_route_table_id
}

output "default_network_acl_id" {
  description = "The ID of the network ACL created by default on VPC creation"
  value       = aws_vpc.jayaworld-aws-vpc.default_network_acl_id
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_vpc.jayaworld-aws-vpc.default_security_group_id
}