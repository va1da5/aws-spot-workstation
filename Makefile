.PHONY: plan
plan:
	@cd terraform; \
		terraform init; \
		terraform plan

.PHONY: deploy
deploy:
	@cd terraform; \
		terraform init; \
		terraform apply -auto-approve

.PHONY: destroy
destroy:
	@cd terraform; \
		terraform init; \
		terraform destroy -auto-approve && \
		rm -rf .terraform terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl

.venv:
	@python3 -m venv .venv; \
		source .venv/bin/activate; \
		pip install -U pip; \
		pip install -r requirements.txt

.PHONY: configure
configure: .venv
	@ source ./.venv/bin/activate; \
		cd ansible; \
		ansible-playbook -i inventory configure.yml

terraform/terraform.tfvars:
	cp terraform.sample.tfvars terraform/terraform.tfvars

.PHONY: tfvars
tfvars: terraform/terraform.tfvars