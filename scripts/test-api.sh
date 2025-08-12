#!/bin/bash

# Script simple para probar la API
set -e

# Obtener URL de la API
cd infrastructure
API_URL=$(terraform output -raw api_gateway_url 2>/dev/null || echo "")
cd ..

if [ -z "$API_URL" ]; then
    echo "❌ API no encontrada. ¿Ejecutaste ./scripts/deploy.sh?"
    exit 1
fi

echo "🧪 Probando API: $API_URL"
echo ""

# Test 1: Crear item
echo "📝 Creando item..."
curl -X POST "$API_URL/items" \
    -H "Content-Type: application/json" \
    -d '{
        "idempotencyKey": "test-123",
        "data": {
            "name": "Producto de Prueba",
            "description": "Item de prueba"
        }
    }'
echo ""

# Test 2: Obtener item
echo "📖 Obteniendo item..."
curl -X GET "$API_URL/items/test-123"
echo ""

# Test 3: Idempotencia
echo "🔄 Probando idempotencia..."
curl -X POST "$API_URL/items" \
    -H "Content-Type: application/json" \
    -d '{
        "idempotencyKey": "test-123",
        "data": {
            "name": "Esto debería ser ignorado"
        }
    }'
echo ""

echo "✅ Pruebas completadas"