variable "service_account_name" {
    type= string
    description = "Name of Service Account in kubernetes cluster."
}

variable "service_account_namespace" {
    type = string
    default = "kube-system"
    description = "Kubernetes name space where the service account shall be created"
}

variable "policy_files" {
    type = list(string)
    description = "Policy as files. The module shall read from the files to create policy(ies) with policy_name_prefix provided."
}

variable "policy_name_prefix" {
    type = string
    description = "IAM Policy name prefix"
}

variable "iam_role_name" {
    type = string
    description = "IAM role name for AWS account"
}

variable "oidc_provider" {
    type = string
    description = "OIDC provider without https://"
}