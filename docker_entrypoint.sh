#!/usr/bin/env bash

# Secrets location...
CONFIG_FILE=/s3-config.yml
SECRETS_ROOT=/etc/secrets
ACCESSKEY_FILE=${SECRETS_ROOT}/s3-accesskey
SECRETKEY_FILE=${SECRETS_ROOT}/s3-secretkey
REGION_FILE=${SECRETS_ROOT}/s3-region
BUCKET_FILE=${SECRETS_ROOT}/s3-bucket
DOCKER_USER_FILE=${SECRETS_ROOT}/docker-user
DOCKER_PASS_FILE=${SECRETS_ROOT}/docker-pass
REGISTRY_HTTP_TLS_CERTIFICATE=${SECRETS_ROOT}/crt
REGISTRY_HTTP_TLS_KEY=${SECRETS_ROOT}/key
export REGISTRY_AUTH_HTPASSWD_PATH=/etc/htpasswd
export REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm"
export REGISTRY_AUTH=htpasswd

FILES="ACCESSKEY_FILE SECRETKEY_FILE REGION_FILE BUCKET_FILE REGISTRY_HTTP_TLS_CERTIFICATE REGISTRY_HTTP_TLS_KEY DOCKER_USER DOCKER_PASS"
ALL_OK=true
for file_env in $FILES; do
    file_name=$(eval echo \$$file_env)
    if [ ! -f $file_name ]; then
        echo "Missing file - $file_name, please mount it!"
        ALL_OK=false
    fi
done
if [ "$ALL_OK" != "true" ]; then
    exit 1
fi

# Generate the S3 configuration from secrets:
cat > "${CONFIG_FILE}" <<-EOCONF
version: 0.1
log:
  fields:
    service: registry
storage:
    cache:
        layerinfo: inmemory
    s3:
        accesskey: $(cat ${ACCESSKEY_FILE})
        secretkey: $(cat ${SECRETKEY_FILE})
        region: $(cat ${REGION_FILE})
        bucket: $(cat ${BUCKET_FILE})
        encrypt: true
        secure: true
        v4auth: true
        chunksize: 5242880
        rootdirectory: /registry_data
http:
    addr: :5000
    tls:
        certificate: ${REGISTRY_HTTP_TLS_CERTIFICATE}
        key: ${REGISTRY_HTTP_TLS_KEY}
health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
htpasswd:
    realm: ${REGISTRY_AUTH_HTPASSWD_REALM}
    path: ${REGISTRY_AUTH_HTPASSWD_PATH}
EOCONF

# Create the password file...
htpasswd -Bbn $(cat ${DOCKER_USER_FILE}) $(cat ${DOCKER_PASS_FILE}) > ${REGISTRY_AUTH_HTPASSWD_PATH}

exec registry ${CONFIG_FILE}