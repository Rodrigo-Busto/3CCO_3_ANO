#!/bin/bash

# Installing Required packages
sudo apt update -y
sudo apt install openjdk-11-jdk -y
sudo apt-get install scala -y
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> ~/.profile

# Installing spark packages
wget https://dlcdn.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz
tar -xf spark-3.2.1-bin-hadoop3.2.tgz
sudo mv spark-3.2.1-bin-hadoop3.2 /opt/spark

# Configuring spark environment
echo 'export SPARK_HOME=/opt/spark' >> ~/.profile
echo 'export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' >> ~/.profile
echo 'export PYSPARK_PYTHON=/usr/bin/python3' >> ~/.profile

. ~/.profile

# Starting standalone cluster
start-worker.sh spark://10.100.0.139:7077