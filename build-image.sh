set -e


VERSION="1.0.0"
IMAGE_NAME="fastapi-app"

echo "🔧 Construyendo imagen Docker..."
docker build -t ${IMAGE_NAME}:${VERSION} .

echo "🏷️ Creando tag latest..."
docker tag ${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:latest

echo "✅ Imagen construida:"
docker images | grep ${IMAGE_NAME}