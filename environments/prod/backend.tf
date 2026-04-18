terraform {
    backend "s3" {
        bucket = "terraform-state-mgnt"
        key = "prod/lab-01"
        region = "ap-southeast-2"

        dynamodb_table = "lab-01"
    }
}