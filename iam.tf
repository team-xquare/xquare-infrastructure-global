data "aws_partition" "current" {}

locals {
  irsa_oidc_provider_url = replace(module.eksv2.oidc_provider_arn, "/^(.*provider/)/", "")
  iam_role_policy_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"
}

# S3 =========================================================

#module "xquare_s3_iam_account" {
#  source = "./modules/iam-user"
#  name   = "xquare_s3_iam"
#  policy_arns = [
#    aws_iam_policy.s3_policy.arn
#  ]
#}

#resource "aws_iam_policy" "s3_policy" {
#  name   = "xquare-s3-policy"
#  policy = data.aws_iam_policy_document.s3_policy_document.json
#}

#data "aws_iam_policy_document" "s3_policy_document" {
#  statement {
#    actions   = ["s3:ListAllMyBuckets"]
#    resources = ["arn:aws:s3:::*"]
#    effect    = "Allow"
#  }
#  statement {
#    actions = ["s3:*"]
#    resources = [
#      module.prod_storage.arn,
#      "${module.prod_storage.arn}/*",
#      module.stag_storage.arn,
#      "${module.stag_storage.arn}/*"
#    ]
#    effect = "Allow"
#  }
#}


# thanos S3 =========================================================

resource "aws_iam_role" "thanos_s3" {
  name                  = "thanos_s3_role"
  description           = "Thanos IAM role for service account"
  path                  = "/"
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "thanos_role_attachment" {
  policy_arn = aws_iam_policy.thanos_s3_policy.arn
  role       = aws_iam_role.thanos_s3.name
}

resource "aws_iam_policy" "thanos_s3_policy" {
  name   = "thanos-s3-policy"
  policy = data.aws_iam_policy_document.thanos_s3_policy_document.json
}

data "aws_iam_policy_document" "thanos_s3_policy_document" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
    effect    = "Allow"
  }
  statement {
    actions = ["s3:*"]
    resources = [
      module.thanos_storage.arn,
      "${module.thanos_storage.arn}/*"
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "assume_role_policy" {

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [module.eksv2.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.irsa_oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# tempo S3 =========================================================

resource "aws_iam_role" "tempo_s3" {
  name                  = "tempo_s3_role"
  description           = "tempo IAM role for service account"
  path                  = "/"
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "tempo_role_attachment" {
  policy_arn = aws_iam_policy.tempo_s3_policy.arn
  role       = aws_iam_role.tempo_s3.name
}

resource "aws_iam_policy" "tempo_s3_policy" {
  name   = "tempo-s3-policy"
  policy = data.aws_iam_policy_document.tempo_s3_policy_document.json
}

data "aws_iam_policy_document" "tempo_s3_policy_document" {
  statement {
    actions   = ["s3:PutObject", "s3:GetObject", "s3:ListBucket", "s3:DeleteObject", "s3:GetObjectTagging", "s3:PutObjectTagging"]
    resources = ["arn:aws:s3:::*"]
    effect    = "Allow"
  }
  statement {
    actions = ["s3:*"]
    resources = [
      module.tempo_storage.arn,
      "${module.tempo_storage.arn}/*"
    ]
    effect = "Allow"
  }
}

# loki S3 =========================================================

resource "aws_iam_role" "loki_s3" {
  name                  = "loki_s3_role"
  description           = "loki IAM role for service account"
  path                  = "/"
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "loki_role_attachment" {
  policy_arn = aws_iam_policy.loki_s3_policy.arn
  role       = aws_iam_role.loki_s3.name
}

resource "aws_iam_policy" "loki_s3_policy" {
  name   = "loki-s3-policy"
  policy = data.aws_iam_policy_document.loki_s3_policy_document.json
}

data "aws_iam_policy_document" "loki_s3_policy_document" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
    effect    = "Allow"
  }
  statement {
    actions = ["s3:*"]
    resources = [
      module.loki_storage.arn,
      "${module.loki_storage.arn}/*"
    ]
    effect = "Allow"
  }
}

# fe S3 =======================================================

#module "xquare_fe_s3_iam_account" {
#  source = "./modules/iam-user"
#  name   = "xquare_fe_s3_iam"
#  policy_arns = [
#    aws_iam_policy.fe_s3_policy.arn
#  ]
#  create_iam_user_login_profile = true
#}

#resource "aws_iam_policy" "fe_s3_policy" {
#  name   = "xquare-fe-s3-policy"
#  policy = data.aws_iam_policy_document.fe_s3_policy_document.json
#}

locals {
  fe_s3_folder = "fe"
}

#data "aws_iam_policy_document" "fe_s3_policy_document" {
#  statement {
#    actions   = ["s3:ListAllMyBuckets"]
#    resources = ["arn:aws:s3:::*"]
#    effect    = "Allow"
#  }
#  statement {
#    effect    = "Allow"
#    actions   = ["s3:ListBucket"]
#    resources = [module.prod_storage.arn]
#    condition {
#      test     = "StringEquals"
#      variable = "s3:prefix"
#      values = [
#        "",
#        "${local.fe_s3_folder}/"
#      ]
#    }
#    condition {
#      test     = "StringEquals"
#      variable = "s3:delimiter"
#      values = [
#        "/"
#      ]
#    }
#  }
#  statement {
#    effect    = "Allow"
#    actions   = ["s3:ListBucket"]
#    resources = [module.prod_storage.arn]
#    condition {
#      test     = "StringLike"
#      variable = "s3:prefix"
#      values = [
#        "${local.fe_s3_folder}/*"
#      ]
#    }
#  }
#  statement {
#    effect  = "Allow"
#    actions = ["s3:*"]
#    resources = [
#      "${module.prod_storage.arn}/fe/*",
#    ]
#  }
#}

# SQS =========================================================

module "xquare_sqs_iam_account" {
  source = "./modules/iam-user"
  name   = "xquare_sqs_iam"
  policy_arns = [
    data.aws_iam_policy.sqs_policy.arn
  ]
}

data "aws_iam_policy" "sqs_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

# Karpenter =========================================================

resource "aws_iam_role" "xquare-karpenter" {
  name                  = "xquare-karpenter"
  description           = "xquare role for karpenter"
  path                  = "/"
  assume_role_policy    = data.aws_iam_policy_document.ec2_assume_role_policy.json
  force_detach_policies = true
}

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [module.eksv2.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.irsa_oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

locals {
  karpenter-policy-prefixes = [
    "${local.iam_role_policy_prefix}/AmazonEKSWorkerNodePolicy",
    "${local.iam_role_policy_prefix}/AmazonEC2ContainerRegistryReadOnly",
    "${local.iam_role_policy_prefix}/AmazonSSMManagedInstanceCore",
    "${local.iam_role_policy_prefix}/AmazonEKS_CNI_Policy"
  ]
}

resource "aws_iam_role_policy_attachment" "xquare-karpenter-policy-attachment" {
  for_each   = toset(local.karpenter-policy-prefixes)
  policy_arn = each.value
  role       = aws_iam_role.xquare-karpenter.name
}

# Vault Auto-Unseal KMS 설정 =========================================================

resource "aws_iam_role" "vault_kms_role" {
  name                  = "vault-kms-role"
  description           = "Vault IAM role for KMS auto-unseal"
  path                  = "/"
  assume_role_policy    = data.aws_iam_policy_document.vault_assume_role_policy.json
  force_detach_policies = true
}

data "aws_iam_policy_document" "vault_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [module.eksv2.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.irsa_oidc_provider_url}:sub"
      values   = ["system:serviceaccount:vault:vault-server"]
    }
  }
}

resource "aws_iam_policy" "vault_kms_policy" {
  name   = "vault-kms-policy"
  policy = data.aws_iam_policy_document.vault_kms_policy_document.json
}

data "aws_iam_policy_document" "vault_kms_policy_document" {
  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    resources = [
      aws_kms_key.vault_unseal_key.arn
    ]
    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "vault_kms_role_attachment" {
  policy_arn = aws_iam_policy.vault_kms_policy.arn
  role       = aws_iam_role.vault_kms_role.name
}

resource "aws_kms_key" "vault_unseal_key" {
  description             = "KMS Key for Vault Auto-Unseal"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  
  tags = {
    Name = "vault-auto-unseal-key"
  }
}

resource "aws_kms_alias" "vault_unseal_key_alias" {
  name          = "alias/vault-auto-unseal-key"
  target_key_id = aws_kms_key.vault_unseal_key.key_id
}