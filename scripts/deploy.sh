#!/bin/bash

# Script simple de despliegue
set -e

PROJECT_NAME="serverless-app"
AWS_REGION="us-east-1"

echo "🚀 Desplegando $PROJECT_NAME..."

# Verificar herramientas
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform no encontrado. Instálalo primero."
    exit 1
fi

if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI no encontrado. Instálalo primero."
    exit 1
fi

# Empaquetar Lambda
echo "📦 Empaquetando función..."
mkdir -p temp
cp src/lambda/handler.py temp/
cd temp && zip -r ../infrastructure/lambda_function.zip . && cd ..
rm -rf temp

# Desplegar
echo "🏗️ Desplegando infraestructura..."
cd infrastructure
terraform init
terraform plan -var="project_name=$PROJECT_NAME" -var="aws_region=$AWS_REGION"
terraform apply -auto-approve -var="project_name=$PROJECT_NAME" -var="aws_region=$AWS_REGION"

# Mostrar resultado
API_URL=$(terraform output -raw api_gateway_url)
echo ""
echo "✅ Despliegue completado!"
echo "🌐 API URL: $API_URL"
echo ""
echo "Prueba tu API:"
echo "curl -X POST $API_URL/items -H 'Content-Type: application/json' -d '{\"data\":{\"name\":\"test\"}}'"