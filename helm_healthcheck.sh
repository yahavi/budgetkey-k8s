#!/usr/bin/env bash

source connect.sh

RES=0

echo "Performing health checks for all charts of ${K8S_ENVIRONMENT_NAME} environment"

socialmap_healthcheck() {
    ! [ "`./read_env_yaml.sh socialmap enabled`" == "true" ] \
        && echo "socialmap chart is disabled, skipping healthcheck" && return 0
    kubectl rollout status deployment/socialmap-main-page
}

openprocure_healthcheck() {
    ! [ "`./read_env_yaml.sh openprocure enabled`" == "true" ] \
        && echo "openprocure chart is disabled, skipping healthcheck" && return 0
    kubectl rollout status deployment/openprocure-main-page
}

themes_healthcheck() {
    ! [ "`./read_env_yaml.sh themes enabled`" == "true" ] \
        && echo "themes chart is disabled, skipping healthcheck" && return 0
    [ "$(kubectl get job openprocure-theme -o json | jq -r .status.succeeded)" == "1" ] &&\
     echo themes: OK
}

! socialmap_healthcheck && echo failed socialmap healthcheck && RES=1;
! themes_healthcheck && echo failed themes healthcheck && RES=1;

[ "${RES}" == "0" ] && echo Great Success!

exit $RES
