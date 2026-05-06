set -e

ACR_NAME="miacr12345"   
RESOURCE_GROUP="fastapi-rg"
LOCATION="westeurope"
IMAGE_NAME="fastapi-app"
VERSION="1.0.0"

echo "📦 Creando Resource Group si no existe..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "🏭 Creando ACR si no existe..."
az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Basic --location $LOCATION

echo "🔐 Login en ACR..."
az acr login --name $ACR_NAME

echo "🏷️ Retag de imagen local..."
docker tag ${IMAGE_NAME}:${VERSION} ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${VERSION}
docker tag ${IMAGE_NAME}:latest ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:latest

echo "📤 Subiendo imágenes a ACR..."
docker push ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${VERSION}
docker push ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:latest

echo "📄 Listando imágenes en ACR..."
az acr repository list --name $ACR_NAME -o table