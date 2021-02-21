resource "digitalocean_domain" "default" {
  name       = "erisfairbanks.com"
  ip_address = digitalocean_droplet.stream.ipv4_address
}

resource "digitalocean_droplet" "stream" {
  image = "ubuntu-18-04-x64"
  name = "dobox"
  region = "nyc1"
  size = "s-2vcpu-2gb"
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
      "sudo apt install -y nginx libnginx-mod-rtmp wget",
      "wget https://raw.githubusercontent.com/efairbanks/dobox/master/nginx_additions.conf",
      "sudo cat nginx_additions.conf >> /etc/nginx/nginx.conf",
      "sudo systemctl restart nginx"
      # install nginx
      #"sudo apt-get update",
      #"sudo apt-get -y install docker.io",
      #"git clone https://github.com/efairbanks/cybox.git",
      #"cd cybox",
      #"./deploy.sh"
    ]
  }
}
