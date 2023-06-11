
variable "REGION" {
  type    = string
  default = "eu-central-1"
}

variable "INSTANCE_TYPE" {
  type        = string
  default     = "t2.micro"
  description = " Instance type to use for the instance"
  # List https://aws.amazon.com/ec2/spot/pricing/
}

variable "SPOT_PRICE" {
  type        = string
  default     = "0.0001"
  description = "The maximum price to request on the spot market."
}

variable "SPOT_TYPE" {
  type        = string
  default     = "one-time"
  description = "If set to 'one-time', after the instance is terminated, the spot request will be closed"
}

variable "ROOT_STORAGE_SIZE" {
  type        = number
  default     = 10
  description = "Size of the root volume in GB"
}

variable "AMI_ID" {
  type        = string
  description = "Id of the AMI to use. Different for each region!"
}

variable "AMI_USER" {
  type        = string
  default     = "ec2-user"
  description = "User used in AMI"
}

variable "KEEP_DATA" {
  type        = bool
  default     = false
  description = "If true, the root volume will not be deleted when the instance is terminated"
}

variable "PUBLIC_KEY_PATH" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to your public key"
}

variable "PRIVATE_KEY_PATH" {
  type        = string
  default     = "~/.ssh/id_rsa"
  description = "Path to your private key"
}
