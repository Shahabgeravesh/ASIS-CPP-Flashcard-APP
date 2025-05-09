# Use the official Swift image as the base image
FROM swift:5.9

# Set the working directory
WORKDIR /app

# Copy the entire project
COPY . .

# Install Xcode command line tools
RUN xcode-select --install

# Set environment variables
ENV SWIFT_BUILD_DIR=/app/.build
ENV SWIFT_PACKAGE_DIR=/app

# Build the project
RUN swift build

# Expose any necessary ports
EXPOSE 8080

# Set the entry point
CMD ["swift", "run"] 