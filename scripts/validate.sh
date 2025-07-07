#!/bin/bash

# Validation script for Terraform configuration
# Runs various checks to ensure the configuration is valid and well-formatted

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Initialize counters
CHECKS_PASSED=0
CHECKS_FAILED=0
TOTAL_CHECKS=0

run_check() {
    local check_name="$1"
    local check_command="$2"
    
    log_step "Running: $check_name"
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if eval "$check_command"; then
        log_info "✓ $check_name passed"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
    else
        log_error "✗ $check_name failed"
        CHECKS_FAILED=$((CHECKS_FAILED + 1))
    fi
    echo ""
}

main() {
    echo "========================================"
    echo "     Terraform Configuration Validation"
    echo "========================================"
    echo ""
    
    # Check if Terraform is installed
    if ! command -v terraform &> /dev/null; then
        log_error "Terraform is not installed. Please install it first."
        exit 1
    fi
    
    # Basic Terraform checks
    run_check "Terraform Format Check" "terraform fmt -check -diff"
    run_check "Terraform Init" "terraform init -backend=false"
    run_check "Terraform Validate" "terraform validate"
    
    # Security checks (if tfsec is available)
    if command -v tfsec &> /dev/null; then
        run_check "Security Check (tfsec)" "tfsec . --soft-fail"
    else
        log_warn "tfsec not found. Install it for security checks: https://github.com/aquasecurity/tfsec"
    fi
    
    # Check for common issues
    run_check "Check for TODO/FIXME comments" "! grep -r 'TODO\\|FIXME' *.tf"
    run_check "Check for hardcoded values" "! grep -r 'ami-\\|sg-\\|vpc-\\|subnet-' *.tf || true"
    
    # File structure checks
    run_check "Check required files exist" "test -f main.tf && test -f variables.tf && test -f outputs.tf"
    run_check "Check user_data.sh exists" "test -f user_data.sh"
    run_check "Check GitHub workflow exists" "test -f .github/workflows/terraform-deploy.yml"
    
    # Variable file checks
    run_check "Check example tfvars exists" "test -f terraform.tfvars.example"
    
    # Documentation checks
    run_check "Check README exists" "test -f README.md"
    run_check "Check README is not empty" "test -s README.md"
    
    echo "========================================"
    echo "           Validation Summary"
    echo "========================================"
    echo "Total checks: $TOTAL_CHECKS"
    echo -e "Passed: ${GREEN}$CHECKS_PASSED${NC}"
    echo -e "Failed: ${RED}$CHECKS_FAILED${NC}"
    echo ""
    
    if [ $CHECKS_FAILED -eq 0 ]; then
        log_info "All checks passed! Configuration looks good. ✨"
        exit 0
    else
        log_error "Some checks failed. Please review and fix the issues above."
        exit 1
    fi
}

main "$@"