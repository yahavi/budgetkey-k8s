#!/usr/bin/env bash

source connect.sh

RES=0

echo "Performing health checks for all charts of ${K8S_ENVIRONMENT_NAME} environment"

root_healthcheck() {
    ! [ "`./read_env_yaml.sh global enableRootChart`" == "true" ] \
        && echo "root chart is disabled, skipping healthcheck" && return 0
    kubectl rollout status deployment/adminer &&\
    kubectl rollout status deployment/nginx &&\
    kubectl rollout status deployment/traefik
}

! root_healthcheck && echo failed root healthcheck && RES=1;

[ "${RES}" == "0" ] && echo Great Success!

exit $RES
