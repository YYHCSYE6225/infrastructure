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

  tags = {
    "name" = "application"
  }

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

  tags = {
    "name" = "database"
  }
}