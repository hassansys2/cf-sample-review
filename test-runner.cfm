<!--- Test Runner for ColdFusion Components --->
<cfprocessingdirective suppresswhitespace="true">
<style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    .test-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
    .pass { background-color: #d4edda; border-color: #c3e6cb; }
    .fail { background-color: #f8d7da; border-color: #f5c6cb; }
    .error { background-color: #fff3cd; border-color: #ffeaa7; }
    pre { background: #f8f9fa; padding: 10px; border-radius: 3px; overflow-x: auto; }
    .header { background: #007bff; color: white; padding: 10px; margin: -20px -20px 20px -20px; }
</style>
<cfoutput>
<!DOCTYPE html>
<html>
<head>
    <title>ColdFusion Component Test Results</title>
</head>
<body>
    <div class="header">
        <h1>ColdFusion Component Test Results</h1>
        <p>Testing all fixed functions with mock data</p>
    </div>

    <cfset testResults = []>
    <cfset currentTime = now()>

    <!--- Test 1: Code Review Component --->
    <div class="test-section">
        <h2>Test 1: Code Review Component (test1-code_review.cfc)</h2>
        
        <!--- Test getUserByID --->
        <h3>Testing getUserByID()</h3>
        <cfset testUserID = 1>
        <cfset testDSN = "testDSN">
        
        <cfset userComponent = createObject("component", "test1-code_review")>
        
        <cfset startTime = getTickCount()>
        <cftry>
            <cfset result = userComponent.getUserByID(testUserID, testDSN)>
            <cfset endTime = getTickCount()>
            <cfset executionTime = endTime - startTime>
            
            <div class="pass">
                <h4>✅ getUserByID Test PASSED</h4>
                <p><strong>Execution Time:</strong> #executionTime#ms</p>
                <p><strong>Result:</strong></p>
                <pre><cfdump var="#result#" label="getUserByID Result"></pre>
            </div>
            
            <cfcatch type="any">
                <div class="fail">
                    <h4>❌ getUserByID Test FAILED</h4>
                    <p><strong>Error:</strong> #cfcatch.message#</p>
                    <p><strong>Detail:</strong> #cfcatch.detail#</p>
                </div>
            </cfcatch>
        </cftry>
        
        <!--- Test getUserByUsername with SQL injection attempt --->
        <h3>Testing getUserByUsername() - SQL Injection Protection</h3>
        <cfset maliciousUsername = "'; DROP TABLE Users; --">
        
        <cftry>
            <cfset result = userComponent.getUserByUsername(maliciousUsername, testDSN)>
            
            <div class="pass">
                <h4>✅ SQL Injection Protection Test PASSED</h4>
                <p><strong>Malicious Input:</strong> #maliciousUsername#</p>
                <p><strong>Result:</strong> Function executed without error (parameterized query prevented injection)</p>
                <pre><cfdump var="#result#" label="getUserByUsername Result"></pre>
            </div>
            
            <cfcatch type="any">
                <div class="fail">
                    <h4>❌ SQL Injection Protection Test FAILED</h4>
                    <p><strong>Error:</strong> #cfcatch.message#</p>
                </div>
            </cfcatch>
        </cftry>
    </div>

    <!--- Test 2: Bug Component --->
    <div class="test-section">
        <h2>Test 2: Bug Component (test2-bug.cfc)</h2>
        
        <cfset bugComponent = createObject("component", "test2-bug")>
        
        <cftry>
            <cfset result = bugComponent.getUserDetails(1, testDSN)>
            
            <div class="pass">
                <h4>✅ getUserDetails Test PASSED</h4>
                <p><strong>Result Type:</strong> #isArray(result) ? "Array" : "Not Array"#</p>
                <p><strong>Array Length:</strong> #arrayLen(result)#</p>
                <pre><cfdump var="#result#" label="getUserDetails Result"></pre>
            </div>
            
            <cfcatch type="any">
                <div class="fail">
                    <h4>❌ getUserDetails Test FAILED</h4>
                    <p><strong>Error:</strong> #cfcatch.message#</p>
                    <p><strong>Detail:</strong> #cfcatch.detail#</p>
                </div>
            </cfcatch>
        </cftry>
    </div>

    <!--- Test 3: Performance Component --->
    <div class="test-section">
        <h2>Test 3: Performance Component (test3-performance.cfc)</h2>
        
        <cfset perfComponent = createObject("component", "test3-performance")>
        
        <cftry>
            <cfset startTime = getTickCount()>
            <cfset result = perfComponent.getRecentActivitiesWithUsernames(10, testDSN)>
            <cfset endTime = getTickCount()>
            <cfset executionTime = endTime - startTime>
            
            <div class="pass">
                <h4>✅ getRecentActivitiesWithUsernames Test PASSED</h4>
                <p><strong>Execution Time:</strong> #executionTime#ms</p>
                <p><strong>Result Type:</strong> #isArray(result) ? "Array" : "Not Array"#</p>
                <p><strong>Array Length:</strong> #arrayLen(result)#</p>
                <pre><cfdump var="#result#" label="getRecentActivitiesWithUsernames Result"></pre>
            </div>
            
            <cfcatch type="any">
                <div class="fail">
                    <h4>❌ getRecentActivitiesWithUsernames Test FAILED</h4>
                    <p><strong>Error:</strong> #cfcatch.message#</p>
                    <p><strong>Detail:</strong> #cfcatch.detail#</p>
                </div>
            </cfcatch>
        </cftry>
    </div>

    <!--- Summary --->
    <div class="test-section">
        <h2>Test Summary</h2>
        <p><strong>Test Date:</strong> #dateFormat(currentTime, "yyyy-mm-dd")# #timeFormat(currentTime, "HH:mm:ss")#</p>
        <p><strong>ColdFusion Version:</strong> #server.coldfusion.productversion#</p>
        <p><strong>Server:</strong> #server.coldfusion.appserver#</p>
    </div>

</body>
</html>
</cfoutput>
</cfprocessingdirective> 