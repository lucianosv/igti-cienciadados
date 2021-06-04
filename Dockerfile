#FROM openjdk:11-slim
FROM openjdk:8-slim

ENV APP_HOME /app

#Create base app folder

RUN mkdir $APP_HOME

WORKDIR $APP_HOME

RUN apt update && apt install -y wget
RUN wget https://downloads.lightbend.com/scala/2.12.14/scala-2.12.14.tgz 
RUN wget https://downloads.apache.org/spark/spark-2.4.8/spark-2.4.8-bin-hadoop2.7.tgz
RUN tar xvf scala-2.12.14.tgz
RUN tar xvf spark-2.4.8-bin-hadoop2.7.tgz

RUN mv scala-2.12.14 /usr/local/scala
RUN mv spark-2.4.8-bin-hadoop2.7 /usr/local/spark

RUN echo "export PATH=$PATH:/usr/local/scala/bin:/usr/local/spark/bin" >> ~/.bashrc
