# terraform-aws-beanstalk

## usage
```
module "demo-dev" {
  source = "git::https://gitlab.com/nalbam/terraform-aws-beanstalk.git"
  region = "ap-northeast-2"

  name = "demo"

  bucket = "bucket_name"
  package = "data/LatestVersion.zip"
  version_label = "LatestVersion"
}
```
