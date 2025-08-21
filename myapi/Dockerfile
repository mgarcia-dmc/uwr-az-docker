# Usa una imagen base de Python ligera y oficial.
FROM python:3.10-slim

# Establece el directorio de trabajo dentro del contenedor.
WORKDIR /app

# Copia primero el archivo de requerimientos para aprovechar el caché de capas de Docker.
COPY requirements.txt requirements.txt

# Instala las dependencias de Python.
RUN pip install --no-cache-dir -r requirements.txt

# Copia el resto del código de la aplicación al directorio de trabajo.
COPY . .

# Expone el puerto en el que Gunicorn se ejecutará.
EXPOSE 8000

# Comando para ejecutar la aplicación cuando se inicie el contenedor.
# Se enlaza a 0.0.0.0 para que sea accesible desde fuera del contenedor.
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "wsgi:app"]

