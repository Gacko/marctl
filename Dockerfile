# Start from Alpine.
FROM alpine:3.21.3

# Install dependencies.
RUN apk add \
    curl \
    kubectl \
    make \
    yq

# Change directory.
WORKDIR /root
