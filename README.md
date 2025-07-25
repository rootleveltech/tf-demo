# Burrito Tag Support Test Repository

This repository demonstrates the enhanced tag support functionality added to the Burrito Kubernetes operator for Terraform automation.

## What's New

Burrito now supports referencing Git **tags** in addition to branches in `TerraformRepository` configurations, enabling:

- **Version-specific deployments**: Pin infrastructure to specific versions using Git tags
- **Rollback capabilities**: Easy rollback to previous infrastructure versions
- **Release management**: Coordinate infrastructure releases with application releases

## Repository Structure

```
test-repo/
├── main.tf                           # Main Terraform configuration
├── templates/config.tpl              # Template file for generated config
├── outputs/                          # Directory for generated files
├── burrito-config/                   # Burrito Kubernetes manifests
│   └── terraform-repository.yaml     # Example configurations
└── README.md                         # This file
```

## Testing the Tag Support

### 1. Branch Reference (Traditional)
```yaml
apiVersion: config.terraform.padok.cloud/v1alpha1
kind: TerraformRepository
metadata:
  name: my-terraform-repo
spec:
  repository:
    url: "https://github.com/rootleveltech/tf-demo.git"
    reference: "main"  # Branch reference
```

### 2. Tag Reference (New Feature)
```yaml
apiVersion: config.terraform.padok.cloud/v1alpha1
kind: TerraformRepository
metadata:
  name: my-terraform-repo
spec:
  repository:
    url: "https://github.com/rootleveltech/tf-demo.git"
    reference: "v1.0.0"  # Tag reference - NEW!
```

## Implementation Details

The tag support is implemented through:

### Enhanced Clone Strategy
- **Primary attempt**: Clone as branch reference (`refs/heads/*)
- **Fallback attempt**: Clone as tag reference (`refs/tags/*`) if branch fails
- **Comprehensive logging**: Clear indication of which reference type is being used

### New Helper Functions
- `CloneWithFallback()`: Smart cloning with branch/tag fallback
- `ReferenceName()`: Converts references to branch format
- `ReferenceNameForTag()`: Converts references to tag format

### Provider Support
All Git providers now support tag references:
- ✅ **GitHub**: Full tag support with authentication
- ✅ **GitLab**: Complete tag integration
- ✅ **Standard Git**: Tag support for any Git repository

## Git Tags in This Repository

This repository includes example tags for testing:

- `v1.0.0` - Initial release with basic Terraform config
- `v1.1.0` - Enhanced configuration with additional variables
- `v2.0.0` - Production-ready configuration

## Usage Examples

### Development Environment (using branch)
```bash
kubectl apply -f - <<EOF
apiVersion: config.terraform.padok.cloud/v1alpha1
kind: TerraformRepository
metadata:
  name: dev-infrastructure
spec:
  repository:
    url: "https://github.com/rootleveltech/tf-demo.git"
    reference: "develop"  # Latest development changes
EOF
```

### Production Environment (using tag)
```bash
kubectl apply -f - <<EOF
apiVersion: config.terraform.padok.cloud/v1alpha1
kind: TerraformRepository
metadata:
  name: prod-infrastructure
spec:
  repository:
    url: "https://github.com/rootleveltech/tf-demo.git"
    reference: "v1.0.0"  # Stable, tested version
EOF
```

## Testing Instructions

1. **Deploy Burrito** with the enhanced tag support
2. **Apply the test configurations** from `burrito-config/`
3. **Verify cloning behavior** in Burrito logs
4. **Test tag switching** by updating references between tags
5. **Monitor Terraform runs** for successful deployments

## Expected Behavior

When Burrito processes a `TerraformRepository` with a tag reference:

1. **First attempt**: Try to clone as branch `refs/heads/v1.0.0`
2. **Fallback**: Clone as tag `refs/tags/v1.0.0` 
3. **Success**: Continue with Terraform operations
4. **Logging**: Clear indication of reference type used

## Benefits

- **Deployment Safety**: Use tested, tagged versions in production
- **Change Management**: Track infrastructure versions alongside application versions
- **Rollback Support**: Quick rollback to previous infrastructure states
- **Release Coordination**: Align infrastructure and application releases

---

This enhancement maintains full backward compatibility while adding powerful new versioning capabilities to Burrito's GitOps workflow.
# Webhook test - Wed Jul 16 16:45:37 +04 2025
