#!/bin/bash

# Add MySQL datasource to Lucee configuration
CONFIG_FILE="/opt/lucee/server/lucee-server/context/lucee-server.xml"

# Create the datasource XML configuration
DATASOURCE_XML='        <data-source allow="*" blob="true" class="com.mysql.cj.jdbc.Driver" clob="true" connectionLimit="0" connectionTimeout="1" database="cftest" dbdriver="mysql" host="mysql" name="cftest" password="password" port="3306" storage="true" username="root" validate="false" verify="false"/>'

# Replace the empty data-sources section with our datasource
sed -i "s|<data-sources psq=\"false\">|<data-sources psq=\"false\">\n$DATASOURCE_XML|" $CONFIG_FILE

echo "Datasource configuration added successfully!"
echo "Restarting Lucee server..."

# Restart the Lucee server to apply changes
pkill -f "java.*lucee"
sleep 2
/opt/lucee/server/lucee-server/bin/lucee start 