# Infrastructure as Code with Terraform
## Docker Terraform

### Prerequisites

* The Terraform CLI (1.2.0+) installed.
* Docker

### Structure
```
.
├── terraform.tf --> main file for configuration for aws terraform
└── terraform.tfstate --> keeps the log of variable upon execution of terraform init
```

#### Initialize the project, which downloads a plugin called a provider that lets Terraform interact with Docker.
```
 terraform init
```
#### Provision the NGINX server container with apply. When Terraform asks you to confirm type yes and press ENTER.
```
 terraform apply
```
Verify the existence of the NGINX container by visiting localhost:8000 in your web browser or running docker ps to see the container.

To stop the container, run terraform destroy.
```
 terraform destroy
```
You've now provisioned and destroyed an NGINX webserver with Terraform.

## AWS Terraform

### Prerequisites

* The Terraform CLI (1.2.0+) installed.
* The AWS CLI installed.
* AWS account and associated credentials that allow you to create resources.

### Structure
```
.
├── aws_terraform.tf --> main file for configuration for aws terraform
├── terraform.tfstate --> keeps the log of variable upon execution of terraform init
└── variables.tf --> variables for config files are stored in this file to be read upon execution
```

To use your IAM credentials to authenticate the Terraform AWS provider, set the AWS_ACCESS_KEY_ID environment variable.
```
 export AWS_ACCESS_KEY_ID=
```
Now, set your secret key.
```
 export AWS_SECRET_ACCESS_KEY=
```

To get the AWS_SECRET_ACCESS_KEY, you will need to have an AWS access key ID and access to the AWS Management Console. Here's how to get the AWS_SECRET_ACCESS_KEY:


* Log in to the AWS Management Console and go to the IAM dashboard.

* In the left navigation menu, click on "Users".

* Find the IAM user for which you want to generate an access key and click on their username.

* Click on the "Security credentials" tab.

* In the "Access keys" section, click on "Create access key".

* A new screen will appear with the user's access key ID and secret access key. Make sure to copy the secret access key and save it in a secure location, as it will not be visible again.

Initializing a configuration directory downloads and installs the providers defined in the configuration, which in this case is the aws provider.
```
 terraform init
 ```
The terraform fmt command automatically updates configurations in the current directory for readability and consistency.
```
 terraform fmt
```
Validate your configuration. The example configuration provided above is valid, so Terraform will return a success message.
```
 terraform validate
```
Apply the configuration now with the terraform apply command.
```
 terraform apply
```
Inspect the current state using terraform show.
```
 terraform show
```
Terraform has a built-in command called terraform state for advanced state management. Use the list subcommand to list of the resources in your project's state.
```
 terraform state list
```
Destroy the resources you created.
```
 terraform destroy
```
## Custom Exercise Terraform

### Prerequisites

* The Terraform CLI (1.2.0+) installed.
* The AWS CLI installed.
* AWS account and associated credentials that allow you to create resources.

### Structure
```
.
├── exercise.md --> list of tasks for exercise
└── exercise.tf --> main file for configuration for aws terraform

```
### Note: Export these (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY) first if not configured for aws.

Commands to execute terraform deployment of exercise tasks.
```
terraform init
terraform validate
terraform apply
```