resource "digitalocean_droplet" "www-1" {
  image = "ubuntu-18-04-x64"
  name = "dobox"
  region = "nyc1"
  size = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo add-apt-repository universe",
      "sudo apt-get update",
      "sudo apt install nginx libnginx-mod-rtmp wget",
      ""
      # install nginx
      #"sudo apt-get update",
      #"sudo apt-get -y install docker.io",
      #"git clone https://github.com/efairbanks/cybox.git",
      #"cd cybox",
      #"./deploy.sh"
    ]
  }
}
