# Deploying EKS cluster with Terraform

## Installation Procedure (performed in Fedora 35):

First we need to locally install some prequisites including terraform, kubectl, helm and aws cli. We need these tools to build, configure and provision NextCloud to an EKS cluster.
### Install Terraform:
```
sudo dnf install terraform
```

### Install kubectl:
```
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo yum install -y kubectl
```

### Install Helm:
```
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
```

### Prepare AWS (aws cli is preinstalled in Fedora):
```
export AWS_ACCESS_KEY_ID="<YOUR_AWS_ACCESS_KEY_ID>"
export AWS_SECRET_ACCESS_KEY="<YOUR_AWS_SECRET_ACCESS_KEY>"
export AWS_SESSION_TOKEN
```

### Initialize and provision EKS cluster:
```
terraform init
terraform plan
terraform apply
```
### Automatically configure kubectl:
```
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
```

# Installing NextCloud in EKS Cluster

### Add nextcloud repo and install NextCloud:
```
helm repo add nextcloud https://nextcloud.github.io/helm/
helm install my-release nextcloud/nextcloud
```

### Run commands in the output of NextCloud install:
```
export APP_HOST=127.0.0.1
export APP_PASSWORD=$(kubectl get secret --namespace default my-release-nextcloud -o jsonpath="{.data.nextcloud-password}" | base64 --decode)
```

### Use kubectl to verify the name of the deployment and configure port forwarding so NextCloud deployment can be accessed at http://127.0.0.1:8080
```
kubectl get deployments
kubectl port-forward deployment/<YOUR_DEPLOYMENT_NAME> 8080:80
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.20.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.1 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.1.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.71.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 17.24.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.all_worker_mgmt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.worker_group_mgmt_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.worker_group_mgmt_frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_desired_capacity"></a> [backend\_desired\_capacity](#input\_backend\_desired\_capacity) | (optional) describe your variable | `string` | `1` | no |
| <a name="input_backend_instance_type"></a> [backend\_instance\_type](#input\_backend\_instance\_type) | backend instance type | `string` | `"t2.micro"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | `"primary"` | no |
| <a name="input_frontend_desired_capacity"></a> [frontend\_desired\_capacity](#input\_frontend\_desired\_capacity) | (optional) describe your variable | `string` | `1` | no |
| <a name="input_frontend_instance_type"></a> [frontend\_instance\_type](#input\_frontend\_instance\_type) | frontend instance type | `string` | `"t2.micro"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | (optional) describe your variable | `string` | `"1.21"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for EKS control plane. |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | EKS cluster ID. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Kubernetes Cluster Name |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | Security group ids attached to the cluster control plane. |
| <a name="output_config_map_aws_auth"></a> [config\_map\_aws\_auth](#output\_config\_map\_aws\_auth) | A kubernetes configuration to authenticate to this EKS cluster. |
| <a name="output_kubectl_config"></a> [kubectl\_config](#output\_kubectl\_config) | kubectl config as generated by the module. |
| <a name="output_region"></a> [region](#output\_region) | AWS region |
