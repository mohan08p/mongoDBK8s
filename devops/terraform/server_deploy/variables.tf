variable "aws_ami_ubuntu" {
  type = "string"
}

variable "num_of_instances" {
  type    = "string"
  default = "1"
}

variable "key_path" {
  type = "string"
}

variable "subnet_id" {
  type = "list"
}

variable "security_group" {
  type = "list"
}

variable "delete_on_termination" {
  type    = "string"
  default = "true"
}

variable "private_key_path" {
  type = "string"
}

variable "Root_vol_size" {
  type    = "string"
  default = "20"
}

variable "Opt_vol_size" {
  type    = "string"
  default = "10"
}

variable "availability_zone" {
  type    = "list"
  default = ["us-east-1b", "us-east-1d"]
}

variable "aws_instance_type" {
  type    = "list"
  default = ["t2.nano", "t2.nano"]
}

variable "name" {
  type = "list"
}

variable "env" {
  type = "string"
}