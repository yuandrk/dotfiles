# kind Configuration Examples

This directory contains example kind cluster configurations for learning and testing Kubernetes.

## Available Configurations

### simple-cluster.yaml
A basic single-node cluster for quick testing.

**Usage:**
```bash
kind create cluster --config ~/.config/kind/simple-cluster.yaml
```

### multi-node-cluster.yaml
A multi-node cluster with 1 control plane and 2 worker nodes.
Good for testing workload distribution and node selectors.

**Usage:**
```bash
kind create cluster --config ~/.config/kind/multi-node-cluster.yaml
```

### advanced-cluster.yaml
An advanced cluster with:
- Port mappings (80, 443, 30000-30001) for testing services
- Ingress-ready configuration
- 1 control plane + 2 workers

Perfect for testing ingress controllers and NodePort services.

**Usage:**
```bash
kind create cluster --config ~/.config/kind/advanced-cluster.yaml
```

## Useful kind Commands

### Creating Clusters
```bash
# Simple cluster with default name
kind create cluster

# Cluster with custom name
kind create cluster --name my-cluster

# Using a config file
kind create cluster --config ~/.config/kind/simple-cluster.yaml
```

### Managing Clusters
```bash
# List all clusters
kind get clusters

# Get kubeconfig
kind get kubeconfig --name my-cluster

# Delete a cluster
kind delete cluster --name my-cluster

# Delete all clusters
kind delete clusters --all
```

### Working with Images
```bash
# Load a local Docker image into kind
kind load docker-image my-image:tag --name my-cluster

# Build and load
docker build -t my-app:v1 .
kind load docker-image my-app:v1
```

### Useful Bash Functions (from .bashrc)
```bash
# Create cluster with custom name
kind-new my-cluster

# Create multi-node cluster
kind-multi

# Create cluster with port mappings
kind-with-ports

# Delete all kind clusters
kind-clean

# Switch to kind cluster context
kind-use my-cluster

# Load image into cluster
kind-img nginx:latest my-cluster

# Show nodes in cluster
kind-nodes my-cluster
```

## Quick Start Example

1. Create a cluster:
```bash
kind create cluster --name learning
```

2. Verify it's working:
```bash
kubectl cluster-info --context kind-learning
kubectl get nodes
```

3. Deploy something:
```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80
kubectl get pods
```

4. Clean up when done:
```bash
kind delete cluster --name learning
```

## Tips

- kind clusters use kubeconfig contexts named `kind-<cluster-name>`
- Use `kubectx` to switch between kind clusters and real clusters
- kind is perfect for CI/CD pipelines and local development
- Each kind cluster runs in Docker containers (visible with `docker ps`)
