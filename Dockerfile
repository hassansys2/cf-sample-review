FROM lucee/lucee:5.4

# Copy all files to the web directory
COPY . /var/www/

# Expose port 8080
EXPOSE 8080

# Set working directory
WORKDIR /var/www

# Health check to ensure server is running
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Default command to start Lucee
CMD ["catalina.sh", "run"] 