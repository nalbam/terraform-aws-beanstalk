variable region {
  default = "us-east-1"
}

variable "name" {
  default = "demo"
  description = "Solution name, e.g. 'app' or 'demo'"
}

variable "bucket" {
  //default = ""
  description = "The S3 bucket location containing the function's deployment package."
}

variable "package" {
  //default = ""
  description = "The S3 key of an object containing the function's deployment package."
}

variable "version_label" {
  //default = "LatestVersion"
  description = "Version label"
}
