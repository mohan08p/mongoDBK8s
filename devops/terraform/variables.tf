variable "aws_region" {}
variable "aws_profile" {}
data "aws_availability_zone" "available" {}
variable "vpc_cidr" {}

variable "cidrs" {
  type = "map"
}
