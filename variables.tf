variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet1_cidr_block" {
  description = "CIDR block for subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet2_cidr_block" {
  description = "CIDR block for subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "subnet1_az" {
  description = "Availability Zone for subnet 1"
  type        = string
  default     = "ap-south-1a" #Enter your prefered AZ
}

variable "subnet2_az" {
  description = "Availability Zone for subnet 2"
  type        = string
  default     = "ap-south-1b" #Enter your prefered AZ
}

variable "ecs_cluster_name" {
  description = "Name for ECS cluster"
  type        = string
  default     = "ecs_cluster" #The name of your ECS cluster
}

variable "ecs_task_family" {
  description = "ECS Task Family"
  type        = string
  default     = "ecs-task-family" #The name of your ECS task 
}

variable "ecs_service_name" {
  description = "Name for ECS service"
  type        = string
  default     = "ecs_service" #The name of your ECS service
}

variable "ecs_cluster_security_group_name" {
  description = "Name for Security group"
  type        = string
  default = "ecs_cluster_security_group"
}

variable "route_table_name" {
  description = "Name for route table"
  type        = string
  default = "route_table"
}