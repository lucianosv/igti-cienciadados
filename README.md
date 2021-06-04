# igti-cienciadados (Docker Spark/Scala)

# Instruções

## Baixe o repositório:

git clone https://github.com/valeriow/igti-cienciadados.git

Ou simplesmente baixe o Dockerfile do repositório

## Na pasta onde do Dockerfile, construa a imagem

cd igti-cienciadados

docker build --rm -t cienciadados:latest .

## Para abrir shell no container da imagem construída:
docker run -it cienciadados:latest /bin/bash


