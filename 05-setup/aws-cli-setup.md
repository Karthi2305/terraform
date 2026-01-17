## Install AWS CLI

```bash
sudo apt update
sudo apt install -y awscli

## Configure AWS Credentials

```bash
aws configure

##You will be prompted for:

AWS Access Key ID
AWS Secret Access Key
Default region
Output format

Verify Configuration

```bash
aws sts get-caller-identity
