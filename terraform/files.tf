resource "local_file" "ansible_inventory" {
  content = templatefile("templates/inventory.cfg",
    {
      public_ip        = aws_spot_instance_request.main.public_ip
      private_key_path = pathexpand(var.PRIVATE_KEY_PATH)
      user             = var.AMI_USER
    }
  )
  filename = "../ansible/inventory"
}

resource "local_file" "context" {
  content = templatefile("templates/environment.sh",
    {
      public_ip        = aws_spot_instance_request.main.public_ip
      private_key_path = pathexpand(var.PRIVATE_KEY_PATH)
      user             = var.AMI_USER
    }
  )
  filename = "../aws.env"
}
