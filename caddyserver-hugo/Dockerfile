FROM uthng/caddyserver:latest
MAINTAINER Thanh NGUYEN <u.nguyenthanh@gmail.com>

ENV GIT_SSH_FOLDER /sshkey
ENV GIT_REPO ""
ENV GIT_BRANCH master
ENV GIT_WEBHOOK_URL ""
ENV GIT_WEBHOOK_SECRET ""_

# Hugo options
# Download
ENV HUGO_VERSION 0.54.0
ENV HUGO_DOWNLOAD_NAME hugo_extended_${HUGO_VERSION}_Linux-64bit

RUN apt-get update && apt-get -y install \
    python-pygments \
    && apt-get autoremove

# Download Hugo
RUN curl -jksSL "https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_DOWNLOAD_NAME}.tar.gz" | tar -xzf - -C /tmp \
    && mv /tmp/hugo /usr/local/bin/hugo \
    && rm -rf /tmp/*

# Prepare sshkey
RUN mkdir /sshkey
RUN mkdir ~/.ssh
#RUN echo "Host *\n\tStrictHostKeyChecking no\n\tIdentityFile ${GIT_SSH_KEY}" >> ~/.ssh/config

# Copy all necessary files
COPY entrypoint.sh /
COPY run.sh /

WORKDIR /site

VOLUME ${GIT_SSH_FOLDER}

EXPOSE 443 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/run.sh"]
