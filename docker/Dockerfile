##########################################################################
# Dockerfile to build Dynomite container images with Redis as the backend
# Based on Ubuntu
##########################################################################
# Copyright 2015 Netflix, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

##########################################################################

# Set the base image to Ubuntu
FROM ubuntu:14.04

# File Author / Maintainer
MAINTAINER Ioannis Papapanagiotou - dynomite@netflix.com

# Update the repository sources list and Install package Build Essential
RUN apt-get update && apt-get install -y \
  autoconf \
  build-essential \
  dh-autoreconf \
  git \
  npm \
  unzip \
  libssl-dev \
  libtool \
  python-software-properties \
  tcl8.5 \
  dnsutils

# Clone the Dynomite Git
RUN git clone https://github.com/barricadeio/dynomite.git
RUN echo 'Git repo has been cloned in your Docker VM'

# Create dynomite config directory
RUN mkdir /etc/dynomite

# Create consul-template directories
RUN mkdir -p /opt/consul-template/bin
RUN mkdir -p /opt/consul-template/config
RUN mkdir -p /opt/consul-template/templates

# Add the init script for consul-template
ADD consul-template /etc/init.d/

# Add the config file for consul-template
ADD seeds.ct /opt/consul-template/config/

# Add the template file to be served using consul-template
ADD seeds.ctmpl /opt/consul-template/templates/

# Move to working directory
WORKDIR /opt/consul-template/bin

# Download consul-template binary
RUN curl https://releases.hashicorp.com/consul-template/0.12.2/consul-template_0.12.2_linux_amd64.zip -o consul-template.zip
RUN unzip consul-template.zip && rm consul-template.zip

# Move to working directory
WORKDIR /dynomite

# Autoreconf
RUN autoreconf -fvi \
  && ./configure --enable-debug=log \
  && CFLAGS="-ggdb3 -O0" ./configure --enable-debug=full \
  && make \
  && make install

##################### INSTALLATION ENDS #####################

# Expose the peer port
RUN echo 'Exposing peer port 8101'
EXPOSE 8101

# Default port to acccess Dynomite
RUN echo 'Exposing client port for Dynomite 8102'
EXPOSE 8102

# Expose the stats/admin port
RUN echo 'Exposing stats/admin port 22222'
EXPOSE 22222

# Setting the dynomite as the dockerized entry-point application
RUN echo 'Starting Dynomite'
CMD ./bin/write_config.sh && ./bin/run_with_marathon.sh
