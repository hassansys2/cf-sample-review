<!--- Test MySQL Connection with IP --->
<cfoutput>
<h1>MySQL Connection Test (IP Address)</h1>

<cftry>
    <cfquery name="testQuery" datasource="cftest">
        SELECT 1 as test_value, NOW() as current_time
    </cfquery>
    
    <h2>✅ Connection Successful!</h2>
    <p><strong>Test Value:</strong> #testQuery.test_value#</p>
    <p><strong>Current Time:</strong> #testQuery.current_time#</p>
    
    <cfcatch type="any">
        <h2>❌ Connection Failed</h2>
        <p><strong>Error:</strong> #cfcatch.message#</p>
        <p><strong>Detail:</strong> #cfcatch.detail#</p>
        <p><strong>Type:</strong> #cfcatch.type#</p>
    </cfcatch>
</cftry>

<h2>Testing Direct Connection</h2>
<cftry>
    <cfset connectionString = "jdbc:mysql://172.19.0.2:3306/cftest?user=root&password=password">
    <cfset driverClass = "com.mysql.cj.jdbc.Driver">
    
    <cfset connection = createObject("java", "java.sql.DriverManager").getConnection(connectionString)>
    <cfset statement = connection.createStatement()>
    <cfset resultSet = statement.executeQuery("SELECT 1 as test_value, NOW() as current_time")>
    
    <cfif resultSet.next()>
        <h3>✅ Direct Java Connection Successful!</h3>
        <p><strong>Test Value:</strong> #resultSet.getInt("test_value")#</p>
        <p><strong>Current Time:</strong> #resultSet.getString("current_time")#</p>
    </cfif>
    
    <cfset resultSet.close()>
    <cfset statement.close()>
    <cfset connection.close()>
    
    <cfcatch type="any">
        <h3>❌ Direct Java Connection Failed</h3>
        <p><strong>Error:</strong> #cfcatch.message#</p>
        <p><strong>Detail:</strong> #cfcatch.detail#</p>
    </cfcatch>
</cftry>
</cfoutput> 