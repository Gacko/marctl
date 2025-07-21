# Start from Alpine.
FROM alpine:3.22.1

# Provide target OS & architecture.
ARG TARGETOS
ARG TARGETARCH

# Install dependencies.
RUN apk add \
    bash \
    curl \
    git \
    helm \
    kubectl \
    make \
    python3 \
    yq

# Install vendir.
ENV VENDIR_VERSION=v0.43.2
RUN curl --silent --show-error --fail --location "https://github.com/carvel-dev/vendir/releases/download/${VENDIR_VERSION}/vendir-${TARGETOS}-${TARGETARCH}" --output /usr/local/bin/vendir && \
    chmod 755 /usr/local/bin/vendir

# Add pypass.
COPY pypass /usr/local/bin/pypass

# Change directory.
WORKDIR /wrk
