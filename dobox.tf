resource "digitalocean_domain" "erisfairbanks" {
  name       = "erisfairbanks.com"
  ip_address = digitalocean_droplet.erisfairbanks.ipv4_address
}

resource "digitalocean_droplet" "erisfairbanks" {
  image = "ubuntu-18-04-x64"
  name = "erisfairbanks"
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

resource "digitalocean_domain" "cybox" {
  name       = "cybox.erisfairbanks.com"
  ip_address = length(digitalocean_droplet.cybox) > 0 ? digitalocean_droplet.cybox[0].ipv4_address : digitalocean_droplet.erisfairbanks.ipv4_address
}

resource "digitalocean_droplet" "cybox" {
  count = 0
  image = "ubuntu-18-04-x64"
  name = "cybox"
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
      "sudo apt update",
      "sudo apt install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable'",
      "sudo apt update",
      "apt-cache policy docker-ce",
      "sudo apt install -y docker-ce",
      "git clone https://github.com/efairbanks/cybox.git",
      "cd cybox",
      "./deploy.sh"
    ]
  }
}

resource "digitalocean_domain" "stream" {
  name       = "stream.erisfairbanks.com"
  ip_address = length(digitalocean_droplet.stream) > 0 ? digitalocean_droplet.stream[0].ipv4_address : digitalocean_droplet.erisfairbanks.ipv4_address
}

resource "digitalocean_droplet" "stream" {
  count = 1
  image = "ubuntu-18-04-x64"
  name = "stream"
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
      "sudo apt update",
      "sudo apt install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable'",
      "sudo apt update",
      "apt-cache policy docker-ce",
      "sudo apt install -y docker-ce",
      "docker run -d -p 1935:1935 --name nginx-rtmp tiangolo/nginx-rtmp"
    ]
  }
}
