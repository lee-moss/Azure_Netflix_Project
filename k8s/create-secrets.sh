#!/bin/bash

# Create namespace if it doesn't exist
kubectl create namespace netflix --dry-run=client -o yaml | kubectl apply -f -

# Create TMDB secrets
kubectl create secret generic tmdb-secrets \
  --namespace netflix \
  --from-literal=api-key='your-tmdb-api-key' \
  --from-literal=access-token='your-tmdb-access-token' \
  --dry-run=client -o yaml | kubectl apply -f -

# Create MongoDB secrets
kubectl create secret generic mongodb-secrets \
  --namespace netflix \
  --from-literal=username='mongodb-user' \
  --from-literal=password='mongodb-password' \
  --from-literal=uri='mongodb://mongodb-user:mongodb-password@mongodb:27017' \
  --dry-run=client -o yaml | kubectl apply -f -

# Create Redis secrets
kubectl create secret generic redis-secrets \
  --namespace netflix \
  --from-literal=uri='redis://redis:6379' \
  --dry-run=client -o yaml | kubectl apply -f - 