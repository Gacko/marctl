# Start from Alpine.
FROM alpine:3.23.3

# Provide target OS & architecture.
ARG TARGETOS
ARG TARGETARCH

# Install dependencies.
RUN apk add --no-cache \
    bash \
    coreutils \
    diffutils \
    findutils \
    gcompat \
    git \
    go \
    grep \
    helm \
    kubectl \
    make \
    python3 \
    yq \
    zsh

# Extend PATH.
ENV PATH="/root/go/bin:${PATH}"

# Configure zsh.
COPY etc/zsh/zshrc.d/* /etc/zsh/zshrc.d/

# Install devctl.
ARG DEVCTL_VERSION=v7.33.1
RUN wget "https://github.com/giantswarm/devctl/releases/download/${DEVCTL_VERSION}/devctl-${DEVCTL_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" --output-document - | tar --extract --gzip --directory /usr/local/bin --no-same-owner --strip-components 1 "devctl-${DEVCTL_VERSION}-${TARGETOS}-${TARGETARCH}/devctl" && strip /usr/local/bin/devctl

# Install helm-docs.
ARG HELM_DOCS_VERSION=v1.14.2
RUN wget "https://github.com/norwoodj/helm-docs/releases/download/${HELM_DOCS_VERSION}/helm-docs_${HELM_DOCS_VERSION#v}_${TARGETOS}_${TARGETARCH/amd64/x86_64}.tar.gz" --output-document - | tar --extract --gzip --directory /usr/local/bin --no-same-owner helm-docs && strip /usr/local/bin/helm-docs

# Install helm-schema-gen.
ARG HELM_SCHEMA_GEN_VERSION=v0.0.9
RUN wget "https://github.com/mihaisee/helm-schema-gen/releases/download/${HELM_SCHEMA_GEN_VERSION#v}/helm-schema-gen_${HELM_SCHEMA_GEN_VERSION#v}_${TARGETOS}_${TARGETARCH/amd64/x86_64}.tar.gz" --output-document - | tar --extract --gzip --directory /usr/local/bin --no-same-owner helm-schema-gen && strip /usr/local/bin/helm-schema-gen

# Install kubectl-gs.
ARG KUBECTL_GS_VERSION=v4.11.0
RUN wget "https://github.com/giantswarm/kubectl-gs/releases/download/${KUBECTL_GS_VERSION}/kubectl-gs-${KUBECTL_GS_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" --output-document - | tar --extract --gzip --directory /usr/local/bin --no-same-owner --strip-components 1 "kubectl-gs-${KUBECTL_GS_VERSION}-${TARGETOS}-${TARGETARCH}/kubectl-gs" && strip /usr/local/bin/kubectl-gs

# Install Teleport.
ARG TELEPORT_VERSION=v18.7.0
RUN wget "https://cdn.teleport.dev/teleport-${TELEPORT_VERSION}-${TARGETOS}-${TARGETARCH}-bin.tar.gz" --output-document - | tar --extract --gzip --directory /usr/local/bin --no-same-owner --strip-components 1 teleport/tsh && strip /usr/local/bin/tsh

# Install vendir.
ARG VENDIR_VERSION=v0.45.2
RUN wget "https://github.com/carvel-dev/vendir/releases/download/${VENDIR_VERSION}/vendir-${TARGETOS}-${TARGETARCH}" --output-document /usr/local/bin/vendir && chmod 755 /usr/local/bin/vendir && strip /usr/local/bin/vendir

# Add scripts.
COPY usr/local/bin/* /usr/local/bin/

# Change directory.
WORKDIR /wrk

# Set entrypoint.
ENTRYPOINT [ "/bin/zsh" ]
