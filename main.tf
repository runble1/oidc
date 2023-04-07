data "http" "github_actions_openid_configuration" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

data "tls_certificate" "github_actions" {
  url = jsondecode(data.http.github_actions_openid_configuration.body).jwks_uri
}

resource "aws_iam_openid_connect_provider" "github_actions_oidc_provier" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_actions.certificates[0].sha1_fingerprint]
}

resource "aws_iam_role" "example_role" {
  name = "github-actions-open-id-connect-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = [aws_iam_openid_connect_provider.github_actions_oidc_provier.arn]
      }
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:${var.org_name}/*:ref:${var.ref_prefix}",
          ]
        }
      }
    }]
  })
}

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