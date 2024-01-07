## Infrastructure as Code (IaC) Repository
This repository contains Infrastructure as Code (IaC) configurations to automate the provisioning and management of AWS resources for deploying applications on EKS, setting up CI/CD pipelines with Jenkins, and configuring monitoring using Prometheus and Grafana.

### Directory Structure:

**/ eks-infra**

The */eks-infra* directory houses Terraform scripts responsible for orchestrating the infrastructure setup on AWS. Key components include:

* EKS Cluster: Scripts to provision and manage the EKS cluster, including configurations for node groups, worker nodes, and Kubernetes control plane.
* Networking: Terraform configurations for VPC setup, subnets, route tables, and internet gateways.
* Security Groups and IAM Roles: Definitions for managing security groups and IAM roles necessary for various components.

**/ jenkins-infra**

In the /jenkins-infra directory, you'll find Jenkins configurations facilitating Continuous Integration and Continuous Deployment (CI/CD) processes:

* Jenkinsfile: Pipeline script defining the steps and stages of the CI/CD pipeline.
* Pipeline Scripts: Additional scripts or configurations utilized within the Jenkins pipeline.
* Job Configurations: Definitions for specific Jenkins jobs related to deployment, testing, or other CI/CD tasks.

**/ monitoring-infra**

The /monitoring-infra directory contains configurations for setting up monitoring tools:

* Prometheus Setup: YAML files and configurations required for deploying and configuring Prometheus for collecting metrics.
* Grafana Configuration: Definitions and dashboards used to visualize data collected by Prometheus.

## Getting Started:
1. Terraform Setup: Ensure you have Terraform installed and configured.
2. AWS Credentials: Set up appropriate AWS credentials with necessary permissions.
3. Deployment: Follow instructions within each directory to deploy the corresponding infrastructure components.

## Usage:
Modify Terraform scripts in **_/eks-infra_** to suit your infrastructure requirements.
Customize Jenkins configurations in **_/jenkins-infra_** to match your CI/CD workflow.
Adapt monitoring configurations in **_/monitoring-infra_** to monitor your application metrics effectively.


