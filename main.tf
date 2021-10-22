# locals {
#   subnet_az_cidr = {
#     "us-east-1a" = "10.0.2.0/24",
#     "us-east-1b" = "10.0.3.0/24",
#     "us-east-1c" = "10.0.4.0/24",
#   }
# }
resource "aws_vpc" "vpc" {
  cidr_block                       = var.vpc_cidr_block
  enable_dns_support               = true
  enable_dns_hostnames             = true
  enable_classiclink_dns_support   = true
  assign_generated_ipv6_cidr_block = false
  tags = {
    "Name" = "csye6225-vpc-YYH"
  }
}

resource "aws_subnet" "subnet" {

  depends_on = [aws_vpc.vpc]

  for_each = var.subnet_region_cidr_block

  cidr_block              = each.value
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = {
    "Name" = "csye6225-subnet"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "csye6225-gateway"
  }
}

resource "aws_route_table" "routeTable" {
  vpc_id = aws_vpc.vpc.id
  route = [
    {
      cidr_block                 = var.open_cidr_block
      gateway_id                 = aws_internet_gateway.gateway.id
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""

    }

  ]

  tags = {
    Name = "csye6225-routeTable"
  }
}

resource "aws_route_table_association" "ats" {
  for_each       = var.subnet_region_cidr_block
  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.routeTable.id
}

resource "aws_security_group" "application" {
  name        = "application"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      description      = "open 443 port to the world"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = [var.open_cidr_block]
      ipv6_cidr_blocks = [var.open_ipv6_cidr_block]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "open 22 port to the world"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [var.open_cidr_block]
      ipv6_cidr_blocks = [var.open_ipv6_cidr_block]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "open 80 port to the world"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = [var.open_cidr_block]
      ipv6_cidr_blocks = [var.open_ipv6_cidr_block]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "open 8080 port to the world"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = [var.open_cidr_block]
      ipv6_cidr_blocks = [var.open_ipv6_cidr_block]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

}


resource "aws_security_group" "database" {
  name        = "database"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      description      = "open 443 port to the world"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = [var.open_cidr_block]
      ipv6_cidr_blocks = [var.open_ipv6_cidr_block]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  # egress = [
  #   {
  #     from_port        = 0
  #     to_port          = 0
  #     protocol         = "-1"
  #     cidr_blocks      = ["0.0.0.0/0"]
  #     ipv6_cidr_blocks = ["::/0"]
  #   }
  # ]

  tags = {
    Name = "database"
  }
}

# resource "aws_route_table_association" "b" {
#   subnet_id      = aws_subnet.subnet.id["1"]
#   route_table_id = aws_route_table.routeTable.id
# }

# resource "aws_route_table_association" "c" {
#   subnet_id      = aws_subnet.subnet.id["2"]
#   route_table_id = aws_route_table.routeTable.id
# }