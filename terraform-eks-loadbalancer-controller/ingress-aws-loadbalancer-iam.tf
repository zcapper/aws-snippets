data "http" "aws_loadbalancer_controller" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json"
}

locals {
  # E.g. "oidc.eks.us-east-1.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"
  oidc_issuer = substr(aws_eks_cluster.main.identity.0.oidc.0.issuer, 0, 8)
}

resource "aws_iam_policy" "aws_loadbalancer_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Policy for AWS Load Balancer Controller"
  policy      = data.http.aws_loadbalancer_controller.body
}

resource "aws_iam_role" "aws_loadbalancer_controller" {
  name = "AWSLoadBalancerControllerIAMRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${local.oidc_issuer}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.oidc_issuer}:aud" = "sts.amazonaws.com"
            "${local.oidc_issuer}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_loadbalancer_controller_policy" {
  role       = aws_iam_role.aws_loadbalancer_controller.name
  policy_arn = aws_iam_policy.aws_loadbalancer_controller.arn
}

resource "kubernetes_service_account" "aws_loadbalancer_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"     = "aws-load-balancer-controller"
      "app.kubernetes.io/instance" = "aws-load-balancer-controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws_loadbalancer_controller.arn
    }
  }
}
