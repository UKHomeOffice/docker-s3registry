FROM registry:2
COPY docker_entrypoint.sh /
ENTRYPOINT ["/docker_entrypoint.sh"]