provider "aws" {
 region="us-east-1"
}

resource "aws_instance" "web1" {
 instance_type="t3.micro"
 ami="ami-0ec10929233384c7f"
 key_name="mypemkey"
 vpc_security_group_ids=[aws_security_group.sgw.id]
 subnet_id=aws_subnet.subnet1.id
 availability_zone="us-east-1a"

user_data = <<EOF
#!/bin/bash
apt update -y
apt install -y apache2

cd /var/www/html/
rm -rf *

echo "Hi this is webserver-1" > /var/www/html/index.html

systemctl enable apache2
systemctl restart apache2
EOF


 tags={
 Name="web-server-1"
}
}

resource "aws_instance" "web2"{
 instance_type="t3.micro"
 ami="ami-0ec10929233384c7f"
 key_name ="mypemkey"
 vpc_security_group_ids=[aws_security_group.sgw.id]
 subnet_id=aws_subnet.subnet2.id
 availability_zone="us-east-1b"

user_data = <<EOF
#!/bin/bash
apt update -y
apt install -y apache2

cd /var/www/html/
rm -rf *

echo "Hi this is webserver-2" > /var/www/html/index.html

systemctl enable apache2
systemctl restart apache2
EOF

 tags={
 Name ="web-server-2"
}
}

resource "aws_instance" "app1"{
 instance_type="t3.micro"
 ami="ami-0ec10929233384c7f"
 key_name ="mypemkey"
 vpc_security_group_ids=[aws_security_group.sgw.id]
 subnet_id=aws_subnet.subnet1.id
 tags={
 Name="app-server-1"
}
}


resource "aws_instance" "app2"{
 instance_type="t3.micro"
 ami="ami-0ec10929233384c7f"
 key_name ="mypemkey"
 vpc_security_group_ids=[aws_security_group.sgw.id]
 subnet_id=aws_subnet.subnet2.id
 tags={
 Name="app-server-2"
}
}

resource "aws_iam_user" "seven" {
for_each = var.user_names
name = each.value
}

variable "user_names" {
description = "*"
type = set(string)
default = ["milky1", "tillu1", "hari1", "Dharani1"]
}

resource "aws_ebs_volume" "eight" {
 availability_zone = "us-east-1a"
  size = 25
  tags = {
    Name = "ebs-001"
  }
}
