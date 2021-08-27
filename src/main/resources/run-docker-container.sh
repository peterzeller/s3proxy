#!/bin/sh

set -e

PARAM_FILE=/opt/s3proxy/params.properties
> $PARAM_FILE

addParam() {
    PROP=$1
    ENV=$2
    eval ENV_CONTENT=\$$ENV
    if [ -n "$ENV_CONTENT" ]; then
      echo "${PROP}=$ENV_CONTENT" >> $PARAM_FILE
    fi
}

addParam LOG_LEVEL LOG_LEVEL
addParam s3proxy.endpoint S3PROXY_ENDPOINT
addParam s3proxy.virtual-host S3PROXY_VIRTUALHOST
addParam s3proxy.authorization S3PROXY_AUTHORIZATION
addParam s3proxy.identity S3PROXY_IDENTITY
addParam s3proxy.credential S3PROXY_CREDENTIAL
addParam s3proxy.cors-allow-all S3PROXY_CORS_ALLOW_ALL
addParam s3proxy.cors-allow-origins S3PROXY_CORS_ALLOW_ORIGINS
addParam s3proxy.cors-allow-methods S3PROXY_CORS_ALLOW_METHODS
addParam s3proxy.cors-allow-headers S3PROXY_CORS_ALLOW_HEADERS
addParam s3proxy.ignore-unknown-headers S3PROXY_IGNORE_UNKNOWN_HEADERS
addParam jclouds.provider JCLOUDS_PROVIDER
addParam jclouds.identity JCLOUDS_IDENTITY
addParam jclouds.credential JCLOUDS_CREDENTIAL
addParam jclouds.endpoint JCLOUDS_ENDPOINT
addParam jclouds.region JCLOUDS_REGION
addParam jclouds.regions JCLOUDS_REGIONS
addParam jclouds.keystone.version JCLOUDS_KEYSTONE_VERSION
addParam jclouds.keystone.scope JCLOUDS_KEYSTONE_SCOPE
addParam jclouds.keystone.project-domain-name JCLOUDS_KEYSTONE_PROJECT_DOMAIN_NAME

echo "Params file contents:"
cat $PARAM_FILE

exec java -jar /opt/s3proxy/s3proxy --properties $PARAM_FILE

