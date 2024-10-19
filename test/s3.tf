resource "aws_s3_bucket" "example" {
  bucket = "terry-tf-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}