variable "artifact_folder" {
  type        = string
  description = "The folder where the built binaries of your authorizer resides."
  default     = "./.artifacts"
}

variable "name" {
  type        = string
  description = "The name of your authorizer. This must match the name of the binary."
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
    type = string
    description = "The runtime that your code needs."
    default = "go1.x"
}

variable "handler" {
  type = string
  description = "The name of the handler/function/entrypoint in your code to call when the function gets invoked."
  default = local.authorizer_name
}

variable "memory" {
  type        = number
  description = "The memory you wish to assign to the lambda function."
  default     = 256
}

variable "timeout" {
  type        = number
  description = "The maximum amount of time (in seconds) your function is allowed to run."
  default     = 3
}

variable "environment_vars" {
  type        = map(string)
  description = "Environment variables you want to set in the lambda environment."
  default     = {}
}
