#FROM openjdk:11-slim
FROM openjdk:8-slim


USER root

ENV APP_HOME /app

#Create base app folder

RUN mkdir $APP_HOME

WORKDIR $APP_HOME

RUN apt update 
RUN apt install -y wget
RUN apt install sudo
RUN addgroup hadoop
RUN adduser --disabled-password --gecos "" --ingroup hadoop hduser
RUN apt -y install openssh-server


RUN wget https://downloads.lightbend.com/scala/2.12.14/scala-2.12.14.tgz 
RUN wget https://downloads.apache.org/spark/spark-2.4.8/spark-2.4.8-bin-hadoop2.7.tgz
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz
RUN tar xvf scala-2.12.14.tgz
RUN tar xvf spark-2.4.8-bin-hadoop2.7.tgz
RUN tar xvf hadoop-2.7.3.tar.gz
RUN mv hadoop-2.7.3 /usr/local/hadoop
RUN mv scala-2.12.14 /usr/local/scala
RUN mv spark-2.4.8-bin-hadoop2.7 /usr/local/spark

RUN chown -R hduser:hadoop /usr/local/hadoop


RUN echo "export HADOOP_HOME=/usr/local/hadoop" >> ~/.bashrc
RUN echo "export PATH=$PATH:/usr/local/scala/bin:/usr/local/spark/bin:$HADOOP_HOME" >> ~/.bashrc

RUN mkdir -p /usr/local/hadoop/tmp
RUN chown -R hduser:hadoop /usr/local/hadoop/tmp
RUN chmod a+rwx /usr/local/hadoop/tmp

COPY core-site.xml /usr/local/hadoop/etc/hadoop/
COPY mapred-site.xml /usr/local/hadoop/etc/hadoop/
COPY hdfs-site.xml /usr/local/hadoop/etc/hadoop/



RUN echo "#!/bin/bash" >> /app/boot.sh
RUN echo "service ssh start" >> /app/boot.sh
RUN echo "su -c 'ssh-keyscan localhost 0.0.0.0 127.0.0.1 >> ~/.ssh/known_hosts' - hduser" >> /app/boot.sh >> /app/boot.sh
RUN echo "su -c '/usr/local/hadoop/sbin/start-all.sh' - hduser" >> /app/boot.sh
RUN echo "su - hduser" >> /app/boot.sh >> /app/boot.sh


#RUN echo "/usr/local/hadoop/sbin/start-all.sh" >> /app/boot.sh

#RUN echo "/bin/bash" >> /app/boot.sh
RUN chmod a+x /app/boot.sh

RUN echo "export JAVA_HOME=/usr/local/openjdk-8/" >> /etc/environment

#RUN su - hduser
USER hduser

RUN ssh-keygen -q -t rsa -P "" -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
#RUN ssh-keyscan localhost,0.0.0.0 > ~/.ssh/known_hosts

RUN /usr/local/hadoop/bin/hadoop namenode -format
#RUN /usr/local/hadoop/sbin/start-all.sh
RUN echo "export HADOOP_HOME=/usr/local/hadoop" >> ~/.bashrc
RUN echo "export JAVA_HOME=/usr/local/openjdk-8/" >> ~/.bashrc

RUN echo "export PATH=$PATH:$JAVA_HOME:/usr/local/scala/bin:/usr/local/spark/bin:$HADOOP_HOME" >> ~/.bashrc
RUN echo "export PATH=$PATH:$JAVA_HOME:/usr/local/scala/bin:/usr/local/spark/bin:$HADOOP_HOME" >> ~/.profile

USER hduser
RUN ssh-keyscan localhost 0.0.0.0 127.0.0.l >> ~/.ssh/known_hosts

USER root 
RUN echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf
RUN echo "net.ipv6.conf.default.disable_ipv6=1" >> /etc/sysctl.conf
RUN echo "net.ipv6.conf.lo.disable_ipv6=1" >> /etc/sysctl.conf


RUN service ssh start

EXPOSE 22

#CMD ["bash","/app/boot.sh"]
