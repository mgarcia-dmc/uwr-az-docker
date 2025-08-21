#!/bin/bash

# Script interactivo para construir una imagen Docker y subirla a Azure Container Registry

echo "Procedimiento para Crear ACR."
echo "----------------------------------------------------"

echo "Este script te guiará para crear un Azure Container Registry (ACR) y subir una imagen Docker."
echo "----------------------------------------------------"


echo "Verificando sesión de Azure..."
# Verificar si ya hay una sesión iniciada en Azure
az account show > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "No se ha iniciado sesión en Azure. Procediendo con el login..."
  # Iniciar sesión en Azure usando el código de dispositivo para autenticación
  az login --use-device-code
  if [ $? -ne 0 ]; then
      echo "❌ Error: Falló el inicio de sesión en Azure. Verifica tus credenciales."
      exit 1
  fi
  echo "✅ Sesión iniciada correctamente."
else
  echo "✅ Ya tienes una sesión activa en Azure."
fi
sleep 2

echo "----------------------------------------------------"
echo "Ahora vamos a crear un Azure Container Registry (ACR) si no existe."
echo "----------------------------------------------------"

echo "Listando los grupos de recursos disponibles en tu suscripción..."
az group list --output table
echo "----------------------------------------------------"
echo "Por favor, proporciona los siguientes datos para crear el ACR."
echo "Elige un grupo de recursos de la lista anterior."
echo "----------------------------------------------------"

# Solicitar nombre de Azure Container Registry (ACR)
read -p "Introduce el nombre de tu Grupo de recursos: " rsgroup
read -p "Introduce el nombre de tu Azure Container Registry (ACR): " acrName

# Validar que el nombre del grupo de recursos no esté vacío
if [ -z "$rsgroup" ]; then
    echo "❌ Error: El nombre del Grupo de Recursos no puede estar vacío. Abortando."
    exit 1
fi

# Validar que el nombre del ACR no esté vacío
if [ -z "$acrName" ]; then
    echo "❌ Error: El nombre del ACR no puede estar vacío. Abortando."
    exit 1
fi

# Verificar si el grupo de recursos existe
echo "Verificando si el grupo de recursos '$rsgroup' existe..."
az group show --name "$rsgroup" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Error: El grupo de recursos '$rsgroup' no existe. Por favor, elige uno de la lista o créalo primero. Abortando."
    exit 1
fi

# Crear el ACR si no existe 
az acr create --resource-group "$rsgroup" --name "$acrName" --sku Basic --admin-enabled true
if [ $? -ne 0 ]; then
    echo "❌ Error: Falló la creación del ACR. Verifica que el nombre sea único y que tengas permisos."
    exit 1
fi
echo "✅ ACR creado exitosamente."
echo "----------------------------------------------------"
