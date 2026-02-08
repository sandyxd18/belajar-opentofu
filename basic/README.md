# OpenTofu Basic

## Prerequisite

- [Docker Installed](https://docs.docker.com/engine/install/)
- [OpenTofu Installed](https://opentofu.org/docs/intro/install/)

## Store tfstate to Alarik S3

> [!IMPORTANT]  
> Before running below command, You have to fill the JWT variable on `docker-compose.yml` file with 32 characters.
a. Create container with Docker Compose
```bash
docker compose up -d
```

b. Create a Bucket

Login with `username` and `password` is alarik, Create bucket with name `terraform-state`.
> [!NOTE]  
> You can change the default credential for Alarik trough `docker-compose.yml` file.

c. Create Access Key and Secret Key

Create an Access Key and Secret Key and copy to `backend.tf`

## Getting Started

a. Initialize working directory
```bash
tofu init
```

b. Reformat configuration file
```bash
tofu fmt
```

c. Preview changes before creating
```bash
tofu plan
```

d. Applying the resources
```bash
tofu apply
```
After running that command, you have to type `yes` to confirm the changes, you can bypass that with `tofu apply -auto-approve`.

e. List the state
```bash
tofu state list
```

f. Destroying the resources
```bash
tofu destroy
```
After running that command, you have to type `yes` to confirm the changes, you can bypass that with `tofu destroy -auto-approve`.