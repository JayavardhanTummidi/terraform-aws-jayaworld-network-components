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
  count                           = length(var.subnet_cidr_blocks) > 0 && (length(var.subnet_cidr_blocks) >= length(var.subnet_azs)) ? length(var.subnet_cidr_blocks) : 0
  vpc_id                          = var.vpc_id
  cidr_block                      = element(concat(var.subnet_cidr_blocks, [""]), count.index)
  availability_zone               = element(concat(var.subnet_azs, [""]), count.index)
  map_public_ip_on_launch         = var.enable_subnet_public_ip
  assign_ipv6_address_on_creation = var.enable_subnet_ipv6_creation
  ipv6_cidr_block                 = var.subnet_ipv6_cidr_block
  map_customer_owned_ip_on_launch = var.map_customer_ip_for_subnets
  customer_owned_ipv4_pool        = var.customer_ip_address
  outpost_arn                     = var.customer_outpost_arn
  tags                            = merge(var.subnet_tags)
}

# Create Internet Gateway
resource "aws_internet_gateway" "jayaworld-aws-igw" {
  vpc_id = var.vpc_id
  tags   = merge(var.igw_tags)
}

# Create Route Table
resource "aws_route_table" "jayaworld-aws-rt" {
  vpc_id = var.vpc_id
  route  = var.route
  tags   = merge(var.rt_tags)
}

# Edit Routes in the route table
resource "aws_route" "jayaworld-aws-route" {
  route_table_id = var.route_table_id
  # Route Destinations
  destination_cidr_block      = var.route_destination_cidr_block
  destination_ipv6_cidr_block = var.route_destination_ipv6_cidr_block
  # Route Targets
  carrier_gateway_id        = var.route_carrier_gateway_id
  egress_only_gateway_id    = var.route_egress_only_gateway_id
  gateway_id                = var.route_gateway_id
  instance_id               = var.route_instance_id
  nat_gateway_id            = var.route_nat_gateway_id
  local_gateway_id          = var.route_local_gateway_id
  network_interface_id      = var.route_network_interface_id
  transit_gateway_id        = var.route_transit_gateway_id
  vpc_endpoint_id           = var.route_vpc_endpoint_id
  vpc_peering_connection_id = var.route_vpc_peering_connection_id
}