
terraform {
  backend "s3" {
    bucket         = var.backend_s3
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = var.backend_dynamodb
  }
}