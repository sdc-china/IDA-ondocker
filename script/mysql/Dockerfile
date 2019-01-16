# websphere liberty with keter

FROM mysql:5.7

COPY schema-mysql.sql /docker-entrypoint-initdb.d/1-schema.sql
COPY data-mysql.sql /docker-entrypoint-initdb.d/2-data.sql


RUN chmod 777 /docker-entrypoint-initdb.d
RUN chmod 777 /docker-entrypoint-initdb.d/*.sql