import json
import boto3
import uuid
import logging
import os
from datetime import datetime, timedelta
from botocore.exceptions import ClientError

# Configuración básica
logger = logging.getLogger()
logger.setLevel(logging.INFO)
dynamodb = boto3.resource('dynamodb')

# Obtener nombre de tabla desde variable de entorno
TABLE_NAME = os.environ.get('TABLE_NAME', 'serverless-app-table')

def lambda_handler(event, context):
    """
    Procesa requests HTTP y los guarda en DynamoDB
    """
    try:
        # Validar que hay datos
        if not event.get('body'):
            return create_response(400, {"error": "Body requerido"})
        
        body = json.loads(event['body'])
        http_method = event.get('httpMethod', 'GET')
        
        # Procesar según el método
        if http_method == 'POST':
            result = create_item(body)
        elif http_method == 'GET':
            item_id = event.get('pathParameters', {}).get('id')
            result = get_item(item_id)
        else:
            return create_response(405, {"error": "Método no permitido"})
        
        return create_response(200, result)
        
    except json.JSONDecodeError:
        return create_response(400, {"error": "JSON inválido"})
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        return create_response(500, {"error": "Error interno"})

def create_item(data):
    """
    Crear un nuevo item en DynamoDB
    """
    table = dynamodb.Table(TABLE_NAME)
    
    # Usar clave de idempotencia o generar una nueva
    item_id = data.get('idempotencyKey', str(uuid.uuid4()))
    
    item = {
        'PK': f"ITEM#{item_id}",
        'SK': f"METADATA#{datetime.utcnow().isoformat()}",
        'data': data,
        'createdAt': datetime.utcnow().isoformat(),
        'ttl': int((datetime.utcnow() + timedelta(days=30)).timestamp())
    }
    
    try:
        # Evitar duplicados
        table.put_item(
            Item=item,
            ConditionExpression='attribute_not_exists(PK)'
        )
        return {"id": item_id, "status": "created"}
        
    except ClientError as e:
        if e.response['Error']['Code'] == 'ConditionalCheckFailedException':
            return {"id": item_id, "status": "already_exists"}
        raise

def get_item(item_id):
    """
    Obtener un item por ID
    """
    if not item_id:
        return {"error": "ID requerido"}
    
    table = dynamodb.Table(TABLE_NAME)
    
    try:
        # Buscar el item más reciente para este ID
        response = table.query(
            KeyConditionExpression='PK = :pk',
            ExpressionAttributeValues={':pk': f"ITEM#{item_id}"},
            ScanIndexForward=False,  # Orden descendente por SK
            Limit=1
        )
        
        if not response['Items']:
            return {"error": "Item no encontrado"}
        
        return response['Items'][0]['data']
        
    except ClientError as e:
        logger.error(f"Error DynamoDB: {str(e)}")
        raise

def create_response(status_code, body):
    """
    Crear respuesta HTTP
    """
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(body)
    }
