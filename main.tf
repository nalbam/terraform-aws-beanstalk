# Elastic Beanstalk

resource "aws_elastic_beanstalk_application" "default" {
  name = "${var.name}"
}

resource "aws_s3_bucket_object" "default" {
  bucket = "${var.bucket}"
  key = "${var.package}"
  source = "${var.package}"
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name = "${var.version_label}"
  application = "${aws_elastic_beanstalk_application.default.name}"
  bucket = "${aws_s3_bucket_object.default.bucket}"
  key = "${aws_s3_bucket_object.default.key}"
}
