resource "aws_security_group" "http_server" {
  name        = "${var.vpc_name}-http-server"
  description = "Acesso HTTP restrito ao Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "http_server" {
  count = 3
  ami                         = "ami-076742b894530ab1f"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.http_server.id]

  subnet_id                   = aws_subnet.private_subnets[count.index].id
  associate_public_ip_address = false

  tags = {
    Name          = "${var.vpc_name}-${aws_subnet.subnets[count.index].id}-http-server"
    IndexHtmlHash = filesha256("${path.module}/assets/http/index.html")
  }

  user_data = templatefile("${path.module}/assets/http/user-data.sh.tftpl", {
    index_html = file("${path.module}/assets/http/index.html")
  })
  user_data_replace_on_change = true

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

}