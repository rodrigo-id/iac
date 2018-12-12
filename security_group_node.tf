resource "aws_security_group" "jmeter-base" {
  name        = "Jmeter-base"
  description = "Allow JMeter basic traffic"

  tags {
    Name = "Jmeter-base"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ssh traffic"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
    description = "Allow Internal traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    #prefix_list_ids = ["pl-12c4e678"]
  }
}

#resource "aws_security_group_rule" "ingress-private-sgr" {
#  type      = "ingress"
#  from_port = 0
#  to_port   = 0
#  protocol  = -1
#  self      = true


#  security_group_id = "${aws_security_group.jmeter-node.id}"
#}

