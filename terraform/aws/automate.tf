data "template_file" "install_chef_automate_cli" {
  template = "${file("${path.module}/files/install_chef_automate_cli.sh.tpl")}"
}

resource "aws_instance" "chef_automate" {
  connection {
    user        = "${var.aws_centos_image_user}"
    private_key = "${file("${var.aws_key_pair_file}")}"
  }

  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "${var.automate_server_instance_type}"
  key_name               = "${var.aws_key_pair_name}"
  subnet_id              = "${aws_subnet.automate_demo_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.automate_demo.id}"]
  ebs_optimized          = true

  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }

  tags {
    Name          = "${format("chef_automate_${random_id.instance_id.hex}")}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }

  provisioner "file" {
    destination = "/tmp/install_chef_automate_cli.sh"
    content     = "${data.template_file.install_chef_automate_cli.rendered}"
  }
  provisioner "remote-exec" {
    inline = [
      "PUB_DNS=$(curl http://169.254.169.254/latest/meta-data/public-hostname)",
      "sudo hostnamectl set-hostname $PUB_DNS",
      "sudo chmod +x /tmp/install_chef_automate_cli.sh",
      "sudo bash /tmp/install_chef_automate_cli.sh",
      "sudo chef-automate init-config",
      "sudo chef-automate deploy /home/centos/config.toml --accept-terms-and-mlsa",
      "sudo chown centos:centos /home/centos/automate-credentials.toml",
      "sudo echo -e \"api-token =\" $(sudo chef-automate admin-token) >> automate-credentials.toml",
      "sudo cat /home/centos/automate-credentials.toml",
    ]
  }
}