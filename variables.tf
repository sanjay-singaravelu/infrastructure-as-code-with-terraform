// This file defines the input variables for the Terraform configuration.

variable "aws_region" {
    description = "The AWS region to deploy resources in."
    type        = string
}

variable "instance_type" {
    description = "The type of instance to use."
    type        = string
}

variable "ami_id" {
    description = "The AMI ID to use for the instance."
    type        = string
}

variable "ssh_access_cidr" {
    description = "The CIDR block for the VPC."
    type        = string
}

variable "key_name" {
    description = "The name of the SSH key pair to use"
    type        = string
}

variable "aws_secret_key" {
  description = "The AWS secret access key"
  type        = string
}

variable "aws_access_key" {
  description = "The AWS access key"
  type        = string
}
