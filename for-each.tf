terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.22.0"
    }
  }
}


variable "configuration" {
  type = map
  default = {
"one" =  {
    "instance_name" = "nginx-dev"
    "image"         = "nginx:latest"
    "internal_port" = "8080"
    "external_port" = "8080"
  },
"two" =  {
    "instance_name" = "nginx-uat"
    "image"         = "nginx:latest"
    "internal_port" = "8080"
    "external_port" = "8081"
  },
"three" =  {
    "instance_name" = "nginx-prod"
    "image"         = "nginx:latest"
    "internal_port" = "8080"
    "external_port" = "8082"
  }
  }
}


# Pulls the image
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

# Create a container
resource "docker_container" "nginx" {
  for_each = var.configuration
  image = each.value["image"]
  name  = each.value["instance_name"]
  ports {
      internal = each.value["internal_port"]
      external = each.value["external_port"]
  }
}

output "docker_container" {
  value = values(docker_container.nginx).*.name
}