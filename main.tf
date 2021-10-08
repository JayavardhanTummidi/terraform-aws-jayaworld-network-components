provider "aws" {
  region = var.region
}

# Create a VPC resource
resource "aws_vpc" "jayaworld-aws-vpc" {
  count                            = var.create_aws_vpc ? 1 : 0
  cidr_block                       = var.vpc_cidr_block
  instance_tenancy                 = var.vpc_instance_tenancy
  enable_dns_support               = var.vpc_enable_dns_support
  enable_dns_hostnames             = var.vpc_enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.vpc_enable_assign_generated_ipv6_cidr_block
  tags                             = merge(var.vpc_tags)
}

# Create Subnets
resource "aws_subnet" "jayaworld-aws-subnets" {
  count                           = var.create_aws_subnet ? 1 : 0
  vpc_id                          = var.vpc_id
  cidr_block                      = var.subnet_cidr_blocks[count.index]
  availability_zone               = var.subnet_azs
  availability_zone_id            = var.subnet_az_ids
  map_public_ip_on_launch         = var.enable_subnet_public_ip
  assign_ipv6_address_on_creation = var.enable_subnet_ipv6_creation
  ipv6_cidr_block                 = var.subnet_ipv6_cidr_block
  map_customer_owned_ip_on_launch = var.map_customer_ip_for_subnets
  customer_owned_ipv4_pool        = var.customer_ip_address
  outpost_arn                     = var.customer_outpost_arn
  tags                            = merge(var.subnet_tags)
}