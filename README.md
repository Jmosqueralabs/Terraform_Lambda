# Proyecto Serverless AWS - Arquitectura Mínima

Una implementación completa de arquitectura serverless siguiendo las mejores prácticas de AWS, diseñada para ser escalable, segura y cost-effective.

## 🏗️ Arquitectura

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   API Gateway   │───▶│     Lambda      │───▶│    DynamoDB     │
│   (HTTP API)    │    │   (Handler)     │    │ (Single Table)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   CloudWatch    │    │     X-Ray       │    │      KMS        │
│ (Logs/Metrics)  │    │   (Tracing)     │    │  (Encryption)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │
         ▼
┌─────────────────┐    ┌─────────────────┐
│      SQS        │    │ Secrets Manager │
│  (Queue + DLQ)  │    │ (Credentials)   │
└─────────────────┘    └─────────────────┘
```

### 🔧 Componentes Principales
- **API Gateway HTTP API**: Punto de entrada con throttling y CORS
- **Lambda Functions**: Procesamiento síncrono y asíncrono
- **DynamoDB**: Base de datos NoSQL con single-table design
- **CloudWatch**: Observabilidad completa (logs, métricas, alarmas)
- **X-Ray**: Trazabilidad distribuida end-to-end
- **SQS + DLQ**: Procesamiento asíncrono con manejo de fallos
- **KMS**: Cifrado de datos en reposo
- **Secrets Manager**: Gestión segura de credenciales

## 📋 Requerimientos

### Herramientas Obligatorias

#### 1. Terraform (>= 1.0)
```bash
# Ubuntu/Debian
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# macOS
brew install terraform

# Windows
choco install terraform

# Verificar instalación
terraform --version
```

#### 2. AWS CLI (>= 2.0)
```bash
# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install

# macOS
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# Windows
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

# Verificar instalación
aws --version
```

#### 3. Herramientas del Sistema
```bash
# Ubuntu/Debian
sudo apt-get install zip curl jq

# macOS
brew install zip curl jq

# Windows (PowerShell como administrador)
# zip viene incluido en Windows 10+
# curl viene incluido en Windows 10+
```

### Configuración AWS

#### 1. Credenciales AWS
```bash
# Configurar credenciales
aws configure
# AWS Access Key ID: [tu-access-key]
# AWS Secret Access Key: [tu-secret-key]  
# Default region name: us-east-1
# Default output format: json

# Verificar configuración
aws sts get-caller-identity
```

#### 2. Permisos IAM Requeridos
Tu usuario/rol de AWS debe tener los siguientes permisos:

**Servicios Core:**
- `iam:*` (crear roles y políticas)
- `lambda:*` (gestionar funciones Lambda)
- `apigateway:*` (crear y configurar API Gateway)
- `dynamodb:*` (crear y gestionar tablas)

**Observabilidad:**
- `logs:*` (CloudWatch Logs)
- `cloudwatch:*` (métricas y alarmas)
- `xray:*` (trazabilidad)

**Seguridad:**
- `kms:*` (gestión de claves de cifrado)
- `secretsmanager:*` (gestión de secretos)

**Mensajería:**
- `sqs:*` (colas SQS)
- `sns:*` (notificaciones)

**Ejemplo de política IAM mínima:**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:*",
                "lambda:*",
                "apigateway:*",
                "dynamodb:*",
                "logs:*",
                "cloudwatch:*",
                "xray:*",
                "kms:*",
                "secretsmanager:*",
                "sqs:*",
                "sns:*"
            ],
            "Resource": "*"
        }
    ]
}
```

### Costos Estimados

**Escenario: 1M requests/mes**
- API Gateway: ~$3.50/mes
- Lambda (512MB, 200ms avg): ~$2.00/mes  
- DynamoDB (On-Demand): ~$1.25/mes
- CloudWatch (logs + métricas): ~$5.00/mes
- **Total estimado: ~$12/mes**

## 📁 Estructura del Proyecto

```
├── .gitignore                    # Archivos ignorados por Git
├── README.md                     # Este archivo
├── src/                          # Código fuente
│   └── lambda/
│       ├── handler.py           # Lambda principal (HTTP API)
│       └── sqs_handler.py       # Lambda procesador SQS
├── infrastructure/               # Infraestructura como código
│   ├── main.tf                  # Recursos principales
│   ├── variables.tf             # Variables de configuración
│   ├── outputs.tf               # Outputs del despliegue
│   ├── monitoring.tf            # CloudWatch y alarmas
│   └── sqs.tf                   # SQS y procesamiento asíncrono
├── config/                       # Configuraciones
│   └── api-schema.json          # Esquema de validación API
├── scripts/                      # Scripts de automatización
│   ├── deploy.sh                # Script de despliegue
│   └── test-api.sh              # Script de pruebas
└── docs/                         # Documentación
    ├── ARCHITECTURE.md          # Documentación de arquitectura
    └── DEPLOYMENT.md            # Guía de despliegue detallada
```

