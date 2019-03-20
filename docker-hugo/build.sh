#!/bin/sh

DOCKER_REPO=uthng
DOCKER_IMAGE=docker-hugo
DOCKER_TAG=0.54.0-1
DOCKER_BUILD=false
DOCKER_PUSH=false
DOCKER_USER=
DOCKER_PASS=

help() {
    echo "$0 [options]"
    echo "Options:"
    echo "-r or --repo: docker private repositor. Default: $DOCKER_REPO"
    echo "-t or --tag: docker image tag. By defaut: $DOCKER_TAG"
    echo "-b or --build: build docker image (true/false). Default: $DOCKER_BUILD"
    echo "-p or --push: push docker image (true/fasle). Default: $DOCKER_PUSH"
    echo "--user: user for docker private registry. Default: $DOCKER_USER"
    echo "--pass: password for docker private registry. Default: $DOCKER_PUSH"
    exit 0
}

# read the options
TEMP=`getopt -o hr:t:bp --long help,repo:,tag:,user:,pass:,build,push -n 'build.sh' -- "$@"`
eval set -- "$TEMP"

while true ; do
    case "$1" in
        -r | --repo) DOCKER_REPO="$2" ; shift 2 ;;
        -t | --tag) DOCKER_TAG="$2" ; shift 2 ;;
        -j | --jenkins) JENKINS_BUILD_NUMBER="$2" ; shift 2 ;;
        -b | --build) DOCKER_BUILD=true ; shift ;;
        -p | --push) DOCKER_PUSH=true ; shift ;;
        --user) DOCKER_USER="$2" ; shift 2 ;;
        --pass) DOCKER_PASS="$2" ; shift 2 ;;
        -h | --help) help ; shift ;;
        \?) echo "Invalid argument !" ; exit 1 ;;
        --) shift ; break ;;
        *) echo "Error argument !" ; exit 1 ;;
    esac
done

if ${DOCKER_BUILD} ; then
    docker build -t ${DOCKER_REPO}/${DOCKER_IMAGE}:${DOCKER_TAG} .
fi

if [ $? -ne 0 ]; then exit 1; fi

if ${DOCKER_PUSH} ; then
    if [ -z "${DOCKER_USER}" ] || [ -z "${DOCKER_PASS}" ]; then
        echo "Docker user and its password must be specified ! Use --user and --pass options"
        exit 1
    fi

    docker login -u ${DOCKER_USER} -p ${DOCKER_PASS} http://${DOCKER_REPO}
    if [ $? -ne 0 ]; then exit 1; fi

    if [ "${DOCKER_TAG}" != "latest" ]; then
        docker tag ${DOCKER_REPO}/${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_REPO}/${DOCKER_IMAGE}:latest
        docker push ${DOCKER_REPO}/${DOCKER_IMAGE}:${DOCKER_TAG}
    fi

    docker push ${DOCKER_REPO}/${DOCKER_IMAGE}:latest
fi
