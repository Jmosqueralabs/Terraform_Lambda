# Serverless API con AWS

Una API REST serverless simple y robusta usando AWS.

## ¿Qué hace?
- Recibe requests HTTP y los procesa
- Guarda datos en una base de datos NoSQL
- Incluye monitoreo y logs automáticos
- Maneja errores y reintentos

## Arquitectura
```
Internet → API Gateway → Lambda → DynamoDB
```

## Inicio Rápido

### 1. Prerrequisitos
- AWS CLI configurado
- Terraform instalado
- Permisos de AWS para crear recursos

### 2. Desplegar
```bash
./scripts/deploy.sh
```

### 3. Probar
```bash
./scripts/test-api.sh
```

## Estructura
```
├── src/lambda/          # Código de las funciones
├── infrastructure/      # Configuración de AWS (Terraform)
├── scripts/            # Scripts de despliegue y pruebas
├── config/             # Esquemas de validación
└── docs/              # Documentación
```

## Personalizar

Edita `infrastructure/variables.tf` para cambiar:
- Nombre del proyecto
- Región de AWS
- Configuración de memoria/timeout

## Costos
Aproximadamente $10-15/mes para 1M requests.

## Limpiar
```bash
cd infrastructure
terraform destroy
```

## Documentación
- [Configuración inicial](docs/SETUP.md)