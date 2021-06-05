# igti-cienciadados (Docker Hadoop/Spark/Scala)

# Instruções

## Baixe o repositório:

git clone https://github.com/valeriow/igti-cienciadados.git

Ou simplesmente baixe o Dockerfile e os demais arquivos do repositório

## Na pasta onde do Dockerfile, construa a imagem

cd igti-cienciadados

docker build --rm -t cienciadados:latest .

## Para abrir shell no container da imagem construída:
docker run -it cienciadados:latest /app/boot.sh

## Faça um teste

cd /usr/local/hadoop/

bin/hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.3.jar pi 16 1000
