#Crear los Nodos Slaves

resource "aws_instance" "node" {
  ami             = "${var.node_ami}"
  instance_type   = "${var.node_type}"
  key_name        = "${aws_key_pair.master_key.key_name}"
  security_groups = ["${aws_security_group.jmeter-base.name}"]

  #vpc_security_group_ids = [ "${aws_security_group.jmeter-sg.id}" ]
  associate_public_ip_address = false

  user_data = <<-EOF
    #cloud-config
    hostname: node${count.index}
    EOF

  count = "${var.cantnode}"

  tags {
    app  = "jmeter"
    role = "node"
    CeCo = "Tecnologia"
    Name = "node${count.index}"
  }
}

output "node-private-ip" {
  value = "${formatlist("%s %s", aws_instance.node.*.private_ip, aws_instance.node.*.tags.Name)}"
}
