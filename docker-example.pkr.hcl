packer {
  required_plugins {
    docker = {
      version = ">= 1.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "example" {
  image       = "ubuntu:22.04"
  export_path = "data/image.tar"
}

build {
  sources = ["source.docker.example"]

  provisioner "shell" {
    inline = [
      join(" ", [
        "apt-get update",
        " && apt-get dist-upgrade -y",
        " && apt-get install --no-install-recommends -y curl ca-certificates",
        " && dpkg --get-selections | grep deinstall | awk '{ print $1 }' | xargs apt-get purge -y",
        " && apt-get clean",
        " && rm -rf /var/lib/apt/lists/*"
      ]),
      "curl -fsSL https://get.docker.com | sh -",
    ]
  }

  post-processor "docker-import" {
    repository = "exercises/packer-docker-example"
    tag        = "latest"
  }
}
