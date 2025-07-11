#!/bin/bash

# Quick Test Script for ColdFusion Components
# This script runs tests on already running containers

set -e

echo "🧪 Quick Test for ColdFusion Components"
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if containers are running
check_containers() {
    print_status "Checking if containers are running..."
    
    if ! docker-compose ps | grep -q "Up"; then
        print_error "Containers are not running. Please run 'docker-compose up -d' first."
        exit 1
    fi
    
    print_success "Containers are running"
}

# Run individual tests
run_test() {
    local test_name="$1"
    local test_url="$2"
    local success_pattern="$3"
    
    print_status "Running $test_name..."
    
    local result=$(curl -s "$test_url" 2>/dev/null || echo "Connection failed")
    
    if echo "$result" | grep -q "$success_pattern"; then
        print_success "$test_name passed"
        return 0
    else
        print_error "$test_name failed"
        echo "$result" | head -20
        return 1
    fi
}

# Main test execution
main() {
    check_containers
    
    print_status "Starting quick test suite..."
    
    local all_passed=true
    
    # Test 1: Component compilation
    if ! run_test "Component Compilation" "http://localhost:8080/tests/simple-test.cfm" "PASSED"; then
        all_passed=false
    fi
    
    # Test 2: Unit tests
    if ! run_test "Unit Tests" "http://localhost:8080/tests/unit-tests.cfm" "PASS:"; then
        all_passed=false
    fi
    
    # Test 3: Database tests
    if ! run_test "Database Tests" "http://localhost:8080/tests/database-test.cfm" "PASSED"; then
        all_passed=false
    fi
    
    # Test 4: Comprehensive tests
    if ! run_test "Comprehensive Tests" "http://localhost:8080/tests/test-runner.cfm" "PASSED"; then
        all_passed=false
    fi
    
    echo ""
    if [ "$all_passed" = true ]; then
        print_success "🎉 All tests passed!"
        print_status "Test URLs:"
        print_status "  - http://localhost:8080/tests/test-runner.cfm"
        print_status "  - http://localhost:8080/tests/unit-tests.cfm"
        print_status "  - http://localhost:8080/tests/simple-test.cfm"
        print_status "  - http://localhost:8080/tests/database-test.cfm"
    else
        print_error "❌ Some tests failed!"
        exit 1
    fi
}

main "$@" 