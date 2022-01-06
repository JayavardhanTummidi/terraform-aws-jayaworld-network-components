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
  route_table_id = var.route_table_id_association
  subnet_id      = var.rt_subnet_id
  gateway_id     = var.gateway_id
}

# Create EIP for NAT gateway
resource "aws_eip" "jayaworld-aws-eip" {
  count = var.create_elastic_ip ? 1 : 0
  vpc   = true
}

# Create NAT gateway public to allow instances from private subnets to communicate with internet
resource "aws_nat_gateway" "jayaworld-aws-nat-gateway" {
  count             = var.create_nat_gateway ? 1 : 0
  allocation_id     = aws_eip.jayaworld-aws-eip[count.index].id
  connectivity_type = "public"
  subnet_id         = var.nat_subnet_id
  tags              = merge(var.nat_tags)
}

# Create routes to the existing route table
resource "aws_route" "jayaworld-aws-route" {
  count          = var.create_aws_routes ? 1 : 0
  route_table_id = var.route_table_id
  # Destination
  destination_cidr_block      = var.route_destination_cidr_block
  destination_ipv6_cidr_block = var.route_destination_ipv6_cidr_block
  destination_prefix_list_id  = var.destination_prefix_list_id

  # Target
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

#Create Networking ACL
resource "aws_network_acl" "jayaworld-acl" {
  count      = var.create_aws_network_acl ? 1 : 0
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  dynamic "ingress" {
    for_each = var.acl_ingress_rules == null ? [] : var.acl_ingress_rules

    content {
      from_port       = lookup(acl_ingress_rules.value, "from_port", null)
      to_port         = lookup(acl_ingress_rules.value, "to_port", null)
      rule_no         = lookup(acl_ingress_rules.value, "rule_no", null)
      action          = lookup(acl_ingress_rules.value, "action", null)
      protocol        = lookup(acl_ingress_rules.value, "protocol", null)
      cidr_block      = lookup(acl_ingress_rules.value, "cidr_block", null)
      ipv6_cidr_block = lookup(acl_ingress_rules.value, "ipv6_cidr_block", null)
      icmp_type       = lookup(acl_ingress_rules.value, "icmp_type", null)
      icmp_code       = lookup(acl_ingress.rules.value, "icmp_code", null)
    }
  }

  dynamic "egress" {
    for_each = var.acl_egress_rules == null ? [] : var.acl_egress_rules

    content {
      from_port       = lookup(acl_ingress_rules.value, "from_port", null)
      to_port         = lookup(acl_ingress_rules.value, "to_port", null)
      rule_no         = lookup(acl_ingress_rules.value, "rule_no", null)
      action          = lookup(acl_ingress_rules.value, "action", null)
      protocol        = lookup(acl_ingress_rules.value, "protocol", null)
      cidr_block      = lookup(acl_ingress_rules.value, "cidr_block", null)
      ipv6_cidr_block = lookup(acl_ingress_rules.value, "ipv6_cidr_block", null)
      icmp_type       = lookup(acl_ingress_rules.value, "icmp_type", null)
      icmp_code       = lookup(acl_ingress.rules.value, "icmp_code", null)
    }
  }

  tags = merge(var.acl_tags)

}

#Creating security group rules
resource "aws_security_group" "jayaworld-security-group" {
  count       = var.create_security_group ? 1 : 0
  name        = var.security_group_name
  description = var.sg_description
  vpc_id      = var.vpc_id
  tags        = merge(var.sg_tags)

  dynamic "ingress" {
    for_each = var.sg_ingress_rules == null ? [] : var.sg_ingress_rules

    content {
      from_port        = lookup(sg_ingress_rules.value, "from_port", null)
      to_port          = lookup(sg_ingress_rules.value, "to_port", null)
      protocol         = lookup(sg_ingress_rules.value, "protocol", null)
      cidr_blocks      = lookup(sg_ingress_rules.value, "cidr_blocks", null)
      description      = lookup(sg_ingress_rules.value, "description", null)
      ipv6_cidr_blocks = lookup(sg_ingress_rules.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(sg_ingress_rules.value, "prefix_list_ids", null)
      security_groups  = lookup(sg_ingress_rules.value, "security_groups", null)
      self             = lookup(sg_ingress_rules.value, "self", null)
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress_rules == null ? [] : var.sg_egress_rules

    content {
      from_port        = lookup(sg_egress_rules.value, "from_port", null)
      to_port          = lookup(sg_egress_rules.value, "to_port", null)
      protocol         = lookup(sg_egress_rules.value, "protocol", null)
      cidr_blocks      = lookup(sg_egress_rules.value, "cidr_blocks", null)
      description      = lookup(sg_egress_rules.value, "description", null)
      ipv6_cidr_blocks = lookup(sg_egress_rules.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(sg_egress_rules.value, "prefix_list_ids", null)
      security_groups  = lookup(sg_egress_rules.value, "security_groups", null)
      self             = lookup(sg_egress_rules.value, "self", null)

    }
  }
}

