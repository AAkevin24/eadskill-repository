terraform {
  backend "s3" {
    bucket = "tf-state-ead-skill-challenge-kevin"
    key    = "terraform.tfstate"         
    region = "us-east-1"                 
    encrypt = true                       
  }
}