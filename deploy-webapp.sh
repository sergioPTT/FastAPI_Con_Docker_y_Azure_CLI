set -e

RESOURCE_GROUP="fastapi-rg"
PLAN_NAME="fastapi-plan"
WEBAPP_NAME="fastapi-webapp-12345"   # Debe ser único
ACR_NAME="miacr12345"
IMAGE_NAME="fastapi-app"
VERSION="1.0.0"
LOCATION="westeurope"

echo "📦 Creando Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "🛠️ Creando App Service Plan..."
az appservice plan create \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --sku B1 \
  --is-linux

echo "🌐 Creando Web App..."
az webapp create \
  --resource-group $RESOURCE_GROUP \
  --plan $PLAN_NAME \
  --name $WEBAPP_NAME \
  --deployment-container-image-name ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${VERSION}

echo "🔐 Configurando credenciales de ACR..."
az webapp config container set \
  --name $WEBAPP_NAME \
  --resource-group $RESOURCE_GROUP \
  --docker-custom-image-name ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${VERSION} \
  --docker-registry-server-url https://${ACR_NAME}.azurecr.io

echo "🌍 Configurando puerto 8000..."
az webapp config appsettings set \
  --resource-group $RESOURCE_GROUP \
  --name $WEBAPP_NAME \
  --settings WEBSITES_PORT=8000

echo "🔓 Habilitando CORS..."
az webapp cors add \
  --resource-group $RESOURCE_GROUP \
  --name $WEBAPP_NAME \
  --allowed-origins "*"

echo "🎉 Despliegue completado"
echo "URL final:"
echo "👉 https://${WEBAPP_NAME}.azurewebsites.net"