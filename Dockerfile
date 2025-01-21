# syntax=docker/dockerfile:1
# helm: kubernetes package manager
FROM ubuntu:22.04 as helm
ARG HELM_VERSION=3.11.3
ARG TARGETARCH

ADD https://get.helm.sh/helm-v${HELM_VERSION}-linux-${TARGETARCH}.tar.gz /tmp/tarballs/
RUN tar zxvf /tmp/tarballs/*.tar.gz -C /usr/local/bin/ --strip-components=1 linux-${TARGETARCH}/helm

# sops: encrypting secrets
FROM ubuntu:22.04 as sops
ARG SOPS_VERSION=3.9.3
ARG ARCH=amd64
ADD --chmod=755 https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.$ARCH /usr/local/bin/sops

FROM node:22-bookworm-slim

# We need to set a home directory, since both Helm and NPM won't be able to write to /.
ENV HOME=/tmp/argocd-cdk8s-plugin/

RUN mkdir $HOME && chmod 770 $HOME
RUN apt-get update && apt-get install git tree ca-certificates -y --no-install-recommends && rm -rf /var/lib/apt/lists/*
COPY --from=helm /usr/local/bin/ /usr/local/bin/
COPY --from=sops /usr/local/bin/ /usr/local/bin/
COPY plugin.yaml /home/argocd/cmp-server/config/plugin.yaml
COPY scripts/* /

CMD ["/var/run/argocd/argocd-cmp-server"]
