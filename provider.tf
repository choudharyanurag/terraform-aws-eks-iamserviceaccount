terraform { 
    required_providers { 
        aws = {
            source = "hashicorp/aws" 
            version = "~>3.21"
        }

        kubernetes = {
            source = "hashicorp/kubernetes"
            version = "~> 2.12"
        }
    }
}