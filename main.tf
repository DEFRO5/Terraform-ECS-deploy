resource "aws_vpc" "ecs_cluster_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "ecs_cluster_subnet_1" {
  vpc_id                  = aws_vpc.ecs_cluster_vpc.id
  cidr_block              = var.subnet1_cidr_block
  availability_zone       = var.subnet1_az
  map_public_ip_on_launch = true
}

resource "aws_subnet" "ecs_cluster_subnet_2" {
  vpc_id                  = aws_vpc.ecs_cluster_vpc.id
  cidr_block              = var.subnet2_cidr_block
  availability_zone       = var.subnet2_az
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.ecs_cluster_vpc.id
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.ecs_cluster_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "subnet_1_route" {
  subnet_id      = aws_subnet.ecs_cluster_subnet_1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet_2_route" {
  subnet_id      = aws_subnet.ecs_cluster_subnet_2.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "ecs_cluster_security_group" {
  vpc_id = aws_vpc.ecs_cluster_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000 #Provide the port number identical to the one specified in the 'ecs_task_definition' for both from and to port
    to_port     = 5000 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.ecs_task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name  = "resource-monitor",
    image = "defalt762/resourcemonitor:latest", #Enter your image name
    portMappings = [{
      containerPort = 5000, #Specify your preferred port, ensuring that both container and host ports are identical
      hostPort      = 5000,
    }],
  }])
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = 2 #The number of tasks

  network_configuration {
    subnets          = [aws_subnet.ecs_cluster_subnet_1.id, aws_subnet.ecs_cluster_subnet_2.id]
    security_groups  = [aws_security_group.ecs_cluster_security_group.id]
    assign_public_ip = true
  }
}