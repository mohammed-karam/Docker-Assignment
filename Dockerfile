# Stage 1: The "builder" stage
# We use a Go image to build our app
FROM golang:1.21-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go module files
COPY go.mod ./

# Download the dependencies
RUN go mod download

# Copy all your Go source code
COPY *.go ./

# Build the Go app. 
# CGO_ENABLED=0 and GOOS=linux are important for creating a static binary
# that can run on a minimal image.
RUN CGO_ENABLED=0 GOOS=linux go build -o /go-app .

# ---

# Stage 2: The "final" stage
# We use a minimal "alpine" image, which is very small
FROM alpine:latest

# Set the working directory
WORKDIR /root/

# Copy *only* the built application from the "builder" stage
COPY --from=builder /go-app .

# Expose port 8080 to the outside world
EXPOSE 8080

# The command to run when the container starts
CMD ["./go-app"]