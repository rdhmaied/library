# Use the official Golang image as a build stage
FROM golang:1.23 AS builder

# Set the current working directory inside the container
WORKDIR /build

# Copy the Go module files and download the dependencies
COPY go.mod .
RUN go get -d -v .

# Copy the entire project into the container
COPY . .

# Build the gRPC server
RUN CGO_ENABLED=0 GOOS=linux go build -o server ./main.go

# Debug
RUN ls .

# Use a minimal base image to reduce the final image size
FROM scratch AS runtime

# Copy the compiled binary from the builder stage
COPY --from=builder /build/server .

# Expose the port on which the server will run
EXPOSE 50051
EXPOSE 2112

# Command to run the server when the container starts
CMD ["./server"]
