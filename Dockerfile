FROM java:8-jre

MAINTAINER Ilya Epifanov <elijah.epifanov@gmail.com>

ENV FLUME_VERSION=1.7.0

RUN apt-get update \
 && apt-get install wget --no-install-recommends -y \
 && wget http://mirror.nl.webzilla.com/apache/flume/${FLUME_VERSION}/apache-flume-${FLUME_VERSION}-bin.tar.gz -O /tmp/flume.tar.gz \
 && mkdir /flume \
 && tar zxf /tmp/flume.tar.gz -C /flume --strip-components 1 \
 && apt-get remove --purge wget -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH /flume/bin:/usr/bin:/bin:/usr/local/bin

CMD ["flume-ng", "agent"]
