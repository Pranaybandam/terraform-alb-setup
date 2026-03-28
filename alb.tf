resource "aws_vpc" "main" {
 cidr_block ="10.0.0.0/16"
tags={
 Name=my-vpc
}
}
resource "aws_subnet" "subnet1" {
 vpc_id=aws_vpc.main.id
 cidr_block ="10.0.1.0/24"
 availability_zone="ap-south-1a"
 map_public_ip_on_launch=true
}

resource "aws_subnet" "subnet2" {
 vpc_id=aws_vpc.main.id
 cidr_block ="10.0.2.0/24"
 availability_zone="ap-south-1b"
 map_public_ip_on_launch=true
}

resource "aws_internet_gateway" "igw" {
 vpc_id=aws_vpc.main.id
}

resource "aws_route_table" "rt" {
 vpc_id =aws_vpc.main.id


 route {
 cidr_block="0.0.0.0/0"
 gateway_id=aws_internet_gateway.igw.id
}
}

resource "aws_route_table_association" "route1" {
 subnet_id=aws_subnet.subnet1.id
 route_table_id=aws_route_table.rt.id
}

resource "aws_route_table_association" "route2" {
 subnet_id=aws_subnet.subnet2.id
 route_table_id=aws_route_table.rt.id
}

resource "aws_security_group" "sgw"{
 vpc_id=aws_vpc.main.id


ingress {
 from_port=80
 to_port=80
 protocol="tcp"
 cidr_blocks=["0.0.0.0/0"]
 }
ingress {
 from_port=22
 to_port=22
 protocol="tcp"
 cidr_blocks=["0.0.0.0/0"]
}

egress {
 from_port=0
 to_port=0
 protocol="-1"
 cidr_blocks=["0.0.0.0/0"]
}
}

resource "aws_lb_target_group" "tgp" {
 name = "tgp-tf"
 port =80
 protocol="HTTP"
 vpc_id =aws_vpc.main.id

 health_check {
    path              = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
   }
}

resource "aws_lb_target_group_attachment" "web1" {
 target_group_arn=aws_lb_target_group.tgp.arn
 target_id=aws_instance.web1.id
 port=80
}
resource "aws_lb_target_group_attachment" "web2" {
 target_group_arn=aws_lb_target_group.tgp.arn
 target_id=aws_instance.web2.id
 port=80
}
resource "aws_lb" "alb" {
 name="tf-alb"
 load_balancer_type="application"
 security_groups=[aws_security_group.sgw.id]
 subnets=[aws_subnet.subnet1.id , aws_subnet.subnet2.id]
}

resource "aws_lb_listener" "listener" {
 load_balancer_arn=aws_lb.alb.arn
 port=80
 protocol="HTTP"

 default_action {
 type="forward"
 target_group_arn=aws_lb_target_group.tgp.arn
}
}
