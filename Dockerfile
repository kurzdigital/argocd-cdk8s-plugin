# syntax=docker/dockerfile:1
# helm: kubernetes package manager
FROM ubuntu:22.04 as helm
ARG HELM_VERSION=3.11.3
ARG TARGETARCH=amd64

ADD https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCH}.tar.gz /tmp/tarballs/
RUN tar zxvf /tmp/tarballs/*.tar.gz -C /usr/local/bin/ --strip-components=1 linux-${ARCH}/helm

FROM node:16-bullseye-slim

# We need to set a home directory, since both Helm and NPM won't be able to write to /.
ENV HOME=/tmp/argocd-cdk8s-plugin/

RUN mkdir $HOME && chmod 770 $HOME
RUN apt-get update && apt-get install git tree ca-certificates -y --no-install-recommends && rm -rf /var/lib/apt/lists/*
COPY --from=helm /usr/local/bin/ /usr/local/bin/
COPY plugin.yaml /home/argocd/cmp-server/config/plugin.yaml
COPY scripts/* /

CMD ["/var/run/argocd/argocd-cmp-server"]
