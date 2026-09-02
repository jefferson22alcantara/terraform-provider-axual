terraform {
  required_providers {
    axual = {
      source = "Axual/axual"
    }
  }
}

variable "axual_api_url" {
  type        = string
  description = "Axual API base URL"
}

variable "axual_realm" {
  type        = string
  description = "Axual realm"
}

variable "axual_token" {
  type        = string
  sensitive   = true
  description = "Already-issued Axual bearer token"
}

variable "axual_instance_name" {
  type        = string
  description = "Name of an existing Axual instance"
}

provider "axual" {
  apiurl   = var.axual_api_url
  realm    = var.axual_realm
  authmode = "token"
  token    = var.axual_token
}

data "axual_instance" "test" {
  name = var.axual_instance_name
}

output "instance_id" {
  value = data.axual_instance.test.id
}
