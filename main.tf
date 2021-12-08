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
  count  = var.create_internet_gateway ? 1 : 0
  vpc_id = var.vpc_id
  tags   = merge(var.igw_tags)
}

# Create Route Table
resource "aws_route_table" "jayaworld-aws-rt" {
  count  = var.create_route_table ? 1 : 0
  vpc_id = var.vpc_id
  dynamic "route" {
    for_each = var.route == null ? [] : var.route

    content {
      #destination arguments
      cidr_block                 = lookup(route.value, "cidr_block", null)
      ipv6_cidr_block            = lookup(route.value, "ipv6_cidr_block", null)
      destination_prefix_list_id = lookup(route.value, "destination_prefix_list_id", null)

      #target arguments
      carrier_gateway_id        = lookup(route.value, "carrier_gateway_id", null)
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      local_gateway_id          = lookup(route.value, "local_gateway_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }
  tags = merge(var.rt_tags)
}

# Create Route table subnets associations
resource "aws_route_table_association" "jayaworld-aws-rt-association" {
  count          = var.create_route_table_association ? 1 : 0
  route_table_id = var.route_table_id
  subnet_id      = var.subnet_id
  gateway_id     = var.gateway_id
}