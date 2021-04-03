resource "digitalocean_domain" "default" {
  name       = "erisfairbanks.com"
  ip_address = digitalocean_droplet.stream.ipv4_address
}

resource "digitalocean_droplet" "stream" {
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
      "sudo apt install -y build-essential apache2 ruby ruby-dev ruby-bundler git",
      "sudo ufw allow 'Apache'",
      "git clone https://github.com/efairbanks/ericfairbanks-org-jekyll-bootstrap.git",
      "cd ericfairbanks-org-jekyll-bootstrap",
      "gem install jekyll ffi",
      "bundle install",
      "bundle exec jekyll build -d /var/www/html/",
    ]
  }
}

resource "digitalocean_domain" "ospedge" {
  name       = "ospedge.erisfairbanks.com"
  ip_address = digitalocean_droplet.ospedge-test.ipv4_address
}

resource "digitalocean_droplet" "ospedge-test" {
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
      "git clone https://gitlab.com/Deamos/flask-nginx-rtmp-manager.git",
      "cd flask-nginx-rtmp-manager/installs/osp-edge",
      "rm setup-ospEdge.sh",
      "wget https://raw.githubusercontent.com/efairbanks/dobox/master/setup-ospEdge.sh",
      "chmod +x setup-ospEdge.sh"
      /*
      "cp setup/nginx/servers/osp-servers.conf .",
      "cp setup/nginx/services/osp-rtmp.conf .",
      "cp setup/nginx/locations/osp-redirects.conf .",
      "cp osp-edge.service nginx-osp.service",
      "cp ",
      "./setup-ospEdge.sh <<< 'edge1.commie.cafe'",
      ""
      */
    ]
  }
}

/*
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
    ]
  }
}
*/
