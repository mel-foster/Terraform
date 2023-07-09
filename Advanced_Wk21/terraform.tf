terraform {
  backend "s3" {
    bucket = "s3bucket-week21-melfoster"
    key    = "State-files/terraform.tfstate"
    region = "us-east-1"
  }
}