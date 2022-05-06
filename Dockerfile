# Build bioformats2raw
# This is based on https://github.com/glencoesoftware/bioformats2raw/blob/master/Dockerfile,
# and should be used until there is an updated binary release for us to use.
ARG BUILD_IMAGE=gradle:6.9-jdk8
FROM ${BUILD_IMAGE} as build
USER root
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq libblosc1
RUN mkdir /bioformats2raw && chown 1000:1000 /bioformats2raw

USER 1000
WORKDIR /bioformats2raw
RUN git clone https://github.com/glencoesoftware/bioformats2raw.git .
RUN gradle build
RUN cd build/distributions && rm bioformats2raw*tar && unzip bioformats2raw*zip && rm -rf bioformats2raw*zip
# 
FROM debian:buster as final
USER root
COPY --from=build /bioformats2raw/build/distributions/bioformats2raw* /opt/bioformats2raw
RUN ln -s /bioformats2raw-*/ bioformats2raw
RUN apt-get update
RUN apt-get install -y python3 python3-dev python3-venv
RUN apt-get install -y wget unzip
RUN apt-get install -y libblosc1
RUN apt-get install -y zlib1g-dev libssl-dev build-essential libjpeg-dev libpng-dev
RUN apt-get install -y openjdk-11-jdk-headless

WORKDIR /usr/local

# Use this code when there is a stable version of bioformats2raw for us to use.
# ENV BFURL https://github.com/glencoesoftware/bioformats2raw/releases/download/v0.4.0/bioformats2raw-0.4.0.zip
# RUN wget -q $BFURL -O bioformats2raw.zip
# RUN unzip bioformats2raw.zip
# RUN ln -s bioformats2raw-*/ bioformats2raw

# Command located in /usr/local/bioformats2raw/bin/bioformats2raw
ENV PATH="/opt/bioformats2raw/bin:${PATH}"

RUN python3 -mvenv /opt/omero_env
RUN /opt/omero_env/bin/pip install --upgrade pip
RUN /opt/omero_env/bin/pip install wheel setuptools
RUN /opt/omero_env/bin/pip install https://github.com/ome/zeroc-ice-debian10/releases/download/0.1.0/zeroc_ice-3.6.5-cp37-cp37m-linux_x86_64.whl
RUN /opt/omero_env/bin/pip install numpy

RUN /opt/omero_env/bin/pip install ezomero 


