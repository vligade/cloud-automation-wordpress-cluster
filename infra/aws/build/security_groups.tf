resource "aws_security_group" "wordpress-rds-security-group" {
  name   = "${replace(var.name_prefix, "/[-_\\.@]/", "")}-${replace(var.environment, "/[-_\\.@]/", "")}-rds-sg"
  vpc_id = "${aws_vpc.wordpress_vpc.id}"

  tags {
    user        = "${var.name_prefix}"
    environment = "${var.environment}"
  }

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    cidr_blocks = [
      "${var.webserver_subnet_cidr_a}",
      "${var.webserver_subnet_cidr_b}",
    ]
  }
}

resource "aws_security_group" "wordpress-front-loadbalancer-security-group" {
  name   = "${replace(var.name_prefix, "/[-_\\.@]/", "")}-${replace(var.environment, "/[-_\\.@]/", "")}-front-loadbalancer-sg"
  vpc_id = "${aws_vpc.wordpress_vpc.id}"

  tags {
    user        = "${var.name_prefix}"
    environment = "${var.environment}"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    cidr_blocks = [
      "${var.webserver_subnet_cidr_a}",
      "${var.webserver_subnet_cidr_b}",
    ]
  }
}

resource "aws_security_group" "wordpress-webserver-security-group" {
  name   = "${replace(var.name_prefix, "/[-_\\.@]/", "")}-${replace(var.environment, "/[-_\\.@]/", "")}-webserver-sg"
  vpc_id = "${aws_vpc.wordpress_vpc.id}"

  tags {
    user        = "${var.name_prefix}"
    environment = "${var.environment}"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 11371
    to_port     = 11371
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    cidr_blocks = [
      "${var.database_subnet_cidr_a}",
      "${var.database_subnet_cidr_b}",
    ]
  }
}
