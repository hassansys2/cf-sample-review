#!/bin/bash

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
while ! mysqladmin ping -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" --silent 2>/dev/null; do
    echo "MySQL not ready yet, waiting..."
    sleep 5
done
echo "MySQL is ready!"

# Create Lucee datasource configuration
echo "Configuring MySQL datasource..."

# Create the datasource configuration directory
mkdir -p /opt/lucee/server/lucee-server/context/context

# Create server context configuration with datasource
cat > /opt/lucee/server/lucee-server/context/context/admin/server.cfm << EOF
<cfset this.name="cf-test-server">
<cfset this.datasources.testDSN.server="$DB_HOST">
<cfset this.datasources.testDSN.port="$DB_PORT">
<cfset this.datasources.testDSN.database="$DB_NAME">
<cfset this.datasources.testDSN.username="$DB_USER">
<cfset this.datasources.testDSN.password="$DB_PASSWORD">
<cfset this.datasources.testDSN.driver="mysql">
<cfset this.datasources.testDSN.connectionLimit="10">
<cfset this.datasources.testDSN.connectionTimeout="1">
<cfset this.datasources.testDSN.timezone="UTC">
<cfset this.datasources.testDSN.class="com.mysql.cj.jdbc.Driver">
<cfset this.datasources.testDSN.url="jdbc:mysql://$DB_HOST:$DB_PORT/$DB_NAME?useSSL=false&serverTimezone=UTC">
EOF

echo "Datasource configuration complete!"

# Start Lucee/Tomcat
echo "Starting Lucee server..."
exec catalina.sh run 