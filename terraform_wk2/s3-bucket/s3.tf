# s3 resource block
resource "aws_s3_bucket" "my-new-S3-bucket" {
  bucket = "my-new-tf-test-bucket-jdf"

  tags = {
    Name    = "My S3 Bucket"
    Purpose = "Intro to Resource Blocks Lab"

  }
}

resource "aws_s3_bucket_ownership_controls" "my_new_bucket_acl" {
  bucket = aws_s3_bucket.my-new-S3-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}




# s3 module and output blocks

module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.14.0"
}
output "s3_bucket_name" {
  value = module.s3-bucket.s3_bucket_bucket_domain_name
}