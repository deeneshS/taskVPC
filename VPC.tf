//vpc
resource "aws_vpc" "vpc" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "prod_vpc"
  }
}

//subnet
resource "aws_subnet" "subnet_public" {

  vpc_id = aws_vpc.vpc.id

  cidr_block = "10.1.0.0/24"

  map_public_ip_on_launch = "true"

  availability_zone = "us-east-1a"

  tags = {

    Name = "SUBNET"

  }

}
//IGW
resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.vpc.id

  tags = {

    Name = "IGW"

  }

}
//RT

resource "aws_route_table" "rtb_public" {

  vpc_id = aws_vpc.vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id

  }

  tags = {

    Name = "RT"
  }
}
//CREATE A FILE SUBNETASS.TF WHICH IS USED TO MAKE OUR SUBNET PUBLIC

resource "aws_route_table_association" "rta_subnet_public" {

  subnet_id = aws_subnet.subnet_public.id

  route_table_id = aws_route_table.rtb_public.id


}


//CREATE A FILE SG.TF FOR ACCESSING THE EC2 INSTANCE ON PORT 22

resource "aws_security_group" "sg" {

  name = "secg"

  vpc_id = aws_vpc.vpc.id

  ingress {

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "SSH"

  }

}
// AT LAST CREATE A FILE EC2.TF WHICH WE USED TO EC2 INSTANCE IN OUR SUBNET, VPC

resource "aws_instance" "testInstance" {

  ami = "ami-04ad2567c9e3d7893"

  instance_type = "t2.micro"

  subnet_id = aws_subnet.subnet_public.id

  tags = {

    Name = "test"

  }

}