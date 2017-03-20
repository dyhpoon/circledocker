FROM risingstack/alpine:3.4-v6.7.0-4.0.0

MAINTAINER Martino Fornasa <mf@fornasa.it>

WORKDIR /opt/app

# Install yarn
RUN mkdir -p /opt
COPY latest.tar.gz /opt/
RUN tar -xvzf /opt/latest.tar.gz

RUN ls -al /

RUN ls -al /opt

RUN ls -al /opt/yarn

RUN mv /opt/dist /opt/yarn
ENV PATH "$PATH:/opt/yarn/bin"

ADD package.json yarn.lock /tmp/

# Copy cache contents (if any) from local machine
ADD .yarn-cache.tgz /

RUN echo $PATH

# Install packages
RUN cd /tmp && yarn
RUN mkdir -p /opt/app && cd /opt/app && ln -s /tmp/node_modules

# Copy the code
ADD . /opt/app
