
terraform {
  backend "s3" {
    bucket         = "somnath-terraform-backend"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "somnath-terraform-backend-statelock"
  }
}