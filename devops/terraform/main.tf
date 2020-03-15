provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

# ------- IAM ---------
# s3_access

resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3_access"
  role = "${aws_iam_role.s3_access_role.name}"
}

resource "aws_iam_role_policy" "s3_access_policy" {
  name = "s3_access_policy"
  role = "${aws_iam_role.s3_access_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
   {
     "Effect": "Allow",
     "Action": "s3:*",
     "Resource": "*"
   }
  ]
}
EOF
}

resource "aws_iam_role" "s3_access_role" {
  name = "s3_access_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
  }
  ]
}
EOF
}

# -------------- VPC -------------

resource "aws_vpc" "myapp_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "myapp_vpc"
  }
}

#internet gateway

resource "aws_internet_gateway" "myapp_internet_gateway" {
  vpc_id = "${aws_vpc.myapp_vpc.id}"

  tags {
    Name = "myapp_igw"
  }
}

# Route tables

resource "aws_route_table" "myapp_public_rt" {
  vpc_id = "${aws_vpc.myapp_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.myapp_internet_gateway.id}"
  }

  tags {
    Name = "myapp_public"
  }
}

resource "aws_default_route_table" "myapp_private_rt" {
  default_route_table_id = "${aws_vpc.myapp_vpc.default_route_table_id}"

  tags {
    Name = "myapp_private"
  }
}

#Subnets

resource "aws_subnet" "myapp_public1_subnet" {
  vpc_id = "${aws_vpc.myapp_vpc.id}"
  cidr_block = "${var.cidrs["public1"]}"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zone.available.names[0]}"

  tags {
    Name = "myapp_public1"
  }
}

resource "aws_subnet" "myapp_public2_subnet" {
  vpc_id = "${aws_vpc.myapp_vpc.id}"
  cidr_block = "${var.cidrs["public2"]}"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zone.available.names[1]}"

  tags {
    Name = "myapp_public2"
  }
}

resource "aws_subnet" "myapp_private1_subnet" {
  vpc_id = "${aws_vpc.myapp_vpc.id}"
  cidr_block = "${var.cidrs["private1"]}"
  map_public_ip_on_launch = false
  availability_zone = "${data.aws_availability_zone.available.names[0]}"

  tags {
    Name = "myapp_private1"
  }
}

resource "aws_subnet" "myapp_private2_subnet" {
  vpc_id = "${aws_vpc.myapp_vpc.id}"
  cidr_block = "${var.cidrs["private2"]}"
  map_public_ip_on_launch = false
  availability_zone = "${data.aws_availability_zone.available.names[1]}"

  tags {
    Name = "myapp_private2"
  }
}

resource "aws_subnet" "myapp_db1_subnet" {
  vpc_id = "${aws_vpc.myapp_vpc.id}"
  cidr_block = "${var.cidrs["db1"]}"
  map_public_ip_on_launch = false
  availability_zone = "${data.aws_availability_zone.available.names[0]}"

  tags {
    Name = "myapp_db1"
  }
}

resource "aws_subnet" "myapp_db2_subnet" {
  vpc_id = "${aws_vpc.myapp_vpc.id}"
  cidr_block = "${var.cidrs["db2"]}"
  map_public_ip_on_launch = false
  availability_zone = "${data.aws_availability_zone.available.names[1]}"

  tags {
   Name = "myapp_db2"
  }
}

module "control_node" {
  source            = "/server_deploy"
  num_of_instances  = "${var.num_of_instances}"
  name              = "${var.name}"
  aws_ami_ubuntu    = "${var.aws_ami_ubuntu}"
  aws_instance_type = "${var.aws_instance_type}"
  key_path          = "${var.keyname}"
  subnet_id         = "${aws_subnet.myapp_private1_subnet.id}"
  security_group    = "${var.security_group}"
  availability_zone = "${var.availability_zone}"
  private_key_path  = "${var.private_key_path}"
  env               = "{{ environment }}"
}

output "vpc_id" {
  value = "${aws_vpc.myapp_vpc.id}"
}
