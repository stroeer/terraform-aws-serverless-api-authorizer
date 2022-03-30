variable "artifact_folder" {
  type        = string
  description = "The folder where the built binaries of your authorizer resides."
  default     = "./.artifacts"
}

variable "name" {
  type        = string
  description = "The name of your authorizer. This must match the name of the binary."
  default     = "authorizer"
}

variable "prefix" {
  type        = string
  description = "Adds a prefix to the function name."
  default     = ""
}

variable "suffix" {
  type        = string
  description = "Adds a suffix to the function name."
  default     = ""
}

variable "runtime" {
  type        = string
  description = "The runtime that your code needs to run."
  default     = "go1.x"
}

variable "handler" {
  type        = string
  description = "The name of the handler/function/entrypoint in your code to call when the function gets invoked."
  default     = local.authorizer_name
}

variable "memory" {
  type        = number
  description = "The memory you wish to assign to the lambda function."
  default     = 128
}

variable "timeout" {
  type        = number
  description = "The maximum amount of time (in seconds) your function is allowed to run."
  default     = 2
}

variable "environment_vars" {
  type        = map(string)
  description = "Environment variables you want to set in the lambda environment."
  default     = {}
}

variable "type" {
  type        = string
  description = "The type of authorizer that you want to create."
  default     = "TOKEN"
}

variable "api_id" {
  type        = string
  description = "The id of your api where the authorizer should be registered."
}
