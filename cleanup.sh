#!/bin/bash

# Cleanup Script for ColdFusion Code Test
# This script stops and removes all containers and cleans up resources

set -e

echo "🧹 Cleaning up ColdFusion Code Test Environment"
echo "================================================"

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

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to stop and remove containers
cleanup_containers() {
    print_status "Stopping and removing containers..."
    
    if docker-compose down --remove-orphans --volumes; then
        print_success "Containers stopped and removed"
    else
        print_warning "No containers were running or already cleaned up"
    fi
}

# Function to clean up Docker resources
cleanup_docker() {
    print_status "Cleaning up Docker resources..."
    
    # Remove unused containers
    local removed_containers=$(docker container prune -f 2>/dev/null | grep -o '[0-9]*' | head -1)
    if [ -n "$removed_containers" ] && [ "$removed_containers" -gt 0 ]; then
        print_success "Removed $removed_containers unused containers"
    fi
    
    # Remove unused networks
    local removed_networks=$(docker network prune -f 2>/dev/null | grep -o '[0-9]*' | head -1)
    if [ -n "$removed_networks" ] && [ "$removed_networks" -gt 0 ]; then
        print_success "Removed $removed_networks unused networks"
    fi
    
    # Remove unused images
    local removed_images=$(docker image prune -f 2>/dev/null | grep -o '[0-9]*' | head -1)
    if [ -n "$removed_images" ] && [ "$removed_images" -gt 0 ]; then
        print_success "Removed $removed_images unused images"
    fi
    
    # Remove unused volumes
    local removed_volumes=$(docker volume prune -f 2>/dev/null | grep -o '[0-9]*' | head -1)
    if [ -n "$removed_volumes" ] && [ "$removed_volumes" -gt 0 ]; then
        print_success "Removed $removed_volumes unused volumes"
    fi
}

# Function to clean up test reports
cleanup_reports() {
    print_status "Cleaning up test reports..."
    
    local report_count=0
    for report in test-report-*.html; do
        if [ -f "$report" ]; then
            rm "$report"
            report_count=$((report_count + 1))
        fi
    done
    
    if [ $report_count -gt 0 ]; then
        print_success "Removed $report_count test report files"
    else
        print_status "No test report files found"
    fi
}

# Function to show cleanup summary
show_summary() {
    print_status "Cleanup Summary:"
    print_status "- Containers: Stopped and removed"
    print_status "- Networks: Cleaned up unused networks"
    print_status "- Images: Cleaned up unused images"
    print_status "- Volumes: Cleaned up unused volumes"
    print_status "- Reports: Cleaned up test reports"
    
    print_success "🎉 Cleanup completed successfully!"
    print_status "You can now run './build-and-test.sh' to start fresh"
}

# Main execution
main() {
    echo ""
    
    # Check if Docker is available
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not available"
        exit 1
    fi
    
    # Perform cleanup
    cleanup_containers
    cleanup_docker
    cleanup_reports
    
    echo ""
    show_summary
}

main "$@" 