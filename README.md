# Terraform GKE and Flux Bootstrap

This project uses Terraform to create a Kubernetes cluster on Google Kubernetes Engine (GKE), set up a Github repository to store Kubernetes manifests, and bootstrap the cluster using Flux.

## Pre-requisites

- Terraform installed (version >= 1.0.3)
- Google Cloud Platform account
- Github account

## Configuration

Copy the `terraform.tfvars.example` file to `terraform.tfvars` and update the values to match your configuration.

## Terraform modules used

### `hashicorp-tls-keys`

This module creates a TLS private key and self-signed certificate. It exports the private key in PEM format and the public key in OpenSSH format.

### `google-gke-cluster`

This module creates a Kubernetes cluster on GKE, with a specified number of nodes.

### `github-repository`

This module creates a private Github repository and a deploy key. The public key is passed from the `hashicorp-tls-keys` module.

### `fluxcd-flux-bootstrap`

This module installs Flux in the Kubernetes cluster and sets it up to read manifests from the Github repository created by the `github-repository` module. It also generates a private key for Flux to use to authenticate with Github.

## Usage

```shell
terraform init
terraform apply
```
## License
MIT License. See LICENSE for full details.