# Start from Alpine.
FROM alpine:3.22.1

# Provide target OS & architecture.
ARG TARGETOS
ARG TARGETARCH

# Install dependencies.
RUN apk add \
    bash \
    coreutils \
    curl \
    diffutils \
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

# Install vendir.
ENV VENDIR_VERSION=v0.43.2
RUN curl --silent --show-error --fail --location "https://github.com/carvel-dev/vendir/releases/download/${VENDIR_VERSION}/vendir-${TARGETOS}-${TARGETARCH}" --output /usr/local/bin/vendir && \
    chmod 755 /usr/local/bin/vendir

# Install devctl.
ENV DEVCTL_VERSION=v7.18.1
RUN curl --silent --show-error --fail --location "https://github.com/giantswarm/devctl/releases/download/${DEVCTL_VERSION}/devctl-${DEVCTL_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" | tar --extract --gzip --directory /usr/local/bin --strip-components 1 "devctl-${DEVCTL_VERSION}-${TARGETOS}-${TARGETARCH}/devctl"

# Add pypass.
COPY pypass /usr/local/bin/pypass

# Change directory.
WORKDIR /wrk

# Set entrypoint.
ENTRYPOINT [ "/bin/zsh" ]
