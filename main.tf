module "iam" {
  source = "./modules/iam"
}

output "iam_role_arn" {
  value = module.iam.iam_role_arn
}
