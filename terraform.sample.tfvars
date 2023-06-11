# https://aws.amazon.com/ec2/spot/pricing/

REGION        = "us-east-1"
INSTANCE_TYPE = "t3.xlarge"
SPOT_PRICE    = "0.052"
AMI_ID        = "ami-04a0ae173da5807d3" # Amazon Linux 2023 AMI 64-bit (x86)
AMI_USER      = "ec2-user"

PUBLIC_KEY_PATH   = "~/.ssh/id_rsa.pub"
PRIVATE_KEY_PATH  = "~/.ssh/id_rsa"
ROOT_STORAGE_SIZE = "50"
