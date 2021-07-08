variable "client_name" {
  description = "Name of client"
  type        = string
}

variable "environment" {
  description = "Name of application's environnement"
  type        = string
}

variable "stack" {
  description = "Name of application stack"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the application ressource group, herited from infra module"
  type        = string
}

variable "location" {
  description = "Azure location for Key Vault."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "name_prefix" {
  description = "Optional prefix for PostgreSQL server name"
  type        = string
  default     = ""
}

variable "custom_server_name" {
  type        = string
  description = "Custom Server Name identifier"
  default     = ""
}

variable "administrator_login" {
  description = "MySQL administrator login"
  type        = string
}

variable "administrator_password" {
  description = "MySQL administrator password. Strong Password: https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017"
  type        = string
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "List of authorized cidrs"
}

variable "allowed_subnets" {
  type        = list(string)
  description = "List of authorized subnet ids"
  default     = []
}

variable "extra_tags" {
  type        = map(string)
  description = "Map of custom tags"
  default     = {}
}

variable "tier" {
  type        = string
  description = <<DESC
Tier for MySQL server sku: https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#tier
Possible values are: GeneralPurpose, Basic, MemoryOptimized.
DESC
  default     = "GeneralPurpose"
}

variable "capacity" {
  type        = number
  description = "Capacity for MySQL server sku: https://www.terraform.io/docs/providers/azurerm/r/mysql_server.html#capacity"
  default     = 4
}

variable "auto_grow_enabled" {
  description = "Enable/Disable auto-growing of the storage."
  type        = bool
  default     = false
}

variable "storage_mb" {
  description = "Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs."
  type        = number
  default     = 5120
}

variable "backup_retention_days" {
  description = "Backup retention days for the server, supported values are between 7 and 35 days."
  type        = number
  default     = 10
}

variable "geo_redundant_backup_enabled" {
  description = "Turn Geo-redundant server backups on/off. Not available for the Basic tier."
  type        = bool
  default     = true
}

variable "mysql_options" {
  type        = list(map(string))
  default     = []
  description = "List of configuration options: https://docs.microsoft.com/fr-fr/azure/mysql/howto-server-parameters#list-of-configurable-server-parameters"
}

variable "mysql_version" {
  type        = string
  default     = "5.7"
  description = "Valid values are 5.6 and 5.7"
}

variable "force_ssl" {
  type        = bool
  default     = true
  description = "Force usage of SSL"
}

variable "databases_names" {
  description = "List of databases names"
  type        = list(string)
}

variable "databases_charset" {
  type        = map(string)
  description = "Valid mysql charset: https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html"
  default     = {}
}

variable "databases_collation" {
  type        = map(string)
  description = "Valid mysql collation: https://dev.mysql.com/doc/refman/5.7/en/charset-charsets.html"
  default     = {}
}

variable "enable_user_suffix" {
  description = "True to append a _user suffix to database users"
  type        = bool
  default     = true
}

variable "logs_destinations_ids" {
  type        = list(string)
  description = "List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging."
}

variable "logs_categories" {
  type        = list(string)
  description = "Log categories to send to destinations."
  default     = null
}

variable "logs_metrics_categories" {
  type        = list(string)
  description = "Metrics categories to send to destinations."
  default     = null
}

variable "logs_retention_days" {
  type        = number
  description = "Number of days to keep logs on storage account"
  default     = 30
}
