# terraform-aws-beanstalk

## usage
```
module "demo-dev" {
  source = "git::https://gitlab.com/nalbam/terraform-aws-beanstalk.git"
  region = "ap-northeast-2"

  name = "demo"
  stage = "dev"

  package = "data/LatestVersion.zip"
  version_label = "LatestVersion"

  keypair = "keypair"
  solution_stack_name = "64bit Amazon Linux 2017.09 v2.8.4 running Docker 17.09.1-ce"

  vpc_id = "${module.network.vpc_id}"
  public_subnet_ids = "${module.network.public_subnet_ids}"
  private_subnet_ids = "${module.network.public_subnet_ids}"
  security_group_ids = "${module.network.security_group_ids}"

  env_vars = {
    PROFILE = "dev"
  }
}
```
