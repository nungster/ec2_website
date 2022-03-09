locals {
  region    = var.region
  namespace = var.namespace
}

module "networking" {
  source    = "./modules/networking"
  namespace = var.namespace
}

module "ssh-key" {
  source    = "./modules/ssh-key"
  namespace = var.namespace
}

module "ec2" {
  source    = "./modules/ec2"
  namespace = var.namespace
  vpc       = module.networking.vpc
  sg_pub_id = module.networking.sg_pub_id
  key_name  = module.ssh-key.key_name
}

/*
### Started creating an ECR and IAM Role/Policy to store and pull image, but did not have access to 
### those features.  Decided to push image to a public Docker repo instead.
resource "aws_ecr_repository" "ec2_website" {
  name                 = "ec2-website"
  image_tag_mutability = "MUTABLE"

  tags = {
    project = "ec2-website"
  }
}

resource "aws_iam_role" "ec2_role_ec2_website" {
  name = "ec2_role_ec2_website"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow"
      }
    ]
  })

  tags = {
    project = "ec2-website"
  }
}

resource "aws_iam_instance_profile" "ec2_profile_ec2_website" {
  name = "ec2_profile_ec2_website"
  role = aws_iam_role.ec2_role_ec2_website.name
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = aws_iam_role.ec2_role_ec2_website.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}
*/
