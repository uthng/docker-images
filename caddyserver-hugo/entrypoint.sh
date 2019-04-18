#!/bin/sh

set -x

git_repo_clone() {
    git clone ${GIT_REPO} .

    if [ "${GIT_BRANCH}" != "master" ]; then
        git fetch --all
        git checkout "${GIT_BRANCH}"
    fi

    #git submodule update --init --recursive
}

#hugo_publish() {
    #hugo --destination=${CADDY_PUBLIC}
#}

# Set rights on ssh keys
cp -p ${GIT_SSH_FOLDER}/* ~/.ssh
chown -R root:root ~/.ssh
#chmod 600 ${GIT_SSH_KEY}

git_repo_clone
#hugo_publish

exec "$@"
