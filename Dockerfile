FROM debian:jessie

MAINTAINER Ilya Epifanov <elijah.epifanov@gmail.com>

RUN apt-get update && apt-get install -y curl ca-certificates --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$(dpkg --print-architecture)" \
        && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$(dpkg --print-architecture).asc" \
        && gpg --verify /usr/local/bin/gosu.asc \
        && rm /usr/local/bin/gosu.asc \
        && chmod +x /usr/local/bin/gosu

ENV FLUME_VERSION=1.5.0

COPY cloudera.pref /etc/apt/preferences.d/cloudera.pref
COPY cloudera.list /etc/apt/sources.list.d/cloudera.list
COPY cloudera.key /tmp/cloudera.key

RUN useradd -r -d /var/lib/flume-ng -m flume

RUN apt-key add /tmp/cloudera.key &&\
    apt-get update &&\
    apt-get install -y openjdk-7-jre-headless "flume-ng=$FLUME_VERSION+*" --no-install-recommends &&\
    dpkg-reconfigure ca-certificates-java &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl 'http://central.maven.org/maven2/org/apache/lucene/lucene-core/4.6.1/lucene-core-4.6.1.jar' -o /usr/lib/flume-ng/lib/lucene-core-4.6.1.jar
RUN curl http://central.maven.org/maven2/org/elasticsearch/elasticsearch/0.90.13/elasticsearch-0.90.13.jar -o /usr/lib/flume-ng/lib/elasticsearch-0.90.13.jar

ENV PATH /usr/bin:/bin:/usr/local/bin

VOLUME /etc/hadoop/conf /etc/flume-ng/conf

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/bin/flume-ng", "agent", "-n", "a1", "-f", "/etc/flume-ng/conf/flume-conf.properties", "--conf", "/etc/flume-ng/conf"]
