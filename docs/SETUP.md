# Configuración Inicial

## Instalar Herramientas

### 1. Terraform
```bash
# macOS
brew install terraform

# Ubuntu/Debian
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Windows
choco install terraform
```

### 2. AWS CLI
```bash
# macOS
brew install awscli

# Ubuntu/Debian
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install

# Windows
# Descargar desde: https://aws.amazon.com/cli/
```

## Configurar AWS

### 1. Crear usuario IAM
1. Ve a AWS Console → IAM → Users
2. Crear nuevo usuario
3. Asignar política: `AdministratorAccess` (para simplificar)
4. Guardar Access Key y Secret Key

### 2. Configurar credenciales
```bash
aws configure
# AWS Access Key ID: [tu-access-key]
# AWS Secret Access Key: [tu-secret-key]
# Default region name: us-east-1
# Default output format: json
```

### 3. Verificar
```bash
aws sts get-caller-identity
```

## Personalizar Proyecto

Edita `infrastructure/variables.tf`:
```hcl
variable "project_name" {
  default = "mi-app"  # Cambia esto
}

variable "aws_region" {
  default = "us-east-1"  # Cambia si quieres otra región
}
```

## Costos Esperados
- Desarrollo/Testing: ~$5-10/mes
- Producción (1M requests): ~$15-20/mes