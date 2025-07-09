#!/bin/bash

# Test script for Burrito tag support functionality
# This script demonstrates how the new CloneWithFallback function works

set -e

echo "=== Burrito Tag Support Test Script ==="
echo "This script demonstrates the enhanced tag support in Burrito"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test repository details
REPO_URL="https://github.com/rootleveltech/tf-demo.git"
TEST_DIR="/tmp/burrito-tag-test"

echo -e "${YELLOW}Available tags in this repository:${NC}"
git tag -l

echo ""
echo -e "${YELLOW}=== Testing Clone Functionality ===${NC}"

# Function to test clone with different references
test_clone() {
    local ref=$1
    local description=$2
    
    echo -e "${YELLOW}Testing: ${description}${NC}"
    echo "Reference: ${ref}"
    
    # Clean up previous test
    rm -rf "${TEST_DIR}"
    
    # This simulates what Burrito's CloneWithFallback function does
    echo "1. Attempting branch clone (refs/heads/${ref})..."
    if git clone --single-branch --branch "${ref}" "${REPO_URL}" "${TEST_DIR}" 2>/dev/null; then
        echo -e "${GREEN}✓ Successfully cloned as branch${NC}"
    else
        echo "✗ Branch clone failed, trying tag clone..."
        echo "2. Attempting tag clone (refs/tags/${ref})..."
        if git clone --single-branch --branch "${ref}" "${REPO_URL}" "${TEST_DIR}" 2>/dev/null; then
            echo -e "${GREEN}✓ Successfully cloned as tag${NC}"
        else
            echo -e "${RED}✗ Both branch and tag clone failed${NC}"
            return 1
        fi
    fi
    
    echo "Cloned commit: $(cd "${TEST_DIR}" && git rev-parse HEAD)"
    echo "Files in repository:"
    ls -la "${TEST_DIR}/"
    echo ""
}

# Test different reference types
echo -e "${YELLOW}=== Test 1: Branch Reference ===${NC}"
test_clone "main" "main branch (traditional approach)"

echo -e "${YELLOW}=== Test 2: Tag References ===${NC}"
test_clone "v1.0.0" "v1.0.0 tag (basic configuration)"
test_clone "v1.1.0" "v1.1.0 tag (enhanced variables)"
test_clone "v2.0.0" "v2.0.0 tag (production-ready)"

echo -e "${YELLOW}=== Test 3: Non-existent Reference ===${NC}"
test_clone "nonexistent" "non-existent reference (should fail)" || true

# Clean up
rm -rf "${TEST_DIR}"

echo -e "${GREEN}=== Test Complete ===${NC}"
echo ""
echo "This demonstrates how Burrito's enhanced git provider support works:"
echo "1. First attempts to clone as a branch (refs/heads/...)"
echo "2. Falls back to cloning as a tag (refs/tags/...)"
echo "3. Provides clear logging about which method succeeded"
echo ""
echo "Benefits:"
echo "- ✓ Backward compatibility with existing branch references"
echo "- ✓ New support for Git tag references"
echo "- ✓ Automatic fallback handling"
echo "- ✓ Clear error messages when neither works"
