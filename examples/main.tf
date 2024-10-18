module "test" {
  source = "git@github.com:fojiglobal/terence-tf-modules.git//test"
  vpc_cidr = "10.25.0.0/16"
  env       = "test"
}