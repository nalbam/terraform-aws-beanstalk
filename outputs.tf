output "name" {
  value = "${aws_elastic_beanstalk_application.default.name}"
}

output "version_label" {
  value = "${aws_elastic_beanstalk_application_version.default.name}"
}

output "iam_instance_profile_name" {
  value = "${aws_iam_instance_profile.ec2.name}"
}

output "iam_role_service_name" {
  value = "${aws_iam_role.service.name}"
}

output "iam_role_ec2_id" {
  value = "${aws_iam_role.ec2.id}"
}
