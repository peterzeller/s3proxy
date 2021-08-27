# Multistage - Builder
FROM maven:3.6.3-jdk-11 as s3proxy-builder
LABEL maintainer="Andrew Gaul <andrew@gaul.org>"

WORKDIR /opt/s3proxy
# first copy only pom.xml to cache dependencies
COPY pom.xml /opt/s3proxy/
COPY src/main/assembly /opt/s3proxy/src/main/assembly/
RUN mvn verify --fail-never
RUN mvn dependency:go-offline
RUN mvn package -DskipTests --fail-never
COPY . /opt/s3proxy/
RUN mvn package -DskipTests

# Multistage - Image
FROM openjdk:8-jre-alpine
LABEL maintainer="Andrew Gaul <andrew@gaul.org>"

WORKDIR /opt/s3proxy

COPY \
    --from=s3proxy-builder \
    /opt/s3proxy/target/s3proxy \
    /opt/s3proxy/src/main/resources/run-docker-container.sh \
    /opt/s3proxy/

ENV \
    LOG_LEVEL="info" \
    S3PROXY_AUTHORIZATION="aws-v2-or-v4" \
    S3PROXY_ENDPOINT="http://0.0.0.0:80" \
    S3PROXY_IDENTITY="local-identity" \
    S3PROXY_CREDENTIAL="local-credential" \
    S3PROXY_VIRTUALHOST="" \
    S3PROXY_CORS_ALLOW_ALL="false" \
    S3PROXY_CORS_ALLOW_ORIGINS="" \
    S3PROXY_CORS_ALLOW_METHODS="" \
    S3PROXY_CORS_ALLOW_HEADERS="" \
    S3PROXY_IGNORE_UNKNOWN_HEADERS="false" \
    JCLOUDS_PROVIDER="filesystem" \
    JCLOUDS_ENDPOINT="" \
    JCLOUDS_REGION="" \
    JCLOUDS_REGIONS="us-east-1" \
    JCLOUDS_IDENTITY="remote-identity" \
    JCLOUDS_CREDENTIAL="remote-credential" \
    JCLOUDS_KEYSTONE_VERSION="" \
    JCLOUDS_KEYSTONE_SCOPE="" \
    JCLOUDS_KEYSTONE_PROJECT_DOMAIN_NAME=""

EXPOSE 80
VOLUME /data

#COPY azure.properties /opt/s3proxy/

ENTRYPOINT ["/opt/s3proxy/run-docker-container.sh"]
#ENTRYPOINT ["java", "-DLOG_LEVEL=all", "-jar", "/opt/s3proxy/s3proxy", "--properties", "/opt/s3proxy/azure.properties"]