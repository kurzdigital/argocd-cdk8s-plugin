# syntax=docker/dockerfile:1
# helm: kubernetes package manager
FROM ubuntu:22.04 as helm
ARG HELM_VERSION=3.11.3

ADD https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz /tmp/tarballs/
RUN tar zxvf /tmp/tarballs/*.tar.gz -C /usr/local/bin/ --strip-components=1 linux-amd64/helm

FROM node:16-slim

RUN apt-get update && apt-get install git ca-certificates -y --no-install-recommends && rm -rf /var/lib/apt/lists/* && \
    npm install -g ts-node
COPY --from=helm /usr/local/bin/ /usr/local/bin/
COPY plugin.yaml /home/argocd/cmp-server/config/plugin.yaml
COPY scripts/* /

CMD ["/var/run/argocd/argocd-cmp-server"]
