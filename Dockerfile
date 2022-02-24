FROM debian:buster

RUN apt-get update
RUN apt-get install -y python3 python3-dev python3-venv
RUN apt-get install -y wget unzip
RUN apt-get install -y libblosc1
RUN apt-get install -y zlib1g-dev libssl-dev build-essential libjpeg-dev libpng-dev
RUN apt-get install -y openjdk-11-jdk-headless

WORKDIR /usr/local

ENV BFURL https://github.com/glencoesoftware/bioformats2raw/releases/download/v0.4.0/bioformats2raw-0.4.0.zip

RUN wget -q $BFURL -O bioformats2raw.zip
RUN unzip bioformats2raw.zip
RUN ln -s bioformats2raw-*/ bioformats2raw

# Command located in /usr/local/bioformats2raw/bin/bioformats2raw

RUN python3 -mvenv /opt/omero_env
RUN /opt/omero_env/bin/pip install --upgrade pip
RUN /opt/omero_env/bin/pip install wheel setuptools
RUN /opt/omero_env/bin/pip install https://github.com/ome/zeroc-ice-debian10/releases/download/0.1.0/zeroc_ice-3.6.5-cp37-cp37m-linux_x86_64.whl
RUN /opt/omero_env/bin/pip install numpy

RUN /opt/omero_env/bin/pip install ezomero 

