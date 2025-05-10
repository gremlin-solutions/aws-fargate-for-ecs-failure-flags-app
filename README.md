# AWS ECS Fargate Deployment with Gremlin Failure Flags

This repository provides Terraform configuration for deploying an application to AWS Elastic Container Service (ECS) using AWS Fargate. It includes an example integration of Gremlin's Failure Flags SDK to simulate faults and perform chaos engineering experiments within your ECS workloads.


## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Project Structure](#project-structure)
4. [Setup](#setup)
5. [Deploying the Infrastructure](#deploying-the-infrastructure)
6. [Application Deployment](#application-deployment)
7. [Integrating Gremlin Failure Flags](#integrating-gremlin-failure-flags)
8. [Outputs](#outputs)
9. [Cleanup](#cleanup)
10. [License](#license)

## Overview

The Terraform configuration creates the following AWS resources:

* ECS Cluster
* ECS Task Definition and Service
* Application Load Balancer (ALB)
* Security Groups and Networking (VPC, Subnets, Internet Gateway)
* CloudWatch Log Groups

The ECS task includes:

* An application container (Python Flask app).
* Gremlin Failure Flags sidecar container.

## Prerequisites

* AWS Account
* Terraform CLI (\~> 1.5.7)
* Docker CLI
* Python 3.9 or higher
* Gremlin account and credentials (team ID, certificate, private key)

## Project Structure

```
.
├── Dockerfile
├── app.py
├── behaviors.py
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── providers.tf
├── requirements.txt
└── README.md
```

## Setup

1. Clone this repository.
2. Set Gremlin credentials in files:

   * `gremlin_team_id.txt`
   * `gremlin_team_certificate.pem`
   * `gremlin_team_private_key.pem`

## Deploying the Infrastructure

Navigate to the Terraform directory:

```bash
terraform init
terraform plan
terraform apply
```

This deploys the required AWS infrastructure.

## Application Deployment

Build and push the Docker image to your container registry:

```bash
docker build -t <your-repo>/s3-failure-flags-app:latest .
docker push <your-repo>/s3-failure-flags-app:latest
```

Update `app_image` variable in `variables.tf` accordingly.

## Integrating Gremlin Failure Flags

The application integrates Gremlin's Failure Flags SDK for fault injection. Modify behaviors in `behaviors.py` and utilize experiments to inject faults, such as HTTP errors or latency.

## Outputs

Terraform outputs:

* **Load Balancer DNS**: Access your application at the provided DNS URL.
* **ECS Cluster Name**: For reference or further integrations.

## Cleanup

Remove the AWS resources:

```bash
terraform destroy
```
