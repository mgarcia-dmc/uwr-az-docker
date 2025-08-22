#!/bin/bash

# Script interactivo para construir una imagen Docker y subirla a Azure Container Registry
echo "Asistente para construir y registrar imágenes en ACR."
echo "----------------------------------------------------"

# Solicitar nombre de Azure Container Registry (ACR)
read -p "Introduce el nombre de tu Azure Container Registry (ACR): " acrName

# Validar que el ACR existe
echo "Verificando la existencia de '$acrName'..."
az acr show --name "$acrName" -o none
if [ $? -ne 0 ]; then
    echo "❌ Error: El ACR '$acrName' no existe en la suscripción actual. Abortando."
    exit 1
fi
echo "✅ ACR encontrado."

# Obtener el servidor de login del ACR
acrLoginServer=$(az acr show --name "$acrName" --query loginServer --output tsv)

# Solicitar nombre y tag para la imagen
read -p "Introduce el nombre para tu imagen (ej: mi-api-de-prueba): " imageName
read -p "Introduce un tag para la imagen (ej: v1 o latest): " imageTag

# Definir el nombre completo de la imagen para ACR
fullImageName="${acrLoginServer}/${imageName}:${imageTag}"

echo "----------------------------------------------------"
echo "Resumen de la operación:"
echo "  - ACR: $acrName"
echo "  - Servidor de Login: $acrLoginServer"
echo "  - Nombre completo de la imagen: $fullImageName"
echo "----------------------------------------------------"
read -p "¿Es correcta esta información? (s/n): " confirm
if [ "$confirm" != "s" ]; then
    echo "Operación cancelada."
    exit 0
fi

echo "--- Paso 1: Iniciando sesión en ACR: $acrName ---"
az acr login --name "$acrName"
if [ $? -ne 0 ]; then
    echo "❌ Error: Falló el inicio de sesión en ACR. Verifica tus permisos."
    exit 1
fi
echo "✅ Sesión iniciada correctamente."

echo "--- Paso 2: Construyendo la imagen Docker localmente ---"
# Construimos la imagen con el tag completo de ACR directamente
docker build -t "$fullImageName" .
if [ $? -ne 0 ]; then
    echo "❌ Error: Falló la construcción de la imagen Docker. Revisa el Dockerfile y los archivos de la app."
    exit 1
fi
echo "✅ Imagen construida exitosamente."

echo "--- Paso 3: Subiendo (push) la imagen a ACR ---"
docker push "$fullImageName"
if [ $? -ne 0 ]; then
    echo "❌ Error: Falló el push de la imagen a ACR."
    exit 1
fi

echo ""
echo "🎉 ¡Éxito! La imagen ha sido registrada en tu Azure Container Registry."
echo "Puedes encontrarla en el portal de Azure o listarla con el comando:"
echo "az acr repository show --name $acrName --image ${imageName}:${imageTag}"
echo "----------------------------------------------------"
