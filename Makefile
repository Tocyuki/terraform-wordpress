.PHONY: init plan apply destroy check

init:
	docker-compose run --rm terraform fmt -recursive
	docker-compose run --rm terraform init

plan:
	docker-compose run --rm terraform fmt -recursive
	docker-compose run --rm terraform plan

apply:
	docker-compose run --rm terraform fmt -recursive
	docker-compose run --rm terraform apply

destroy:
	docker-compose run --rm terraform fmt -recursive
	docker-compose run --rm terraform destroy

check:
	docker-compose run --rm terraform fmt -recursive
	docker-compose run --rm terraform fmt -check
	docker-compose run --rm terraform validate

workspace.new.dev:
	docker-compose run --rm terraform workspace new dev

workspace.select.dev:
	docker-compose run --rm terraform workspace select dev
