# Efficiency Unleashed: Harnessing AWS Spot Instances as Powerful Workstations

Use AWS spot instances for ad-hoc tasks whenever your local workstation resources become a limiting factor.

## Requirements

- [AWS Account](https://aws.amazon.com/resources/create-account/);
- [AWS CLI](https://aws.amazon.com/cli/);
- [Terraform](https://www.terraform.io/) - provision of AWS resources;
- [Python 3](https://www.python.org/downloads/);
- [Ansible](https://www.ansible.com/) - automate initial configuration for the spot instance;
- [Visual Studio Code](https://code.visualstudio.com/) as a remote IDE (optional).

## Usage

Follow the steps below:

1. Install [Ansible](https://www.ansible.com/)

   ```bash
   python3 -m venv .venv
   source .venv/bin/activate

   pip install -U pip
   pip install -r requirements.txt
   ```

2. Find the instance and regions with the best price. Useful resources for that:

   - [Spot the Instance](https://spot-the-instance.netlify.app/) simple tool to search instance by CPU/RAM and their prices across regions
   - [Amazon EC2 Spot Instances Pricing](https://aws.amazon.com/ec2/spot/pricing/)
   - [Spot Instance advisor](https://aws.amazon.com/ec2/spot/instance-advisor/)

3. Create a local Terraform variables file.

   ```bash
   cp terraform.sample.tfvars ./terraform/terraform.tfvars

   # or

   make tfvars
   ```

4. Update the `terraform/terraform.tfvars` variables files. Please note that AMI ID is different for each region. Futhermore, AMI user might also be different for each Linux distribution.

5. Validate the Terraform setup by generating a plan.

   ```bash
   cd terraform
   terraform init
   terraform plan

   # or

   make plan
   ```

6. Provision resources. Thi step might fail initially with error `Call to function "templatefile" failed: templates/environment.sh:3,36-45: Invalid template interpolation value;`. This is due `Public IP` value not being available to finish template rendering step. Please perform it multiple times until valid response is received from AWS backend and the Terraform config is able to create inventory file for Ansible playbook.

   ```bash
   cd terraform
   terraform apply

   # or

   make deploy
   ```

7. Perform initial host configuration

   ```bash
   ansible-playbook -i ansible/inventory ansible/configure.yml

   # or

   make configure
   ```

8. Connect to the host. The Terraform configuration will create a handy utility `aws.env` which contains commands that could be used to connect to the AWS spot instance. Please see the commands below on how to use it.

   ```bash
   # load commands into shell context
   source aws.env

   # connect to the host using SSH
   aws-connect

   # create TCP tunnel
   aws-tunnel
   # usage: aws-tunnel <local_port> <remote_host> <remote_port>

   # push files to the remote host
   aws-push my-project

   # pull files from the remote host
   aws-pull my-project
   ```

   Review the `aws.env` file for more details.

9. Connect to the host using [the Visual Studio Code Remote Development](https://code.visualstudio.com/docs/remote/ssh) feature.

## References

- [Spot the Instance](https://spot-the-instance.netlify.app/)
- [Amazon EC2 Spot Instances Pricing](https://aws.amazon.com/ec2/spot/pricing/)
- [Spot Instance advisor](https://aws.amazon.com/ec2/spot/instance-advisor/)
- [Remote Development using SSH](https://code.visualstudio.com/docs/remote/ssh)
