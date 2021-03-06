////////////////////////////////
// AWS Connection

variable "aws_profile" {}

variable "aws_region" {
  default = "us-west-2"
}

////////////////////////////////
// Server Settings

variable "aws_centos_image_user" {
  default = "centos"
}

variable "aws_ubuntu_image_user" {
  default = "ubuntu"
}

variable "aws_amazon_image_user" {
  default = "ec2-user"
}

variable "windows_admin_password" {
  description = "Windows Administrator password to login as."
}

////////////////////////////////
// Tags

variable "tag_customer" {}

variable "tag_project" {}

variable "tag_name" {}

variable "tag_dept" {}

variable "tag_contact" {}

variable "tag_application" {}

variable "tag_ttl" {
  default = 3600
}

variable "aws_key_pair_file" {}

variable "aws_key_pair_name" {}

variable "automate_server_instance_type" {
  default = "m4.xlarge"
}

variable "centos_server_instance_type" {
  default = "t2.micro"
}

variable "vpc_id" {
  default = ""
}

variable "subnet_id" {
  default = ""
}