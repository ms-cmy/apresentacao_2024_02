terraform {
  backend "remote" {
    hostname = "app.terraform.io" 
    organization = "mine22"
    workspaces {
      prefix = "deploy_example" 
    }
  }
}

