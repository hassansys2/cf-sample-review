#!/bin/bash

# ColdFusion Code Test - Fully Automated Build, Test, and Cleanup
# This script builds the Docker environment, runs all tests, and automatically cleans up

set -e  # Exit on any error

echo "🚀 Starting ColdFusion Code Test - Fully Automated Build, Test, and Cleanup"
echo "========================================================================"

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
        print_error "Docker is not running or not accessible"
        exit 1
    fi
    print_success "Docker is available"
}

# Function to cleanup existing containers
cleanup() {
    print_status "Cleaning up any existing containers..."
    if docker-compose down --remove-orphans --volumes > /dev/null 2>&1; then
        print_success "Cleanup completed"
    else
        print_warning "No existing containers to clean up"
    fi
}

# Function to build and start environment
build_environment() {
    print_status "Building and starting Docker environment..."
    
    if docker-compose up -d --build; then
        print_success "Docker environment started successfully"
    else
        print_error "Failed to start Docker environment"
        exit 1
    fi
    
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
    print_status "Running comprehensive test suite for the three main components..."
    
    # Test: Detailed component tests for test1-code_review.cfc, test2-bug.cfc, and test3-performance.cfc
    print_status "Running detailed component tests..."
    local test_result=$(curl -s http://localhost:8080/tests/detailed-test.cfm --max-time 15)
    if echo "$test_result" | grep -q "PASSED"; then
        print_success "Detailed component tests passed"
        echo ""
        print_status "Component Analysis Summary:"
        echo "$test_result" | grep -A 2 -B 2 "✅\|❌\|🔍\|📋\|🔧\|🔒\|🐛\|⚡" | head -20
    else
        print_error "Detailed component tests failed"
        echo "$test_result"
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
        <p><strong>Mode:</strong> Fully automated build-test-cleanup</p>
        <p><strong>Components Tested:</strong> test1-code_review.cfc, test2-bug.cfc, test3-performance.cfc</p>
    </div>
    
    <div class="test-section">
        <h2>Component Tests</h2>
        <p>Detailed component tests for the three main components completed successfully.</p>
        <ul>
            <li><strong>test1-code_review.cfc:</strong> Security fixes, SQL injection prevention, variable scope</li>
            <li><strong>test2-bug.cfc:</strong> Bug fixes and code improvements</li>
            <li><strong>test3-performance.cfc:</strong> Performance optimization, N+1 query resolution</li>
        </ul>
    </div>
</body>
</html>
EOF
    
    print_success "Test report generated: $report_file"
}

# Function to cleanup containers
cleanup_after_tests() {
    print_status "Cleaning up containers and resources..."
    
    if docker-compose down --remove-orphans --volumes; then
        print_success "Containers stopped and removed successfully"
    else
        print_warning "Some containers may still be running"
    fi
    
    # Remove any dangling images
    if docker image prune -f > /dev/null 2>&1; then
        print_success "Dangling images cleaned up"
    fi
    
    print_success "Cleanup completed"
}

# Main execution
main() {
    echo ""
    print_status "Starting fully automated build, test, and cleanup process..."
    
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
        echo ""
        print_success "🎉 ColdFusion Code Test completed successfully!"
        print_status "Test report generated. Cleaning up containers..."
        
        # Always cleanup after successful tests
        cleanup_after_tests
        
        print_success "✅ Build-Test-Cleanup cycle completed successfully!"
        print_status "All containers cleaned up. System resources freed."
    else
        print_error "❌ Some tests failed!"
        echo ""
        print_status "Cleaning up containers due to test failures..."
        cleanup_after_tests
        exit 1
    fi
}

# Run main function
main "$@" 