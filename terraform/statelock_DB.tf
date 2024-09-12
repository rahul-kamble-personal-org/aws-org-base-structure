

data "aws_dynamodb_table" "terraform_state_lock" {
  name = "terraform-state-lock"
}

# resource "aws_dynamodb_table" "terraform_state_lock" {
#   name           = "terraform-state-lock"
#   read_capacity  = 5
#   write_capacity = 5
#   hash_key       = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name = "Terraform State Lock Table"
#   }
# }