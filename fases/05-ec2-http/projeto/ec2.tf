resource "aws_security_group" "http_server" {
  name        = "${var.vpc_name}-http-server"
  description = "Acesso HTTP para a EC2 do curso"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "http_server" {
  ami                         = "ami-076742b894530ab1f"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.subnets[0].id
  vpc_security_group_ids      = [aws_security_group.http_server.id]
  associate_public_ip_address = true

  tags = {
    Name          = "${var.vpc_name}-${aws_subnet.subnets[0].id}-http-server"
    IndexHtmlHash = filesha256("${path.module}/assets/http/index.html")
  }

  user_data = templatefile("${path.module}/assets/http/user-data.sh.tftpl", {
    index_html = file("${path.module}/assets/http/index.html")
  })
  user_data_replace_on_change = true

}