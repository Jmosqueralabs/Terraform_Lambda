# Serverless API con AWS

Una API REST serverless simple usando **Terraform** para desplegar en AWS.

## ¿Qué incluye?
- **API Gateway**: Recibe requests HTTP
- **Lambda**: Procesa la lógica de negocio  
- **DynamoDB**: Guarda los datos
- **CloudWatch**: Logs automáticos

## Arquitectura
```
Internet → API Gateway → Lambda → DynamoDB
```

## Cómo funciona el despliegue

Este proyecto usa **Terraform** para crear toda la infraestructura en AWS automáticamente:

1. **Script de despliegue** (`./scripts/deploy.sh`):
   - Empaqueta el código Python en un ZIP
   - Ejecuta `terraform apply` para crear los recursos
   - Te da la URL de tu API lista para usar

2. **Recursos que crea Terraform**:
   - Tabla DynamoDB
   - Función Lambda
   - API Gateway con rutas GET/POST
   - Roles IAM con permisos mínimos
   - CloudWatch Logs

## Inicio Rápido

### 1. Prerrequisitos
```bash
# Instalar Terraform
brew install terraform  # macOS
apt-get install terraform  # Ubuntu
# o descargar desde: https://terraform.io

# Instalar AWS CLI  
brew install awscli     # macOS
apt-get install awscli  # Ubuntu
# o descargar desde: https://aws.amazon.com/cli/

# Configurar AWS
aws configure
```

### 2. Desplegar paso a paso

#### Opción A: Comandos manuales (recomendado)
```bash
# 1. Empaquetar la función Lambda
mkdir -p temp
cp src/lambda/handler.py temp/
cd temp && zip -r ../infrastructure/lambda_function.zip . && cd ..
rm -rf temp

# 2. Ir al directorio de infraestructura
cd infrastructure

# 3. Inicializar Terraform
terraform init

# 4. Ver qué se va a crear
terraform plan

# 5. Crear los recursos en AWS
terraform apply

# 6. Ver la URL de tu API
terraform output api_gateway_url
```

#### Opción B: Script automático (si lo anterior no funciona)
```bash
./scripts/deploy.sh
```

### 3. Probar tu API

#### Opción A: Comandos manuales
```bash
# Obtener la URL de tu API
cd infrastructure
API_URL=$(terraform output -raw api_gateway_url)
echo "Tu API está en: $API_URL"

# Crear un item
curl -X POST "$API_URL/items" \
  -H "Content-Type: application/json" \
  -d '{
    "idempotencyKey": "test-123",
    "data": {
      "name": "Producto de Prueba",
      "description": "Mi primer item"
    }
  }'

# Obtener el item
curl -X GET "$API_URL/items/test-123"

# Probar idempotencia (debería devolver "already_exists")
curl -X POST "$API_URL/items" \
  -H "Content-Type: application/json" \
  -d '{
    "idempotencyKey": "test-123",
    "data": {
      "name": "Esto debería ser ignorado"
    }
  }'
```

#### Opción B: Script automático
```bash
./scripts/test-api.sh
```

## Estructura del proyecto
```
├── src/lambda/handler.py       # Código Python de la Lambda
├── infrastructure/             # Archivos Terraform
│   ├── main.tf                # Recursos principales (DynamoDB, Lambda, API)
│   ├── variables.tf           # Variables configurables
│   └── outputs.tf             # URLs y nombres de recursos
├── scripts/
│   ├── deploy.sh              # Script que ejecuta Terraform
│   └── test-api.sh            # Pruebas de la API
└── config/api-schema.json     # Validación de requests
```

## Ejemplo de uso

Una vez desplegado, puedes usar tu API así:

```bash
# Crear un item
curl -X POST https://tu-api-url/items \
  -H "Content-Type: application/json" \
  -d '{
    "idempotencyKey": "mi-item-123",
    "data": {
      "name": "Mi producto",
      "description": "Descripción del producto"
    }
  }'

# Obtener el item
curl https://tu-api-url/items/mi-item-123
```

## Personalizar

### Cambiar configuración
Edita `infrastructure/variables.tf`:
```hcl
variable "project_name" {
  default = "mi-app"  # Cambia el nombre
}

variable "aws_region" {
  default = "us-west-2"  # Cambia la región
}

variable "lambda_memory_size" {
  default = 1024  # Más memoria = más rápido
}
```

### Desplegar cambios
```bash
./scripts/deploy.sh  # Terraform detecta y aplica cambios
```

## Comandos útiles

### Ver qué recursos tienes
```bash
cd infrastructure
terraform show
```

### Ver logs de Lambda en tiempo real
```bash
aws logs tail "/aws/lambda/serverless-app-handler" --follow
```

### Actualizar cambios
Si modificas el código o configuración:
```bash
# Re-empaquetar Lambda
mkdir -p temp
cp src/lambda/handler.py temp/
cd temp && zip -r ../infrastructure/lambda_function.zip . && cd ..
rm -rf temp

# Aplicar cambios
cd infrastructure
terraform apply
```

### Destruir todo
```bash
cd infrastructure
terraform destroy  # Elimina todos los recursos de AWS
```

## Troubleshooting

### Si algo no funciona:

1. **Verificar credenciales AWS**:
```bash
aws sts get-caller-identity
```

2. **Verificar permisos**:
Tu usuario AWS necesita permisos para crear:
- Lambda functions
- DynamoDB tables  
- API Gateway
- IAM roles
- CloudWatch logs

3. **Limpiar y reintentar**:
```bash
cd infrastructure
rm -rf .terraform/
rm terraform.tfstate*
terraform init
terraform apply
```

4. **Usar el script como respaldo**:
```bash
./scripts/deploy.sh
```

## Costos estimados
- **Desarrollo**: ~$2-5/mes
- **Producción (100K requests)**: ~$8-12/mes

## Documentación
- [Configuración inicial](docs/SETUP.md)
