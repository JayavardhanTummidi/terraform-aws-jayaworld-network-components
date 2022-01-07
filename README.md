> **Thanks for using Jaya world modules**

> **Example to create new VPC and subnets and Internet gateway**

module "jayaworld-network-components" {

  source  = "JayavardhanTummidi/jayaworld-network-components/aws"

  version = "0.30.0"

  # Insert the required variables here

  create_aws_vpc = true

  vpc_cidr_block = "10.0.0.0/16"

  vpc_tags = {

    Name = "jaya-world-vpc"

  }

  # Create Subnets

  subnet_cidr_blocks      = ["10.0.0.0/24", "10.0.1.0/24"]

  subnet_azs              = ["us-east-1a", "us-east-1b"]

  vpc_id                  = "vpc-0474d8bd75961925a"

  create_internet_gateway = true

> **Example to create new route table**

 create_route_table      = true

 route = [

    {

      cidr_block = "0.0.0.0/0"

      gateway_id = "igw-052f08e3929c7d788"

    }

  ]

> **Provides a resource to create an association between a route table and a subnet or a route table and an internet gateway or virtual private gateway**

  create_route_table_association = true

  route_table_id_association     = "rtb-0f03f1e04a30ac9e1"

  rt_subnet_id                   = "subnet-078913b7d4e793c6f"

> **To Create NAT in public, you must first create elastic ip**

  create_elastic_ip  = true

  create_nat_gateway = true

  nat_subnet_id      = "subnet-078913b7d4e793c6f"

> **To create a new SECOND Route table**

module "jayaworld-network-components-2" {

  source             = "JayavardhanTummidi/jayaworld-network-components/aws"

  version            = "0.30.0"

  vpc_id             = "vpc-0474d8bd75961925a"

  create_route_table = true

  route = [

    {

      cidr_block     = "0.0.0.0/0"

      nat_gateway_id = "nat-08e6b9df57c86c743"

    }

  ]

  rt_tags = {

    Name = "jw-rt-2"

  }

> **To create route rules for the existing route table**

  create_aws_routes            = true

  route_table_id               = "rtb-0e9ec0a95de4a9b94"

  route_destination_cidr_block = "0.0.0.0/8"

  route_nat_gateway_id         = "nat-08e6b9df57c86c743"

> **To create network ACL**

create_aws_network_acl = true

vpc_id  = "vpc-0474d8bd75961925a"

subnet_ids = ["subnet-1", "subnet-2"]

ingress = [

    {
        action = "Allow"

        rule_no = 1

        from_port = 22

        to_port = 22

        protocol = "TCP"

        cidr_block = ["10.0.0.0/24"]

    },

    {

        repeat above attributes for the other rules 
        
    }
]

egress = [

    {
        action = "Allow"
        
        rule_no = 1

        from_port = 22

        to_port = 22

        protocol = "TCP"

        cidr_block = ["10.0.0.0/24"]

    },

    {

        repeat above attributes for the other rules 

    }

]


