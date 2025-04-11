def handler(event, context):
    print("Evento recebido:", event)
    return {
        'statusCode': 200,
        'body': 'Lambda executada com sucesso pelo Grupo 6!'
    }