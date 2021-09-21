---
id: install
title: Gatekeeper
---
# Gatekeeper Lab Instructions

This repo is a simplified version of the [OPA gatekeeper repo](https://github.com/open-policy-agent/gatekeeper) for the purpose of this lab. Please refer the original repo for more information on advanced configurations. 


## Prerequisites

### Minimum Kubernetes Version

The minimum supported Kubernetes version of Gatekeeper is **n-4 of the latest stable Kubernetes release** per [Kubernetes Supported Versions policy](https://kubernetes.io/releases/version-skew-policy/). NOTE: Gatekeeper requires Kubernetes resources introduced in v1.16.

## Step 1 - RBAC Permissions

For either installation method, make sure you have cluster admin permissions:

```sh
  kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole cluster-admin \
    --user <YOUR USER NAME>
```

## Step2 - Gatekeeper Installation

### Deploying a Release using Prebuilt Image

If you want to deploy a released version of Gatekeeper in your cluster with a prebuilt image, then you can run the following command:

```sh
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.5/deploy/gatekeeper.yaml
```
Validate the installation by listing down the pods under the gatekeeper-system namespace:
```sh
kubectl get pods -n gatekeeper-system
```

## Step3 - Demo script

Run the lab/demo.sh

## Step4 - Cleanup of resources created

Run the lab/cleanup.sh

## Step5 - Gatekeeper Uninstallation

### Using Prebuilt Image

If you used a prebuilt image to deploy Gatekeeper, then you can delete all the Gatekeeper components with the following command:

  ```sh
  kubectl delete -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.5/deploy/gatekeeper.yaml
  ```

