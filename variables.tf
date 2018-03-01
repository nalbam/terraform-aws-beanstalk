variable "name" {
  default = "app"
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "stage" {
  default = "dev"
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
}

variable "tier" {
  default = "WebServer"
  description = "Elastic Beanstalk Environment tier, e.g. ('WebServer', 'Worker')"
}

variable "solution_stack_name" {
  default = ""
  description = "Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS. [Read more](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html)"
}

variable "wait_for_ready_timeout" {
  default = "20m"
}

variable "vpc_id" {
  //default = ""
  description = "ID of the VPC in which to provision the AWS resources"
}

variable "associate_public_ip_address" {
  default = "false"
  description = "Specifies whether to launch instances in your VPC with public IP addresses."
}

variable "public_subnets" {
  type = "list"
  //default = []
  description = "List of public subnets to place Elastic Load Balancer"
}

variable "private_subnets" {
  type = "list"
  //default = []
  description = "List of private subnets to place EC2 instances"
}

variable "updating_min_in_service" {
  default = "1"
  description = "Minimum count of instances up during update"
}

variable "updating_max_batch" {
  default = "1"
  description = "Maximum count of instances up during update"
}

variable "autoscale_lower_bound" {
  default = "20"
  description = "Minimum level of autoscale metric to add instance"
}

variable "autoscale_upper_bound" {
  default = "80"
  description = "Maximum level of autoscale metric to remove instance"
}

variable "security_groups" {
  type = "list"
  //default = []
  description = "List of security groups"
}

variable "instance_type" {
  default = "t2.micro"
  description = "Instances type"
}

variable "aws_iam_instance_profile_ec2_name" {
  //default = ""
  description = "Instance IAM instance profile name"
}

variable "keypair" {
  //default = ""
  description = "Name of SSH key that will be deployed on Elastic Beanstalk and DataPipeline instance. The key should be present in AWS"
}

variable "autoscale_min" {
  default = "2"
  description = "Minumum instances in charge"
}

variable "autoscale_max" {
  default = "3"
  description = "Maximum instances in charge"
}

variable "http_listener_enabled" {
  default = "false"
  description = "Enable port 80 (http)"
}

variable "ssh_listener_port" {
  default = "22"
  description = "SSH port"
}

variable "ssh_listener_enabled" {
  default = "false"
  description = "Enable ssh port"
}

variable "loadbalancer_type" {
  default = "classic"
  description = "Load Balancer type, e.g. 'application' or 'classic'"
}

variable "aws_iam_role_service_name" {
  //default = ""
  description = "Instance IAM service role name"
}

variable "loadbalancer_certificate_arn" {
  default = ""
  description = "Load Balancer SSL certificate ARN. The certificate must be present in AWS Certificate Manager"
}

variable "healthcheck_url" {
  default = "/health"
  description = "Application Health Check URL. Elastic Beanstalk will call this URL to check the health of the application running on EC2 instances"
}

variable "config_source" {
  default = ""
  description = "S3 source for config"
}

variable "notification_protocol" {
  default = "email"
  description = "Notification protocol"
}

variable "notification_endpoint" {
  default = ""
  description = "Notification endpoint"
}

variable "notification_topic_arn" {
  default = ""
  description = "Notification topic arn"
}

variable "notification_topic_name" {
  default = ""
  description = "Notification topic name"
}

variable "aws_iam_role_ec2_id" {
  //default = ""
  description = "Instance IAM ec2 role id"
}

variable "tags" {
  type = "map"
  default = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "env_default_key" {
  default = "DEFAULT_ENV_%d"
  description = "Default ENV variable key for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting"
}

variable "env_default_value" {
  default = "UNSET"
  description = "Default ENV variable value for Elastic Beanstalk `aws:elasticbeanstalk:application:environment` setting"
}

variable "env_vars" {
  type = "map"
  default = {}
  description = "Map of custom ENV variables to be provided to the Jenkins application running on Elastic Beanstalk, e.g. `env_vars = { JENKINS_USER = 'admin' JENKINS_PASS = 'xxxxxx' }`"
}
