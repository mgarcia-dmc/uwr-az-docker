from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def index():
    return "<h2>API funcionando dentro de un contenedor Docker! ingresa en /api/v1/info </h2>"

@app.route('/api/v1/info', methods=['GET'])
def get_info():
    data = {
        'version': '1.0',
        'status': 'ok',
        'message': '¡Hola desde la API en Azure Container Registry!'
    }
    return jsonify(data)

