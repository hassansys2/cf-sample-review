#!/bin/bash

# ColdFusion Code Test - Automated Build and Test Script
# This script builds the Docker environment and runs all tests automatically

set -e  # Exit on any error

echo "🚀 Starting ColdFusion Code Test - Automated Build and Test"
echo "=========================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    print_status "Checking Docker availability..."
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running or not available"
        exit 1
    fi
    print_success "Docker is available"
}

# Function to clean up any existing containers
cleanup() {
    print_status "Cleaning up any existing containers..."
    docker-compose down --remove-orphans > /dev/null 2>&1 || true
    print_success "Cleanup completed"
}

# Function to build and start containers
build_environment() {
    print_status "Building and starting Docker environment..."
    
    # Build and start containers
    docker-compose up -d --build
    
    print_status "Waiting for containers to be ready..."
    sleep 10
    
    # Wait for MySQL to be healthy
    print_status "Waiting for MySQL to be ready..."
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if docker-compose exec -T mysql mysqladmin ping -h localhost -u root -prootpassword > /dev/null 2>&1; then
            print_success "MySQL is ready"
            break
        fi
        
        if [ $attempt -eq $max_attempts ]; then
            print_error "MySQL failed to start within expected time"
            exit 1
        fi
        
        print_status "Waiting for MySQL... (attempt $attempt/$max_attempts)"
        sleep 2
        attempt=$((attempt + 1))
    done
    
    # Wait for Lucee to be ready
    print_status "Waiting for Lucee ColdFusion to be ready..."
    max_attempts=30
    attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s http://localhost:8080/ --max-time 5 > /dev/null 2>&1; then
            print_success "Lucee ColdFusion is ready"
            break
        fi
        
        if [ $attempt -eq $max_attempts ]; then
            print_error "Lucee ColdFusion failed to start within expected time"
            exit 1
        fi
        
        print_status "Waiting for Lucee... (attempt $attempt/$max_attempts)"
        sleep 2
        attempt=$((attempt + 1))
    done
}

# Function to run tests
run_tests() {
    print_status "Running comprehensive test suite..."
    
    # Test 1: Component compilation and basic functionality
    print_status "Running component compilation tests..."
    local test_result=$(curl -s http://localhost:8080/tests/simple-test.cfm --max-time 10)
    if echo "$test_result" | grep -q "PASSED"; then
        print_success "Component compilation tests passed"
    else
        print_error "Component compilation tests failed"
        echo "$test_result"
        return 1
    fi
    
    # Test 2: Unit tests (security, scope, performance)
    print_status "Running unit tests..."
    local unit_result=$(curl -s http://localhost:8080/tests/unit-tests.cfm --max-time 10)
    if echo "$unit_result" | grep -q "PASS:"; then
        print_success "Unit tests passed"
    else
        print_error "Unit tests failed"
        echo "$unit_result"
        return 1
    fi
    
    # Test 3: Database integration tests
    print_status "Running database integration tests..."
    local db_result=$(curl -s http://localhost:8080/tests/database-test.cfm --max-time 10)
    if echo "$db_result" | grep -q "PASSED"; then
        print_success "Database integration tests passed"
    else
        print_error "Database integration tests failed"
        echo "$db_result"
        return 1
    fi
    
    # Test 4: Comprehensive test runner
    print_status "Running comprehensive test runner..."
    local comprehensive_result=$(curl -s http://localhost:8080/tests/test-runner.cfm --max-time 10)
    if echo "$comprehensive_result" | grep -q "PASSED"; then
        print_success "Comprehensive tests passed"
    else
        print_error "Comprehensive tests failed"
        echo "$comprehensive_result"
        return 1
    fi
}

# Function to generate test report
generate_report() {
    print_status "Generating test report..."
    
    local report_file="test-report-$(date +%Y%m%d-%H%M%S).html"
    
    cat > "$report_file" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>ColdFusion Code Test Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #007bff; color: white; padding: 20px; margin: -20px -20px 20px -20px; }
        .test-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .pass { background-color: #d4edda; border-color: #c3e6cb; }
        .fail { background-color: #f8d7da; border-color: #f5c6cb; }
        .summary { background-color: #e2e3e5; border-color: #d6d8db; }
        pre { background: #f8f9fa; padding: 10px; border-radius: 3px; overflow-x: auto; }
    </style>
</head>
<body>
    <div class="header">
        <h1>ColdFusion Code Test Report</h1>
        <p>Generated on: $(date)</p>
    </div>
    
    <div class="test-section summary">
        <h2>Test Summary</h2>
        <p><strong>Test Date:</strong> $(date)</p>
        <p><strong>Environment:</strong> Docker with Lucee ColdFusion and MySQL</p>
        <p><strong>Status:</strong> All tests completed successfully</p>
    </div>
    
    <div class="test-section">
        <h2>Component Tests</h2>
        <iframe src="http://localhost:8080/tests/simple-test.cfm" width="100%" height="600" frameborder="0"></iframe>
    </div>
    
    <div class="test-section">
        <h2>Unit Tests</h2>
        <iframe src="http://localhost:8080/tests/unit-tests.cfm" width="100%" height="600" frameborder="0"></iframe>
    </div>
    
    <div class="test-section">
        <h2>Database Tests</h2>
        <iframe src="http://localhost:8080/tests/database-test.cfm" width="100%" height="600" frameborder="0"></iframe>
    </div>
    
    <div class="test-section">
        <h2>Comprehensive Tests</h2>
        <iframe src="http://localhost:8080/tests/test-runner.cfm" width="100%" height="600" frameborder="0"></iframe>
    </div>
</body>
</html>
EOF
    
    print_success "Test report generated: $report_file"
    print_status "You can open this file in your browser to view detailed results"
}

# Function to show container status
show_status() {
    print_status "Container Status:"
    docker-compose ps
    
    print_status "Container Logs (last 10 lines):"
    docker-compose logs --tail=10
}

# Main execution
main() {
    echo ""
    print_status "Starting automated build and test process..."
    
    # Check prerequisites
    check_docker
    
    # Clean up
    cleanup
    
    # Build and start environment
    build_environment
    
    # Run tests
    if run_tests; then
        print_success "All tests passed successfully!"
        generate_report
        show_status
        echo ""
        print_success "🎉 ColdFusion Code Test completed successfully!"
        print_status "Access the test results at:"
        print_status "  - http://localhost:8080/tests/test-runner.cfm"
        print_status "  - http://localhost:8080/tests/unit-tests.cfm"
        print_status "  - http://localhost:8080/tests/simple-test.cfm"
        print_status "  - http://localhost:8080/tests/database-test.cfm"
    else
        print_error "❌ Some tests failed!"
        show_status
        exit 1
    fi
}

# Run main function
main "$@" 