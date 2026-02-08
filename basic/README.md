# 🧱 OpenTofu Basic

This section covers the fundamental steps required to start using **OpenTofu**, including environment setup, remote state configuration, and the basic workflow.

## 📌 Prerequisite

Make sure the following tools are installed on your system:
- [Docker Installed](https://docs.docker.com/engine/install/)
- [OpenTofu Installed](https://opentofu.org/docs/intro/install/)

## 🗄️ Storing `tfstate` in Alarik S3

This lab uses **Alarik S3** as a remote backend to store the OpenTofu state file.

> [!IMPORTANT]  
> Before running any command, make sure to set the `JWT` variable in the `docker-compose.yml` file.  
> The value **must be exactly 32 characters long**.

a. Create container with Docker Compose
```bash
docker compose up -d
```

b. Create a Bucket

- Log in using the default credentials: **Username**: `alarik`, **Password**: `alarik`
- Create a bucket named: `terraform-state`

> [!NOTE]  
> You can change the default Alarik credentials in the `docker-compose.yml` file if needed.

c. Create Access Key

- Generate an Access Key and Secret Key from the Alarik UI.
- Copy both values into the `backend.tf` file.

These credentials will be used by OpenTofu to authenticate with the S3 backend.

## 🚀 Getting Started
Follow the steps below to run your first OpenTofu workflow.

a. Initialize the Working Directory
```bash
tofu init
```
Downloads required providers and initializes the backend.

b. Format Configuration Files
```bash
tofu fmt
```
Automatically formats `.tf` files to follow OpenTofu standards.


c. Preview Infrastructure Changes
```bash
tofu plan
```
Shows an execution plan without making any changes.

d. Apply the Configuration
```bash
tofu apply
```
Type `yes` when prompted to confirm the changes.

To skip confirmation:
```bash
tofu apply -auto-approve
```

e. List Managed Resources
```bash
tofu state list
```
Displays all resources currently tracked in the state file.

f. Destroy the Infrastructure
```bash
tofu destroy
```
Type `yes` when prompted to confirm the changes.

To skip confirmation:
```bash
tofu destroy -auto-approve
```

## ✅ What You’ve Learned

- Running OpenTofu with a remote S3 backend
- Managing infrastructure lifecycle using core OpenTofu commands
- Safely creating, inspecting, and destroying resources