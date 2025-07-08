# Stage 1: Build using Go 1.23 beta
FROM golang as builder

WORKDIR /src
COPY . .

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux go build -o /statsd_exporter .

# Stage 2: Minimal runtime image
FROM gcr.io/distroless/static:nonroot

COPY --from=builder /statsd_exporter /bin/statsd_exporter

USER nonroot
EXPOSE 9102
EXPOSE 8125/udp

ENTRYPOINT ["/bin/statsd_exporter"]
