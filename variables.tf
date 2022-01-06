variable "region" {
  description = "specify region name"
  type        = string
  default     = "us-east-1"
}

variable "create_aws_vpc" {
  description = "Do you want to create new VPC ? default is false"
  type        = bool
  default     = false
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "vpc_instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC. Default is default, which makes your instances shared on the host. Using either of the other options (dedicated or host) costs at least $2/hr."
  type        = string
  default     = "default"
}

variable "vpc_enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults true."
  type        = bool
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false."
  type        = bool
  default     = false
}

variable "vpc_enable_assign_generated_ipv6_cidr_block" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is false."
  type        = bool
  default     = false
}

variable "vpc_tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string
  default     = ""
}

variable "subnet_cidr_blocks" {
  description = "The CIDR block for the subnet."
  type        = list(string)
  default     = []
}

variable "subnet_azs" {
  description = "The AZ's for the subnet."
  type        = list(string)
  default     = []
}

variable "enable_subnet_public_ip" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is false."
  type        = bool
  default     = false
}

variable "enable_subnet_ipv6_creation" {
  description = "Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address. Default is false"
  type        = bool
  default     = false
}

variable "subnet_ipv6_cidr_block" {
  description = "The IPv6 network range for the subnet, in CIDR notation. The subnet size must use a /64 prefix length."
  type        = string
  default     = null
}

variable "map_customer_ip_for_subnets" {
  description = "Specify true to indicate that network interfaces created in the subnet should be assigned a customer owned IP address. The customer_owned_ipv4_pool and outpost_arn arguments must be specified when set to true. Default is false."
  type        = bool
  default     = false
}

variable "customer_ip_address" {
  description = "The customer owned IPv4 address pool. Typically used with the map_customer_owned_ip_on_launch argument. The outpost_arn argument must be specified when configured."
  type        = string
  default     = ""
}

variable "customer_outpost_arn" {
  description = "The Amazon Resource Name (ARN) of the Outpost."
  type        = string
  default     = ""
}

variable "subnet_tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  type        = map(string)
  default     = {}
}

variable "create_internet_gateway" {
  description = "Do you want to create internet gateway ? "
  type        = bool
  default     = false
}

variable "create_route_table" {
  description = "Do you want to create route table ? "
  type        = bool
  default     = false
}

variable "route" {
  description = "A list of route objects. Their keys are documented below. This argument is processed in attribute-as-blocks mode. This means that omitting this argument is interpreted as ignoring any existing routes. To remove all managed routes an empty list should be specified"
  type        = list(any)
  default     = []
}

variable "igw_tags" {
  description = "internet gateway tags"
  type        = map(string)
  default = {
    Name = "Jayaworld-igw"
  }
}

variable "rt_tags" {
  description = "route table tags"
  type        = map(string)
  default = {
    Name = "Jayaworld-rt"
  }
}

variable "create_route_table_association" {
  description = "Do you want to create route table association ? "
  type        = bool
  default     = false
}

variable "rt_subnet_id" {
  description = "Provide subnet id"
  type        = string
  default     = ""
}

variable "nat_subnet_id" {
  description = "Provide NAT subnet associate id"
  type        = string
  default     = ""
}

variable "gateway_id" {
  description = "Provide gateway id"
  type        = string
  default     = null
}

variable "nat_tags" {
  description = "nat tags"
  type        = map(string)
  default = {
    Name = "Jayaworld-nat"
  }
}

variable "create_nat_gateway" {
  description = "Create nat gateway ? "
  type        = bool
  default     = false
}

variable "create_elastic_ip" {
  description = "Create elastic ip ? "
  type        = bool
  default     = false
}

variable "create_aws_routes" {
  description = "Do you want to create aws route ? "
  type        = bool
  default     = false
}

variable "route_table_id" {
  description = "The ID of the routing table"
  type        = string
  default     = ""
}

variable "route_table_id_association" {
  description = "route table id for subnets association"
  type        = string
  default     = ""
}

variable "route_destination_cidr_block" {
  description = "The destination CIDR block."
  type        = string
  default     = ""
}

variable "route_destination_ipv6_cidr_block" {
  description = "The Ipv6 CIDR block of the route."
  type        = string
  default     = null
}

variable "destination_prefix_list_id" {
  description = "The ID of a managed prefix list destination of the route."
  type        = string
  default     = null
}

variable "route_carrier_gateway_id" {
  description = "Identifier of a carrier gateway. This attribute can only be used when the VPC contains a subnet which is associated with a Wavelength Zone."
  type        = string
  default     = null
}

variable "route_egress_only_gateway_id" {
  description = "Identifier of a VPC Egress Only Internet Gateway."
  type        = string
  default     = null
}

variable "route_gateway_id" {
  description = "Identifier of a VPC internet gateway or a virtual private gateway."
  type        = string
  default     = null
}

variable "route_instance_id" {
  description = "Identifier of an EC2 instance."
  type        = string
  default     = null
}

variable "route_nat_gateway_id" {
  description = "Identifier of a VPC NAT gateway."
  type        = string
  default     = null
}

variable "route_local_gateway_id" {
  description = "Identifier of a Outpost local gateway."
  type        = string
  default     = null
}

variable "route_network_interface_id" {
  description = " Identifier of an EC2 network interface."
  type        = string
  default     = null
}

variable "route_transit_gateway_id" {
  description = "Identifier of an EC2 Transit Gateway."
  type        = string
  default     = null
}

variable "route_vpc_endpoint_id" {
  description = "Identifier of a VPC Endpoint."
  type        = string
  default     = null
}

variable "route_vpc_peering_connection_id" {
  description = " Identifier of a VPC peering connection."
  type        = string
  default     = null
}

variable "create_aws_network_acl" {
  description = "Do you want to create network acl"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "List of subnet id's"
  type        = list(string)
  default     = []
}

variable "acl_ingress_rules" {
  description = "list of Network ACL ingress rules"
  type        = list(any)
  default     = []
}

variable "acl_egress_rules" {
  description = "List of Network ACL egress rules"
  type        = list(any)
  default     = []
}

variable "acl_tags" {
  description = "ACL tags"
  type        = map(string)
  default = {
    Name = "Jayaworld-Network-ACL-rules"
  }
}

variable "create_security_group" {
  description = "Do you want to create security group ? "
  type        = bool
  default     = false
}

variable "security_group_name" {
  description = "Name of the security group. If omitted, Terraform will assign a random, unique name"
  type        = string
  default     = ""
}

variable "sg_description" {
  description = "Security group description. Defaults to Managed by Terraform"
  type        = string
  default     = "Managed by Terraform"
}

variable "sg_tags" {
  description = "security group tags"
  type        = map(string)
  default = {
    Name = "jayaworld-sg-tags"
  }
}

variable "ingress" {
  description = "SG ingress rules"
  type        = list(any)
  default     = []
}

variable "egress" {
  description = "SG egress rules"
  type        = list(any)
  default     = []
}