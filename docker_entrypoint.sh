#!/usr/bin/env bash

CONFIG_FILE=/s3-config.yml
SECRETS_ROOT=/etc/secrets
ACCESSKEY_FILE=${SECRETS_ROOT}/s3-accesskey
SECRETKEY_FILE=${SECRETS_ROOT}/s3-secretkey
REGION_FILE=${SECRETS_ROOT}/s3-region
BUCKET_FILE=${SECRETS_ROOT}/s3-bucket

FILES="ACCESSKEY_FILE SECRETKEY_FILE REGION_FILE BUCKET_FILE"
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
health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
EOCONF

registry ${CONFIG_FILE}