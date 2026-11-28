# Start from Alpine.
FROM alpine:3.24.4

# Provide target OS & architecture.
ARG TARGETOS
ARG TARGETARCH

# Install dependencies.
RUN apk add --no-cache \
    git \
    go \
    python3 \
    zsh

# Extend PATH.
ENV PATH="/root/go/bin:${PATH}"

# Configure zsh.
COPY etc/zsh/zshrc.d/* /etc/zsh/zshrc.d/

# Add scripts.
COPY usr/local/bin/* /usr/local/bin/

# Change directory.
WORKDIR /wrk

# Set entrypoint.
ENTRYPOINT [ "/bin/zsh" ]
