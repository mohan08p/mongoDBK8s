data "template_file" "user_data" {
  template = "${file("${path.module}/script/userdata.sh")}"
}

resource "aws_instance" "Node" {
  count                       = "${var.num_of_instances}"
  ami                         = "${var.aws_ami_ubuntu}"
  instance_type               = "${element(var.aws_instance_type, count.index)}"
  key_name                    = "${var.key_path}"
  subnet_id                   = "${element(var.subnet_id, count.index)}"
  vpc_security_group_ids      = "${var.security_group}"
  associate_public_ip_address = false
  source_dest_check           = false
  availability_zone           = "${element(var.availability_zone, count.index)}"
  user_data                   = "${data.template_file.user_data.rendered}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = "${var.Root_vol_size}"
    delete_on_termination = "${var.delete_on_termination}"
  }

  tags {
    Name             = "${var.env}-${element(var.name, count.index)}"
    wso2Type         = "${element(var.name, count.index)}"
    cms-service      = "none"
    cms-service-type = "control-node"
    cms-enviroment   = "${var.env}"
  }

  provisioner "file" {
    source      = "/home/control_node/infra/script"
    destination = "/tmp/userdata.sh"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("${var.private_key_path}")}"
  }
}