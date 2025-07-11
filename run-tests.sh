#!/bin/bash

echo "🚀 ColdFusion Component Test Runner"
echo "=================================="
echo ""

# Check if Docker is available
if command -v docker &> /dev/null; then
    echo "🐳 Docker detected - Using Docker method"
    echo ""
    
    # Check if docker-compose is available
    if command -v docker-compose &> /dev/null; then
        echo "📦 Starting complete testing environment with database..."
        docker-compose down 2>/dev/null
        docker-compose up --build -d
        
        echo "⏳ Waiting for services to start..."
        echo "   - MySQL database (may take 30-60 seconds on first run)"
        echo "   - ColdFusion server with datasource configuration"
        sleep 30
        
        echo "🌐 Opening database test runner in browser..."
        if command -v open &> /dev/null; then
            open http://localhost:8080/database-test.cfm
        elif command -v xdg-open &> /dev/null; then
            xdg-open http://localhost:8080/database-test.cfm
        else
            echo "📋 Please open: http://localhost:8080/database-test.cfm"
        fi
        
        echo ""
        echo "✅ Complete testing environment is running!"
        echo "📊 Database test results: http://localhost:8080/database-test.cfm"
        echo "🔬 Unit tests: http://localhost:8080/unit-tests.cfm"
        echo "📋 Original test runner: http://localhost:8080/test-runner.cfm"
        echo ""
        echo "🗄️  Database Info:"
        echo "   - Host: localhost:3306"
        echo "   - Database: cf_test_db"
        echo "   - Username: cfuser"
        echo "   - Password: cfpassword"
        echo ""
        echo "To stop: docker-compose down"
        
    else
        echo "📦 Starting tests with Docker..."
        docker build -t cf-test .
        docker run -d -p 8080:8080 --name cf-test-container cf-test
        
        echo "⏳ Waiting for server to start..."
        sleep 10
        
        echo "🌐 Opening test runner in browser..."
        if command -v open &> /dev/null; then
            open http://localhost:8080/test-runner.cfm
        elif command -v xdg-open &> /dev/null; then
            xdg-open http://localhost:8080/test-runner.cfm
        else
            echo "📋 Please open: http://localhost:8080/test-runner.cfm"
        fi
        
        echo ""
        echo "✅ Tests are running!"
        echo "📊 View results at: http://localhost:8080/test-runner.cfm"
        echo "🔬 Unit tests at: http://localhost:8080/unit-tests.cfm"
        echo ""
        echo "To stop: docker stop cf-test-container && docker rm cf-test-container"
    fi
    
else
    echo "❌ Docker not found"
    echo ""
    echo "📋 Manual setup required:"
    echo "1. Install ColdFusion Server (Adobe CF or Lucee)"
    echo "2. Install MySQL database"
    echo "3. Configure datasource 'testDSN'"
    echo "4. Copy all files to your web root"
    echo "5. Open: http://localhost:8500/database-test.cfm"
    echo ""
    echo "📚 See README.md for detailed instructions"
fi

echo ""
echo "🎯 Expected Results:"
echo "✅ Database connection established"
echo "✅ All security fixes verified"
echo "✅ Performance optimizations working"
echo "✅ Variable scope issues resolved"
echo "✅ Case consistency maintained"
echo "✅ Real data returned from database" 