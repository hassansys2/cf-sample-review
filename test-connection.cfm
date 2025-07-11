<!--- Test MySQL Connection --->
<cfoutput>
<h1>MySQL Connection Test</h1>

<cftry>
    <cfquery name="testQuery" datasource="cftest">
        SELECT NOW()
    </cfquery>
    
    <h2>✅ Connection Successful!</h2>
    <p><strong>Current Time:</strong> #testQuery['NOW()']#</p>
    
    <cfcatch type="any">
        <h2>❌ Connection Failed</h2>
        <p><strong>Error:</strong> #cfcatch.message#</p>
        <p><strong>Detail:</strong> #cfcatch.detail#</p>
        <p><strong>Type:</strong> #cfcatch.type#</p>
    </cfcatch>
</cftry>

<h2>Available Datasources</h2>
<cftry>
    <cfset dsns = getApplicationSettings().datasources>
    <cfdump var="#dsns#" label="Application Datasources">
    <cfcatch type="any">
        <p>Could not retrieve datasource information: #cfcatch.message#</p>
    </cfcatch>
</cftry>
</cfoutput> 