FROM golang:1.19 as builder
WORKDIR /app
ADD . .
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -installsuffix cgo -o sample-controller main.go

# Based from alpine-glibc
FROM frolvlad/alpine-glibc:glibc-2.35
# Labels
LABEL "maintainer"="Shenle Lu <lushenle@gmail.com>" \
    "org.opencontainers.image.authors"="Shenle Lu <lushenle@gmail.com>" \
    "org.opencontainers.image.vendor"="Shenle Lu <lushenle@gmail.com>" \
    "org.opencontainers.image.ref.name"="sample-controller" \
    "org.opencontainers.image.title"="resource manager v0.1" \
    "org.opencontainers.image.description"="k8s resource manager tool"
# Working dir
WORKDIR /app
# Copy app from builder
COPY --from=builder /app/sample-controller .

# Create user
RUN addgroup -g 65535 ishenle && \
    adduser --shell /sbin/nologin --disabled-password \
    --no-create-home --uid 65535 --ingroup ishenle ishenle

# Run the process as ishenle
USER ishenle

# Start app
CMD ["/app/sample-controller"]
