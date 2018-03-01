# Elastic Beanstalk

#
# Full list of options:
# http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkmanagedactionsplatformupdate
#
resource "aws_elastic_beanstalk_environment" "default" {
  name = "${var.name}-${var.stage}"

  application = "${var.name}"

  tier = "${var.tier}"
  solution_stack_name = "${var.solution_stack_name}"

  wait_for_ready_timeout = "${var.wait_for_ready_timeout}"

  #tags = "${module.label.tags}"

  setting {
    namespace = "aws:ec2:vpc"
    name = "VPCId"
    value = "${var.vpc_id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = "${var.associate_public_ip_address}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "Subnets"
    value = "${join(",", var.private_subnets)}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBSubnets"
    value = "${join(",", var.public_subnets)}"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name = "RollingUpdateEnabled"
    value = "true"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name = "RollingUpdateType"
    value = "Health"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name = "MinInstancesInService"
    value = "${var.updating_min_in_service}"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name = "MaxBatchSize"
    value = "${var.updating_max_batch}"
  }

  ###=========================== Autoscale trigger ========================== ###

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "MeasureName"
    value = "CPUUtilization"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name = "Statistic"
    value = "Average"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name = "Unit"
    value = "Percent"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name = "LowerThreshold"
    value = "${var.autoscale_lower_bound}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name = "UpperThreshold"
    value = "${var.autoscale_upper_bound}"
  }

  ###=========================== Autoscale trigger ========================== ###

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "SecurityGroups"
    value = "${join(",", var.security_groups)}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = "${var.instance_type}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "${var.aws_iam_instance_profile_ec2_name}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "EC2KeyName"
    value = "${var.keypair}"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name = "Availability Zones"
    value = "Any 2"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name = "MinSize"
    value = "${var.autoscale_min}"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name = "MaxSize"
    value = "${var.autoscale_max}"
  }
  setting {
    namespace = "aws:elb:loadbalancer"
    name = "CrossZone"
    value = "true"
  }
  setting {
    namespace = "aws:elb:listener"
    name = "ListenerProtocol"
    value = "HTTP"
  }
  setting {
    namespace = "aws:elb:listener"
    name = "InstancePort"
    value = "80"
  }
  setting {
    namespace = "aws:elb:listener"
    name = "ListenerEnabled"
    value = "${var.http_listener_enabled  == "true" || var.loadbalancer_certificate_arn == "" ? "true" : "false"}"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name = "ListenerProtocol"
    value = "HTTPS"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name = "InstancePort"
    value = "80"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name = "SSLCertificateId"
    value = "${var.loadbalancer_certificate_arn}"
  }
  setting {
    namespace = "aws:elb:listener:443"
    name = "ListenerEnabled"
    value = "${var.loadbalancer_certificate_arn == "" ? "false" : "true"}"
  }
  setting {
    namespace = "aws:elb:listener:${var.ssh_listener_port}"
    name = "ListenerProtocol"
    value = "TCP"
  }
  setting {
    namespace = "aws:elb:listener:${var.ssh_listener_port}"
    name = "InstancePort"
    value = "22"
  }
  setting {
    namespace = "aws:elb:listener:${var.ssh_listener_port}"
    name = "ListenerEnabled"
    value = "${var.ssh_listener_enabled}"
  }
  setting {
    namespace = "aws:elb:policies"
    name = "ConnectionSettingIdleTimeout"
    value = "${var.ssh_listener_enabled == "true" ? "3600" : "60"}"
  }
  setting {
    namespace = "aws:elb:policies"
    name = "ConnectionDrainingEnabled"
    value = "true"
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name = "AccessLogsS3Enabled"
    value = "true"
  }
  setting {
    namespace = "aws:elbv2:listener:default"
    name = "ListenerEnabled"
    value = "${var.http_listener_enabled == "true" || var.loadbalancer_certificate_arn == "" ? "true" : "false"}"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name = "ListenerEnabled"
    value = "${var.loadbalancer_certificate_arn == "" ? "false" : "true"}"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name = "Protocol"
    value = "HTTPS"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name = "SSLCertificateArns"
    value = "${var.loadbalancer_certificate_arn}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application"
    name = "Application Healthcheck URL"
    value = "HTTP:80${var.healthcheck_url}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "LoadBalancerType"
    value = "${var.loadbalancer_type}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "ServiceRole"
    value = "${var.aws_iam_role_service_name}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name = "SystemType"
    value = "enhanced"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name = "BatchSizeType"
    value = "Fixed"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name = "BatchSize"
    value = "1"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name = "DeploymentPolicy"
    value = "Rolling"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "BASE_HOST"
    value = "${var.name}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "CONFIG_SOURCE"
    value = "${var.config_source}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name = "ManagedActionsEnabled"
    value = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name = "PreferredStartTime"
    value = "Sun:10:00"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name = "UpdateLevel"
    value = "minor"
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name = "InstanceRefreshEnabled"
    value = "true"
  }

  ###===================== Application ENV vars ======================###

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 0))), 0)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 0))), 0), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 1))), 1)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 1))), 1), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 2))), 2)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 2))), 2), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 3))), 3)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 3))), 3), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 4))), 4)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 4))), 4), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 5))), 5)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 5))), 5), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 6))), 6)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 6))), 6), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 7))), 7)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 7))), 7), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 8))), 8)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 8))), 8), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 9))), 9)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 9))), 9), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 10))), 10)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 10))), 10), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 11))), 11)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 11))), 11), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 12))), 12)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 12))), 12), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 13))), 13)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 13))), 13), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 14))), 14)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 14))), 14), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 15))), 15)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 15))), 15), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 16))), 16)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 16))), 16), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 17))), 17)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 17))), 17), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 18))), 18)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 18))), 18), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 19))), 19)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 19))), 19), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 20))), 20)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 20))), 20), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 21))), 21)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 21))), 21), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 22))), 22)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 22))), 22), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 23))), 23)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 23))), 23), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 24))), 24)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 24))), 24), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 25))), 25)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 25))), 25), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 26))), 26)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 26))), 26), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 27))), 27)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 27))), 27), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 28))), 28)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 28))), 28), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 29))), 29)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 29))), 29), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 30))), 30)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 30))), 30), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 31))), 31)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 31))), 31), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 32))), 32)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 32))), 32), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 33))), 33)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 33))), 33), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 34))), 34)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 34))), 34), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 35))), 35)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 35))), 35), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 36))), 36)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 36))), 36), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 37))), 37)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 37))), 37), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 38))), 38)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 38))), 38), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 39))), 39)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 39))), 39), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 40))), 40)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 40))), 40), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 41))), 41)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 41))), 41), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 42))), 42)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 42))), 42), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 43))), 43)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 43))), 43), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 44))), 44)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 44))), 44), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 45))), 45)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 45))), 45), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 46))), 46)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 46))), 46), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 47))), 47)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 47))), 47), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 48))), 48)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 48))), 48), var.env_default_value)}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "${element(concat(keys(var.env_vars), list(format(var.env_default_key, 49))), 49)}"
    value = "${lookup(var.env_vars, element(concat(keys(var.env_vars), list(format(var.env_default_key, 49))), 49), var.env_default_value)}"
  }

  ###===================== Application Load Balancer Health check settings =====================================================###
  # The Application Load Balancer health check does not take into account the Elastic Beanstalk health check path
  # http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environments-cfg-applicationloadbalancer.html
  # http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environments-cfg-applicationloadbalancer.html#alb-default-process.config

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name = "HealthCheckPath"
    value = "${var.healthcheck_url}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name = "Port"
    value = "80"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name = "Protocol"
    value = "HTTP"
  }

  ###===================== Notification =====================================================###

  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name = "Notification Endpoint"
    value = "${var.notification_endpoint}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name = "Notification Protocol"
    value = "${var.notification_protocol}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name = "Notification Topic ARN"
    value = "${var.notification_topic_arn}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name = "Notification Topic Name"
    value = "${var.notification_topic_name}"
  }

  depends_on = [
    "aws_security_group.default"
  ]
}

resource "aws_ssm_activation" "ec2" {
  name = "${var.name}-beanstalk"
  iam_role = "${var.aws_iam_role_ec2_id}"
  registration_limit = "${var.autoscale_max}"
}
