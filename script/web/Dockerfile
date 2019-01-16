# websphere liberty with keter

FROM openliberty/open-liberty:javaee7

RUN apt-get update
RUN apt-get -y install curl

RUN mkdir -p /var/ida/data
VOLUME ["/var/ida/data"]

RUN mv /opt/ol/wlp/usr/servers/defaultServer/server.xml /opt/ol/wlp/usr/servers/defaultServer/server-original.xml

COPY wait-for-it.sh /tmp/

# Deploy the ida war
COPY ida-web.war /opt/ol/wlp/usr/servers/defaultServer/apps/

# Update server configuration
COPY server.xml /opt/ol/wlp/usr/servers/defaultServer
COPY jvm.options /opt/ol/wlp/usr/servers/defaultServer

# RUN /opt/ol/wlp/bin/server run defaultServer