locals {
  # Central ECR Policy Config
  backend_oidc_role = "oidc-${var.org_abbr}-${var.backend_repo}"
  ci_role_temp      = "arn:aws:iam::%s:role/${local.backend_oidc_role}"
  dev_ci_role_arn   = format(local.ci_role_temp, var.dev_account_id)
  uat_ci_role_arn   = format(local.ci_role_temp, var.uat_account_id)
  prod_ci_role_arn  = format(local.ci_role_temp, var.prod_account_id)
}

data "aws_iam_policy_document" "central_ecr_repo_policy" {
  version = "2012-10-17"
  statement {
    sid    = "AllowPushAndPullForDevAndUATCI"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        local.dev_ci_role_arn,
        local.uat_ci_role_arn
      ]
    }
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
  }

  statement {
    sid    = "AllowPullAndTagForProdCI"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [local.prod_ci_role_arn]
    }
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
    ]
  }
}
