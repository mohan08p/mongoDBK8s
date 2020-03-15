output "Server_IP_address" {
  description = "Ip Address of the server provisioned."
  value       = "${aws_instance.Node.*.private_ip}"
}
