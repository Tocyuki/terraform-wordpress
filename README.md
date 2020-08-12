# Terraform Wordpress
Create WordPress infrastructure on AWS with Terraform.

## Requirement
- Get Service Domain.

## Usage
### Advance Preparation
1. Set AWS Credentials
```
$ cp .env.sample .env
$ vi .env
```

2. Create SSH key
```
$ ssh-keygen -t rsa -b 4096 -C "username" (e.g. development)
Enter file in which to save the key (/Users/username/.ssh/id_rsa): {terraform_directory}/{dev,stg,prd}/user_files/.ssh/dev_rsa
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```

### Run
1. Create workspace
```
$ make workspace.new.{dev,stg,prd}
```

2. Secelt workspace
```
$ make workspace.select.{dev,stg,prd}
```

3. Initialize terraform
```
$ make init
```

4. Check plan
```
$ make plan
```

5. Apply
```
$ make apply
```
