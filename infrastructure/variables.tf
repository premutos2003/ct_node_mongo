variable "stack" {
  type = "string"
  default = "express"
}
variable "region" {
  type = "string"
  default = "eu-central-1"
}
variable "git_project" {
  type = "string"
  default ="ct-web-app"

}variable "port" {
  type = "string"
  default = "3000",
}
variable "version" {
  type = "string"
  default = "0.1"
}
variable "environment" {
  type = "string"
  default = "dev"
}
variable "kms_key_arn" {
  type = "string"
  default = ""
}
variable "ami" {
  type = "string"
  default = ""
}
variable "sec_gp_id" {
  type = "string"
  default = "default"
}
variable "subnet_id" {
  type = "string"
  default = "default"
}