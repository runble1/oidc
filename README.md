# 
## Reference
https://developers.bookwalker.jp/entry/2022/03/18/110000

## Usage
```
terraform init
terraform apply
```

## Check Authorization
```
resource "aws_iam_role_policy" "example_role_policy" {
  name   = "example_role_policy"
  role   = aws_iam_role.example_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "*" #sts:GetCallerIdentity
      Effect = "Allow"
      Resource = "*"
    }]
  })
}
```