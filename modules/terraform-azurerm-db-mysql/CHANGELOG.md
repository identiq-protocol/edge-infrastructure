# v3.2.0/v4.2.0 - 2021-06-07

Breaking
  * AZ-160: Unify diagnostics settings on all Claranet modules

# v3.1.1/v4.1.1 - 2021-03-09

Fixed
  * AZ-461: Remove sensitive attribute on databases users output

# v3.1.0/v4.1.0 - 2021-01-08

Changed
  * AZ-398: Force lowercase on default generated name

# v3.0.1/v4.0.0 - 2020-11-18

Changed
  * AZ-273: Update README and CI, module compatible Terraform 0.13+ (now requires Terraform 0.12.26 minimum version)

# v3.0.0 - 2020-07-27

Breaking
  * AZ-198: Upgrade for compatibility AzureRM 2.0

# v2.4.0 - 2020-07-09

Changed
  * AZ-206: Pin version AzureRM provider to be usable < 2.0
  * AZ-209: Update CI with Gitlab template

Added
  * AZ-230: Add auto-grow parameter on `storage_profile` block

# v2.3.0 - 2020-03-27

Changed
  * AZ-202: use `sku_name` string parameter instead of deprecated `sku` map parameter

# v2.2.0 - 2020-02-11

Breaking
  * AZ-166: Use `random_password` instead of `random_string` for passwords generation: **this changes the generated value or need manual state edition**

Changed
  * AZ-182: Allow no `_user` suffix

# v2.1.0 - 2019-12-18

Changed
  * AZ-149: Improve VNet rules use and fix output

# v2.0.0 - 2019-11-25

Breaking
  * AZ-94: Terraform 0.12 / HCL2 format

Added
  * AZ-128: Create databases users
  * AZ-118: Add LICENSE, NOTICE & Github badges
  * AZ-119: Revamp README and publish this module to Terraform registry
  * AZ-119: Add CONTRIBUTING.md doc and `terraform-wrapper` usage with the module

# v0.1.0 - 2019-07-02

Added
  * AZ-44 + TER-306: First release

