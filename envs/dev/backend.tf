terraform {
  backend "s3" {
    bucket       = "devops-platform-tfstate-509399596610"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
