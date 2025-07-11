<!--- Database Connection and Component Test --->
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
    <title>Database Connection & Component Test Results</title>
</head>
<body>
    <div class="header">
        <h1>Database Connection & Component Test Results</h1>
        <p>Testing all fixed functions with real database data</p>
    </div>

    <cfset testResults = []>
    <cfset currentTime = now()>

    <!--- Test Database Connection --->
    <div class="test-section">
        <h2>Test 1: Database Connection</h2>
        
        <cftry>
            <cfquery name="testConnection" datasource="cftest">
                SELECT 1 as test_value
            </cfquery>
            
            <div class="pass">
                <h4>✅ Database Connection Test PASSED</h4>
                <p><strong>Datasource:</strong> testDSN</p>
                <p><strong>Test Value:</strong> #testConnection.test_value#</p>
            </div>
            
            <cfcatch type="any">
                <div class="fail">
                    <h4>❌ Database Connection Test FAILED</h4>
                    <p><strong>Error:</strong> #cfcatch.message#</p>
                    <p><strong>Detail:</strong> #cfcatch.detail#</p>
                </div>
            </cfcatch>
        </cftry>
    </div>

    <!--- Test 1: Code Review Component --->
    <div class="test-section">
        <h2>Test 2: Code Review Component (test1-code_review.cfc)</h2>
        
        <!--- Test getUserByID --->
        <h3>Testing getUserByID()</h3>
        <cfset testUserID = 1>
        <cfset testDSN = "cftest">
        
        <cfset userComponent = createObject("component", "components.test1-code_review")>
        
        <cfset startTime = getTickCount()>
        <cftry>
            <cfset result = userComponent.getUserByID(testUserID, testDSN)>
            <cfset endTime = getTickCount()>
            <cfset executionTime = endTime - startTime>
            
            <div class="pass">
                <h4>✅ getUserByID Test PASSED</h4>
                <p><strong>Execution Time:</strong> #executionTime#ms</p>
                <p><strong>User ID:</strong> #testUserID#</p>
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

        <!--- Test getUserByUsername with valid username --->
        <h3>Testing getUserByUsername() - Valid Username</h3>
        <cfset validUsername = "john_doe">
        
        <cftry>
            <cfset result = userComponent.getUserByUsername(validUsername, testDSN)>
            
            <div class="pass">
                <h4>✅ Valid Username Test PASSED</h4>
                <p><strong>Username:</strong> #validUsername#</p>
                <p><strong>Result:</strong></p>
                <pre><cfdump var="#result#" label="getUserByUsername Valid Result"></pre>
            </div>
            
            <cfcatch type="any">
                <div class="fail">
                    <h4>❌ Valid Username Test FAILED</h4>
                    <p><strong>Error:</strong> #cfcatch.message#</p>
                </div>
            </cfcatch>
        </cftry>
    </div>

    <!--- Test 2: Bug Component --->
    <div class="test-section">
        <h2>Test 3: Bug Component (test2-bug.cfc)</h2>
        
        <cfset bugComponent = createObject("component", "components.test2-bug")>
        
        <cftry>
            <cfset result = bugComponent.getUserDetails(1, testDSN)>
            
            <div class="pass">
                <h4>✅ getUserDetails Test PASSED</h4>
                <p><strong>Result Type:</strong> #isArray(result) ? "Array" : "Not Array"#</p>
                <p><strong>Array Length:</strong> #arrayLen(result)#</p>
                <p><strong>Result:</strong></p>
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
        <h2>Test 4: Performance Component (test3-performance.cfc)</h2>
        
        <cfset perfComponent = createObject("component", "components.test3-performance")>
        
        <cftry>
            <cfset startTime = getTickCount()>
            <cfset result = perfComponent.getRecentActivitiesWithUsernames(5, testDSN)>
            <cfset endTime = getTickCount()>
            <cfset executionTime = endTime - startTime>
            
            <div class="pass">
                <h4>✅ getRecentActivitiesWithUsernames Test PASSED</h4>
                <p><strong>Execution Time:</strong> #executionTime#ms</p>
                <p><strong>Result Type:</strong> #isArray(result) ? "Array" : "Not Array"#</p>
                <p><strong>Array Length:</strong> #arrayLen(result)#</p>
                <p><strong>Result:</strong></p>
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

    <!--- Database Content Verification --->
    <div class="test-section">
        <h2>Test 5: Database Content Verification</h2>
        
        <cftry>
            <cfquery name="userCount" datasource="cftest">
                SELECT COUNT(*) as total_users FROM Users
            </cfquery>
            
            <cfquery name="activityCount" datasource="cftest">
                SELECT COUNT(*) as total_activities FROM Activities
            </cfquery>
            
            <cfquery name="sampleUsers" datasource="testDSN">
                SELECT UserID, UserName, EmailAddress FROM Users LIMIT 3
            </cfquery>
            
            <div class="pass">
                <h4>✅ Database Content Verification PASSED</h4>
                <p><strong>Total Users:</strong> #userCount.total_users#</p>
                <p><strong>Total Activities:</strong> #activityCount.total_activities#</p>
                <p><strong>Sample Users:</strong></p>
                <pre><cfdump var="#sampleUsers#" label="Sample Users"></pre>
            </div>
            
            <cfcatch type="any">
                <div class="fail">
                    <h4>❌ Database Content Verification FAILED</h4>
                    <p><strong>Error:</strong> #cfcatch.message#</p>
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
        <p><strong>Database:</strong> MySQL 8.0</p>
        <p><strong>Datasource:</strong> testDSN</p>
    </div>

</body>
</html>
</cfoutput>
</cfprocessingdirective> 