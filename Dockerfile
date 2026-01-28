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
    git \
    go \
    grep \
    helm \
    make \
    python3 \
    zsh

# Extend PATH.
ENV PATH="/root/go/bin:${PATH}"

# Install devctl.
ENV DEVCTL_VERSION=v7.30.2
RUN wget "https://github.com/giantswarm/devctl/releases/download/${DEVCTL_VERSION}/devctl-${DEVCTL_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" --output-document - | tar --extract --gzip --directory /usr/local/bin --strip-components 1 "devctl-${DEVCTL_VERSION}-${TARGETOS}-${TARGETARCH}/devctl"

# Install helm-docs.
ENV HELM_DOCS_VERSION=v1.14.2
RUN wget "https://github.com/norwoodj/helm-docs/releases/download/${HELM_DOCS_VERSION}/helm-docs_${HELM_DOCS_VERSION#v}_${TARGETOS}_${TARGETARCH/amd64/x86_64}.tar.gz" --output-document - | tar --extract --gzip --directory /usr/local/bin helm-docs

# Install helm-schema-gen.
ENV HELM_SCHEMA_GEN_VERSION=v0.0.9
RUN wget "https://github.com/mihaisee/helm-schema-gen/releases/download/${HELM_SCHEMA_GEN_VERSION#v}/helm-schema-gen_${HELM_SCHEMA_GEN_VERSION#v}_${TARGETOS}_${TARGETARCH/amd64/x86_64}.tar.gz" --output-document - | tar --extract --gzip --directory /usr/local/bin helm-schema-gen

# Install vendir.
ENV VENDIR_VERSION=v0.45.1
RUN wget "https://github.com/carvel-dev/vendir/releases/download/${VENDIR_VERSION}/vendir-${TARGETOS}-${TARGETARCH}" --output-document /usr/local/bin/vendir && chmod 755 /usr/local/bin/vendir

# Add marctl.
COPY marctl /usr/local/bin/marctl

# Add pypass.
COPY pypass /usr/local/bin/pypass

# Change directory.
WORKDIR /wrk

# Set entrypoint.
ENTRYPOINT [ "/bin/zsh" ]
