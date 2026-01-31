# Web application 👨🏾‍💻

This terraform code deploys a web application on an EC2 instance that connects to an RDS MySQL database. The application retrieves database credentials from AWS Secrets Manager using an IAM role attached to the EC2 instance.

⚠️ Its best practice to enable an organizational wide AWS Secrets Manager for credential rotation in your work stack and not hardcoding your credentials in your RDS or your terraform file. Secrets manager has a recovery window after deletion, use unique naming when naming your secrets. Secrets manager will lower an organizations attack surface.

# Terraform Commands 🏗️
```bash
terraform init 
terraform fmt -recursive
terraform plan
terraform apply 
```
# Test application from inside EC2 📈

```bash 
curl -i http://localhost/init
```

# To verify flask is listening on port 80 👂🏾

```bash 
sudo ss -tulpn | grep :80
sudo lsof -i :80
```

