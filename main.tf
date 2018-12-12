provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_key_pair" "master_key" {
  key_name   = "jmeter-key"
  public_key = "${file("jmeter.key.pub")}"
}

resource "aws_instance" "master" {
  ami             = "${var.master_ami}"
  instance_type   = "${var.master_type}"
  key_name        = "${aws_key_pair.master_key.key_name}"
  security_groups = ["${aws_security_group.jmeter-master.name}", "${aws_security_group.jmeter-base.name}"]

  associate_public_ip_address = true

  user_data = <<-EOF
    #cloud-config
    hostname: jmater
    EOF

  tags {
    app  = "jmeter"
    role = "master"
    CeCo = "Tecnologia"
    Name = "jmaster"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = "${aws_instance.master.public_ip}"
    agent       = false
    private_key = "${file("jmeter.key")}"
  }

  provisioner "file" {
    source      = "jmeter.key"
    destination = "/tmp/jmeter.key"
  }

  provisioner "file" {
    content     = "${data.template_file.nodes.rendered}"
    destination = "/tmp/nodes"
  }

  provisioner "file" {
    source      = "conf/setup.sh"
    destination = "/tmp/setup"
  }

  provisioner "file" {
    source      = "conf/update-hosts.yml"
    destination = "/home/ubuntu/update-hosts.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/jmeter.key /root/.ssh/id_rsa",
      "sudo chmod  0600 /root/.ssh/id_rsa",
      "cat /tmp/nodes | sudo tee -a /etc/hosts",
      "awk '{ print $2 }' /tmp/nodes | sudo tee -a /etc/ansible/hosts",
      "sudo sed -i '/protected-mode/s/yes/no/' /etc/redis/redis.conf",
      "sudo sed -i 's/#host_key_checking/host_key_checking/' /etc/ansible/ansible.cfg",
      "sudo systemctl restart redis-server",
      "chmod +x /tmp/setup",
      "sudo /tmp/setup",
    ]
  }

  provisioner "remote-exec" {
    when = "destroy"

    inline = [
      "influxd backup -database jmeter_test -host localhost:8088 jmeter_test",
      "tar czf jmeter-db.tar.gz jmeter_test",
    ]
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "scp -i jmeter.key ubuntu@${aws_instance.master.public_ip}:jmeter-db.tar.gz ./backup/jmeter-db.tar.gz"
  }
}

data "template_file" "nodes" {
  template = <<-EOF
    $${nodes}
    EOF

  vars {
    nodes = "${join("\n", formatlist("%s %s", aws_instance.node.*.private_ip, aws_instance.node.*.tags.Name))}"
  }
}

resource "null_resource" "nodes" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers {
    nodes_instance_ids = "${join(",", aws_instance.node.*.id)}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = "${aws_instance.master.public_ip}"
    agent       = false
    private_key = "${file("jmeter.key")}"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the clutser
    inline = [
      "sudo ansible all -m copy -a 'src=/tmp/setup dest=/tmp/setup mode=0755'",
      "sudo ansible --become all -a '/tmp/setup'",
    ]
  }
}

output "jmaster-public" {
  value = "http://${aws_instance.master.public_ip}:3000"
}

output "jmaster-private" {
  value = "${aws_instance.master.private_ip}"
}