## 🚀 Inicio Rápido

### 1. Clonar y Configurar
```bash
# Clonar el repositorio
git clone <tu-repo>
cd serverless-aws-project

# Hacer ejecutables los scripts
chmod +x scripts/*.sh
```

### 2. Despliegue Automático
```bash
# Desplegar toda la infraestructura
./scripts/deploy.sh
```

### 3. Probar la API
```bash
# Ejecutar suite de pruebas
./scripts/test-api.sh
```

## 🔧 Configuración Personalizada

### Variables de Entorno
Crear archivo `infrastructure/terraform.tfvars`:

```hcl
project_name = "mi-aplicacion"
environment  = "dev"
aws_region   = "us-east-1"
owner        = "mi-equipo"

# Configuración Lambda
lambda_memory_size = 512
lambda_timeout     = 10

# Configuración DynamoDB  
dynamodb_billing_mode = "ON_DEMAND"
```

### Despliegue por Ambiente
```bash
# Desarrollo
terraform apply -var="environment=dev"

# Staging  
terraform apply -var="environment=staging"

# Producción
terraform apply -var="environment=prod"
```

## 📊 Monitoreo y Observabilidad

### Dashboard CloudWatch
Después del despliegue, accede al dashboard:
```
https://console.aws.amazon.com/cloudwatch/home#dashboards
```

### Logs en Tiempo Real
```bash
# Logs de Lambda principal
aws logs tail "/aws/lambda/serverless-app-handler" --follow

# Logs de API Gateway
aws logs tail "/aws/apigateway/serverless-app" --follow
```

### Métricas Clave
- **Latencia API**: < 500ms p95
- **Errores**: < 1% tasa de error
- **Disponibilidad**: > 99.9%
- **Cold Starts**: < 2s p99

## 🛡️ Características de Seguridad

- ✅ **Cifrado en reposo**: KMS para DynamoDB, logs y SQS
- ✅ **IAM Least Privilege**: Permisos mínimos necesarios
- ✅ **Validación de entrada**: JSON Schema en API Gateway
- ✅ **Logs estructurados**: Para auditoría y debugging
- ✅ **Secrets Management**: Credenciales en Secrets Manager
- ✅ **Network Security**: Sin VPC por defecto (menor superficie de ataque)

## 🔄 Patrones Implementados

### Idempotencia
```json
{
  "idempotencyKey": "unique-key-123",
  "data": { ... }
}
```

### Single-Table Design
```
PK: ITEM#<id>     SK: METADATA#<timestamp>
PK: EVENT#<id>    SK: USER#<userId>
PK: EVENT#<id>    SK: SYSTEM#<date>
```

### Logs Estructurados
```json
{
  "event": "request_start",
  "correlationId": "uuid-123",
  "requestId": "aws-request-id",
  "timestamp": "2024-01-01T12:00:00Z"
}
```

## 🚨 Troubleshooting

### Errores Comunes

**1. "Access Denied"**
```bash
# Verificar permisos
aws iam get-user
aws sts get-caller-identity
```

**2. "Lambda Timeout"**
```bash
# Aumentar timeout en variables.tf
variable "lambda_timeout" { default = 30 }
```

**3. "DynamoDB Throttling"**
```bash
# Cambiar a modo Provisioned
variable "dynamodb_billing_mode" { default = "PROVISIONED" }
```

## 🧹 Cleanup

```bash
# Destruir toda la infraestructura
cd infrastructure
terraform destroy

# Limpiar archivos locales
rm -f *.zip *.tfstate* 
rm -rf .terraform/
```

## 📚 Documentación Adicional

- [Arquitectura Detallada](docs/ARCHITECTURE.md)
- [Guía de Despliegue](docs/DEPLOYMENT.md)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## 🤝 Contribución

1. Fork el proyecto
2. Crear feature branch (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -am 'Añadir nueva funcionalidad'`)
4. Push al branch (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 🆘 Soporte

- **Issues**: [GitHub Issues](https://github.com/tu-usuario/tu-repo/issues)
- **Documentación**: [Wiki del proyecto](https://github.com/tu-usuario/tu-repo/wiki)
- **AWS Support**: [AWS Support Center](https://console.aws.amazon.com/support/)