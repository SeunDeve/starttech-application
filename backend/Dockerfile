# ─── Stage 1: Builder ───────────────────────────────────────────────────────
FROM golang:1.25-alpine AS builder

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copy dependency files first for better layer caching
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build statically linked binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-w -s" \
    -o ./bin/starttech-api \
    main.go

# ─── Stage 2: Final lean image ──────────────────────────────────────────────
FROM alpine:3.20

WORKDIR /app

# Copy CA certificates for HTTPS/MongoDB TLS
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy compiled binary
COPY --from=builder /app/bin/starttech-api .

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Expose application port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

ENTRYPOINT ["./starttech-api"]