# Start from Alpine.
FROM alpine:3.24.1

# Provide target OS & architecture.
ARG TARGETOS
ARG TARGETARCH

# Install dependencies.
RUN apk add --no-cache \
    diffutils \
    findutils \
    gcompat \
    git \
    github-cli \
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

# Install clusterctl.
# dependency:kubernetes-sigs/cluster-api
ARG CLUSTERCTL_VERSION=1.13.3
RUN wget "https://github.com/kubernetes-sigs/cluster-api/releases/download/v${CLUSTERCTL_VERSION}/clusterctl-${TARGETOS}-${TARGETARCH}" --output-document /usr/local/bin/clusterctl && chmod 755 /usr/local/bin/clusterctl && strip /usr/local/bin/clusterctl

# Install devctl.
# dependency:giantswarm/devctl
ARG DEVCTL_VERSION=8.33.6
ENV DEVCTL_UNSAFE_FORCE_VERSION=${DEVCTL_VERSION}
RUN wget "https://github.com/giantswarm/devctl/releases/download/v${DEVCTL_VERSION}/devctl-${TARGETOS}-${TARGETARCH}" --output-document /usr/local/bin/devctl && chmod 755 /usr/local/bin/devctl && strip /usr/local/bin/devctl

# Install gitsemver.
# dependency:giantswarm/gitsemver
ARG GITSEMVER_VERSION=2.0.1
RUN wget "https://github.com/giantswarm/gitsemver/releases/download/v${GITSEMVER_VERSION}/gitsemver-${TARGETOS}-${TARGETARCH}" --output-document /usr/local/bin/gitsemver && chmod 755 /usr/local/bin/gitsemver && strip /usr/local/bin/gitsemver

# Install helm-docs.
# dependency:norwoodj/helm-docs
ARG HELM_DOCS_VERSION=1.14.2
RUN wget "https://github.com/norwoodj/helm-docs/releases/download/v${HELM_DOCS_VERSION}/helm-docs_${HELM_DOCS_VERSION}_${TARGETOS}_${TARGETARCH/amd64/x86_64}.tar.gz" --output-document - | tar --extract --gzip --directory /usr/local/bin --no-same-owner helm-docs && strip /usr/local/bin/helm-docs

# Install helm-schema-gen.
# dependency:mihaisee/helm-schema-gen
ARG HELM_SCHEMA_GEN_VERSION=0.0.9
RUN wget "https://github.com/mihaisee/helm-schema-gen/releases/download/${HELM_SCHEMA_GEN_VERSION}/helm-schema-gen_${HELM_SCHEMA_GEN_VERSION}_${TARGETOS}_${TARGETARCH/amd64/x86_64}.tar.gz" --output-document - | tar --extract --gzip --directory /usr/local/bin --no-same-owner helm-schema-gen && strip /usr/local/bin/helm-schema-gen

# Install kubectl-gs.
# dependency:giantswarm/kubectl-gs
ARG KUBECTL_GS_VERSION=5.6.4
RUN wget "https://github.com/giantswarm/kubectl-gs/releases/download/v${KUBECTL_GS_VERSION}/kubectl-gs-v${KUBECTL_GS_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" --output-document - | tar --extract --gzip --directory /usr/local/bin --no-same-owner --strip-components 1 "kubectl-gs-v${KUBECTL_GS_VERSION}-${TARGETOS}-${TARGETARCH}/kubectl-gs" && strip /usr/local/bin/kubectl-gs

# Install Teleport.
# dependency:gravitational/teleport
ARG TELEPORT_VERSION=18.10.0
RUN wget "https://cdn.teleport.dev/teleport-v${TELEPORT_VERSION}-${TARGETOS}-${TARGETARCH}-bin.tar.gz" --output-document - | tar --extract --gzip --directory /usr/local/bin --no-same-owner --strip-components 1 teleport/tsh && strip /usr/local/bin/tsh

# Install vendir.
# dependency:carvel-dev/vendir
ARG VENDIR_VERSION=0.46.0
RUN wget "https://github.com/carvel-dev/vendir/releases/download/v${VENDIR_VERSION}/vendir-${TARGETOS}-${TARGETARCH}" --output-document /usr/local/bin/vendir && chmod 755 /usr/local/bin/vendir && strip /usr/local/bin/vendir

# Add scripts.
COPY usr/local/bin/* /usr/local/bin/

# Change directory.
WORKDIR /wrk

# Set entrypoint.
ENTRYPOINT [ "/bin/zsh" ]
