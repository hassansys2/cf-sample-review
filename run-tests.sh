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
        echo "📦 Starting tests with docker-compose..."
        docker-compose up --build -d
        
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
    echo "2. Copy all files to your web root"
    echo "3. Start your ColdFusion server"
    echo "4. Open: http://localhost:8500/test-runner.cfm"
    echo ""
    echo "📚 See README.md for detailed instructions"
fi

echo ""
echo "🎯 Expected Results:"
echo "✅ All security fixes verified"
echo "✅ Performance optimizations working"
echo "✅ Variable scope issues resolved"
echo "✅ Case consistency maintained" 