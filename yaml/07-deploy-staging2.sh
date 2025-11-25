#!/bin/bash

echo "=== Deploying Staging2 Environment ==="

# Create namespace
kubectl create namespace staging2

# Apply secrets
kubectl apply -f db-secret-staging2.yaml
kubectl apply -f django-secret-staging2.yaml

# Apply deployment and service
kubectl apply -f staging2-deployment.yaml
kubectl apply -f staging2-service.yaml

# Wait for deployment
sleep 30

# Check status
echo "=== Staging2 Status ==="
kubectl get all -n staging2

echo "=== Service IP ==="
kubectl get svc django-staging2-service -n staging2

echo "=== Deployment Complete ==="