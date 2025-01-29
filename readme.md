# Terraform EKS Cluster with Karpenter

This repository contains Terraform code to deploy an **Amazon EKS cluster** with **Karpenter** for autoscaling. The cluster supports both **x86** and **ARM64 (Graviton)** instances, allowing developers to run workloads on the desired architecture.

---

## **Prerequisites**

Before using this repository, ensure you have the following installed and configured:

1. **Terraform**: [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
2. **AWS CLI**: [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) and configure it with your credentials:
   ```bash
   aws configure
   ```
3. **kubectl**: [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
4. **Helm**: [Install Helm](https://helm.sh/docs/intro/install/).

---

## **Deploying the EKS Cluster**

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourtechie/terraform-eks-karpenter.git
   cd terraform-eks-karpenter
   ```

2. **Update Variables**:
   Edit the `variables.tf` file to specify:
   - `vpc_id`: Your existing VPC ID.
   - `subnet_ids`: List of subnet IDs in the VPC.
   - Optionally, customize `cluster_name`, `cluster_version`, and `aws_region`.

3. **Initialize Terraform**:
   ```bash
   terraform init
   ```

4. **Deploy the Cluster**:
   ```bash
   terraform apply
   ```
   Confirm by typing `yes` when prompted. This will create the EKS cluster and deploy Karpenter.

5. **Configure kubectl**:
   Update your `kubeconfig` to access the cluster:
   ```bash
   aws eks --region <region> update-kubeconfig --name <cluster-name>
   ```

6. **Verify the Cluster**:
   Check that the cluster is running:
   ```bash
   kubectl get nodes
   ```

---

## **Running Pods on x86 or Graviton Instances**

Karpenter automatically provisions nodes based on the architecture specified in the pod's `nodeSelector`. Below are examples of how to run pods on **x86** or **ARM64 (Graviton)** instances.

### **1. Run a Pod on x86**

Create a file named `x86-pod.yaml`:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: x86-pod
spec:
  nodeSelector:
    kubernetes.io/arch: amd64
  containers:
    - name: nginx
      image: nginx
```

Apply the manifest:
```bash
kubectl apply -f x86-pod.yaml
```

Verify the pod is running on an x86 node:
```bash
kubectl get pods -o wide
```

---

### **2. Run a Pod on Graviton (ARM64)**

Create a file named `arm64-pod.yaml`:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: arm64-pod
spec:
  nodeSelector:
    kubernetes.io/arch: arm64
  containers:
    - name: nginx
      image: nginx
```

Apply the manifest:
```bash
kubectl apply -f arm64-pod.yaml
```

Verify the pod is running on a Graviton node:
```bash
kubectl get pods -o wide
```

---

## **Cleaning Up**

To destroy the cluster and all associated resources:
```bash
terraform destroy
```
Confirm by typing `yes` when prompted.

---

## **Troubleshooting**

1. **Karpenter Not Creating Nodes**:
   - Check Karpenter logs:
     ```bash
     kubectl logs -n karpenter -l app.kubernetes.io/name=karpenter
     ```
   - Verify the IAM role and permissions for Karpenter.

2. **Pods Stuck in Pending State**:
   - Check events:
     ```bash
     kubectl describe pod <pod-name>
     ```
   - Ensure the node selector matches the provisioner configuration.

3. **Cluster Not Accessible**:
   - Verify your `kubeconfig` is correctly configured:
     ```bash
     aws eks --region <region> update-kubeconfig --name <cluster-name>
     ```

---

This README provides everything you need to deploy the EKS cluster, configure Karpenter, and run workloads on x86 or Graviton instances.