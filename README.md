# terraform-aws-eks-iamserviceaccount

Terraform module for creating AWS IAM Service Account on Kubernetes Cluster. 
The motivation behind writing this module is many a times, we need to create IAM Service Accounts, for example Cluster Auto Scaler, ALB Ingress Controller etc. 

The Official AWS documentation states to use EKSCTL and AWS CLI to create them. 

This module is a sincere try to make that happen at terraform code.

## Module Requirements 

This module is created using 
- AWS providers ~>3.21 (It should run well with any AWS module version till 4.x) 
- Kubernetes Provider 2.12 

## Resources

The following is the step by step execution plan: 

- This module shall create IAM Policy(ies) by reading policy files (Use should provide them as a `list(string)` of file names to variables). Policy name is prefixed with input provided to module variables.
- A role shall be created there after (Input is a `string` as Role name).
- All the Policies created are then attached to the Role.
- Finally it will create a Service Account in the given namespace of kubernetes cluster. Defaults to `kube-system`

## How to use?

It shall use the variables provided in variables.tf
Now the user should : 
- Set the variables 
- Create Providers and pass from caller module. 

The following example shows how to forward a provied from a caller module right after creating the eks cluster:

``` terraform

data "aws_eks_cluster_auth" "cluster_auth" {
    name = aws_eks_cluster.cluster.name
}

provider "kubernetes" {
    alias                   = "my_new_cluster" 

    host                    = join ("", aws_eks_cluster.cluster.*.endpoint)
    cluster_ca_certificate  = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)

    exec {
        api_version = "client.authentication.k8s.io/v1alpha1"
        args        = ["eks", "get-token", "--cluster-name", "aws_eks_cluster.cluster.name ]
        command     = "aws"
    }
}


module "eks_iam_service_account" {
    source = <github_url>

    depends_on = [aws_eks_cluster.cluster]

    # SET VARIABLES HERE

    service_account_namespace   = "stringVariable"
    policy_files                = ["${path.module}/policy1.json", "${path.module}/policy2.json" ] # list(string)
    policy_name_prefix          = "stringVariable-policy-name-prefix"
    iam_role_name               = "stringVariable" 
    oidc_provider               = trimprefix (aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://")
    service_account_name        = "stringVariable" # e.g. "aws-load-balancer-controller" 
    # SET PROVIDER 

    providers = { 
        kubernetes.my_new_cluster
    }

}

```


