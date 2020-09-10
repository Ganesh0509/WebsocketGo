 
 # Start from the latest golang base image
 FROM golang:latest as builder

 # Add Maintainer Info
 LABEL maintainer="Ganesh <ganeshdkshth@gmail.com>"

 # Build Args
 ARG LOG_DIR=/app/logs

 # Create Log Directory
 RUN mkdir -p ${LOG_DIR}

 # Environment Variables
 ENV LOG_FILE_LOCATION=${LOG_DIR}/app.log

 # Set the Current Working Directory inside the container
 WORKDIR /app

 # Copy go mod , sum, webscoker.html files
 COPY go.mod go.sum webscoker.html ./

 # Copy the source from the current directory to the Working Directory inside the container
 COPY . .
 
 # Build the Go app
 RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

 ######## Start a new stage from scratch #######
FROM alpine:latest  

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/main .

# Expose port 8080 to the outside world
EXPOSE 8082

# Command to run the executable
CMD ["./main"] 