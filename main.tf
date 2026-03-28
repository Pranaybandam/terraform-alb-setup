provider "aws" {
 region="ap-south-1"
}

resource "aws_instance" "web1" {
 instance_type="t3.micro"
 ami="ami-05d2d839d4f73aafb"
 key_name="myhyd.pem"
 vpc_security_group_ids=[aws_security_group.sgw.id]
 subnet_id=aws_subnet.subnet1.id
 availability_zone="ap-south-1a"

  user_data = <<EOF
 #!/bin/bash
 sudo apt update -y
 sudo apt install apache2 -y
 systemctl enable apache2
 systemctl start apache2
 echo "Hi this is webserver-1">>/var/www/html/index.html
 EOF


 tags={
 Name="web-server-1"
}
}

resource "aws_instance" "web2"{
 instance_type="t3.micro"
 ami="ami-070e5bd3ff10324f8"
 key_name ="myhyd.pem"
 vpc_security_group_ids=[aws_security_group.sgw.id]
 subnet_id=aws_subnet.subnet2.id
 availability_zone="ap-south-1b"

 user_data = <<EOF
 #!/bin/bash
 sudo apt update -y
 sudo apt install apache2 -y
 systemctl enable apache2
 systemctl start apache2
 echo "Hi this is webserver-2">>/var/www/html/index.html
 EOF

 tags={
 Name ="web-server-2"
}
}

resource "aws_instance" "app1"{
 instance_type="t3.micro"
 ami="ami-070e5bd3ff10324f8"
 key_name ="myhyd.pem"
 vpc_security_group_ids=[aws_security_group.sgw.id]
 subnet_id=aws_subnet.subnet1.id
 tags={
 Name="app-server-1"
}
}


resource "aws_instance" "app2"{
 instance_type="t3.micro"
 ami="ami-070e5bd3ff10324f8"
 key_name ="myhyd.pem"
 vpc_security_group_ids=[aws_security_group.sgw.id]
 subnet_id=aws_subnet.subnet2.id
 tags={
 Name="app-server-2"
}
}

