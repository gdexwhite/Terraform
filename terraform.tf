## terraform code to spin up an ec2-instance
## dev by gwhite on 02/04/23

resource "aws_vpc" "terraform-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terraform-vpc"
          }
}

resource "aws_subnet" "terraform-subnet" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = "10.0.1.0/24"

   tags = {
          Name = "terraform-subnet"
           }
}

resource "aws_security_group" "terraform-grp" {
 name = "terraform-grp"
 vpc_id = aws_vpc.terraform-vpc.id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
           }
   egress  {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
          }
    tags = {
         Name = "allow_all traffic"
           }
}

provider "aws"  {
 region                 = var.region #"us-east-1"
 access_key             = "xxxxxxxxxxx"
 secret_key             = "yyyyyyyyyyy"
                }

resource "aws_instance" "myinstance" {
 ami              = var.ami_id
 instance_type    = var.instancetype
 tenancy          = "default"
 key_name         = var.keyname
#key_name         = "MyUSE1kp"

 vpc_security_group_ids = [aws_security_group.terraform-grp.id]
 subnet_id        = aws_subnet.terraform-subnet.id
 associate_public_ip_address  = true
 tags = {
   Name = "terraform-1"
   Owner = "Greg"
        }
}

output "instance_public_ip" {
  value = aws_instance.myinstance.public_ip
}