# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {}
variable "ssh_keys" {}
variable "priv_key" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

# Create a VM to host dcna.io container
resource "digitalocean_droplet" "dcna" {
  image  = "fedora-28-x64"
  name   = "dcna-io"
  region = "nyc1"
  size   = "s-1vcpu-1gb"
  ssh_keys = ["${var.ssh_keys}"]

  provisioner "local-exec" {
    command = "echo ${digitalocean_droplet.dcna.ipv4_address} ansible_python_interpreter=/usr/bin/python3 >> hosts.ini"
    command = "ansible-playbook --private-key=${var.priv_key} -i hosts.ini playbook.yaml"
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "rm -y hosts.ini"
  }



}



