# Azure Edge infrastructure

- Login with Azure user 
  ```
  az login
  ```
- Check for available subscriptions
  ```
  az account list --output table
  ```
  example output:
  ```
  Name  CloudName    SubscriptionId                        State    IsDefault
  ----  -----------  ------------------------------------  -------  -----------
  dev   AzureCloud   17uav552-365d-1c22-0952-1g27q19t9np1  Enabled  True
  prod  AzureCloud   97ofa095-941h-0n54-8562-7f96d7713br0  Enabled  False
  ```
- If multiple subscriptions exist and the required subscription is not the default, run the following command to set the subscription context
  ```
  az account set --subscription "prod"
  ```
- Initialize terraform
  ```
  terraform init
  ```
- Run terraform apply with the correct terraform variable file
  ```
  terraform apply -var-file=pluto.tfvars
  ```
