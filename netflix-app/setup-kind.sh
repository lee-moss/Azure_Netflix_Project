#!/bin/bash

# Create Kind cluster
kind create cluster --name netflix-cluster --config kind-config.yaml

# Create namespace
kubectl create namespace netflix

# Create secrets
kubectl create secret generic tmdb-secrets \
  --namespace netflix \
  --from-literal=TMDB_API_KEY=${TMDB_API_KEY} \
  --from-literal=TMDB_ACCESS_TOKEN=${TMDB_ACCESS_TOKEN}

# Build and load Docker images
docker build -t netflix-frontend:latest ./frontend
docker build -t netflix-backend:latest ./backend

kind load docker-image netflix-frontend:latest --name netflix-cluster
kind load docker-image netflix-backend:latest --name netflix-cluster

# Apply Kubernetes manifests
kubectl apply -f k8s/frontend/deployment.yaml
kubectl apply -f k8s/frontend/service.yaml
kubectl apply -f k8s/backend/deployment.yaml
kubectl apply -f k8s/backend/service.yaml
kubectl apply -f k8s/ingress.yaml

# Wait for pods to be ready
kubectl wait --namespace netflix \
  --for=condition=ready pod \
  --selector=app=netflix-frontend \
  --timeout=90s

kubectl wait --namespace netflix \
  --for=condition=ready pod \
  --selector=app=netflix-backend \
  --timeout=90s

echo "Netflix application is being deployed to Kind cluster..."
echo "Frontend will be available at: http://localhost:3000"
echo "Backend will be available at: http://localhost:8080" 