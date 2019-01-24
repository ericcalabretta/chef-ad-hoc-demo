resource "aws_security_group" "automate_demo" {
  name        = "automate_demo_${random_id.instance_id.hex}"
  description = "base rules for automate_demo demo"
  vpc_id      = "${aws_vpc.automate_demo_vpc.id}"

  tags {
    Name          = "${var.tag_customer}-${var.tag_project}_${random_id.instance_id.hex}_${var.tag_application}_security_group"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

//////////////////////////
// chef_ad_hoc demo SG Rules 
resource "aws_security_group_rule" "ingress_allow_22_tcp_all" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.automate_demo.id}"
}

resource "aws_security_group_rule" "ingress_allow_443_tcp_all" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.automate_demo.id}"
}

resource "aws_security_group_rule" "ingress_allow_80_tcp_all" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.automate_demo.id}"
}

# RDP - all
resource "aws_security_group_rule" "ingress_rdp_all" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.automate_demo.id}"
}

# WinRM - all
resource "aws_security_group_rule" "ingress_winrm_all" {
  type              = "ingress"
  from_port         = 5985
  to_port           = 5986
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.automate_demo.id}"
}

# Egress: ALL
resource "aws_security_group_rule" "egress_allow_0-65535_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.automate_demo.id}"
}
