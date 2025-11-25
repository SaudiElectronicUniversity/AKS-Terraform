#!/bin/bash
kubectl delete -f staging2-service.yaml
kubectl delete -f staging2-deployment.yaml
kubectl delete -f django-secret-staging2.yaml
kubectl delete -f db-secret-staging2.yaml
kubectl delete namespace staging2
echo "Staging2 environment cleaned up!"