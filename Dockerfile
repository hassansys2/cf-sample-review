FROM lucee/lucee:5.4

# Install MySQL JDBC driver and mysql-client
RUN apt-get update && apt-get install -y wget mysql-client && \
    mkdir -p /opt/lucee/server/lucee-server/context/lib && \
    wget -O /opt/lucee/server/lucee-server/context/lib/mysql-connector-java.jar \
    https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar && \
    apt-get remove -y wget && apt-get autoremove -y && apt-get clean

# Copy all files to the web directory
COPY . /var/www/

# Copy datasource configuration script
COPY configure-datasource.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/configure-datasource.sh

# Expose port 8080
EXPOSE 8080

# Set working directory
WORKDIR /var/www

# Health check to ensure server is running
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Default command to start Lucee with datasource configuration
CMD ["/usr/local/bin/configure-datasource.sh"] 