# Start from Alpine.
FROM alpine:3.23.3

# Provide target OS & architecture.
ARG TARGETOS
ARG TARGETARCH

# Install dependencies.
RUN apk add --no-cache \
#     bash \
#     coreutils \
#     curl \
#     diffutils \
#     git \
#     github-cli \
    go \
#     grep \
    helm \
#     kubectl \
#     make \
    python3 \
#     yq \
    zsh

# Install helm-docs.
ENV HELM_DOCS_VERSION=v1.14.2
RUN wget "https://github.com/norwoodj/helm-docs/releases/download/${HELM_DOCS_VERSION}/helm-docs_${HELM_DOCS_VERSION#v}_${TARGETOS}_${TARGETARCH}.tar.gz" --output-document - | tar --extract --gzip --directory /usr/local/bin helm-docs

# Install vendir.
ENV VENDIR_VERSION=v0.45.0
RUN wget "https://github.com/carvel-dev/vendir/releases/download/${VENDIR_VERSION}/vendir-${TARGETOS}-${TARGETARCH}" --output-document /usr/local/bin/vendir && chmod 755 /usr/local/bin/vendir

# Install devctl.
ENV DEVCTL_VERSION=v7.30.0
RUN wget "https://github.com/giantswarm/devctl/releases/download/${DEVCTL_VERSION}/devctl-${DEVCTL_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" --output-document - | tar --extract --gzip --directory /usr/local/bin --strip-components 1 "devctl-${DEVCTL_VERSION}-${TARGETOS}-${TARGETARCH}/devctl"

# Add pypass.
COPY pypass /usr/local/bin/pypass

# Change directory.
WORKDIR /wrk

# Set entrypoint.
ENTRYPOINT [ "/bin/zsh" ]
