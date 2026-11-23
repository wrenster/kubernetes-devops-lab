#!/usr/bin/env bash
set -euo pipefail

echo "Installing Metrics Server..."

kubectl apply -f \
  https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.9.1/components.yaml

echo "Configuring Metrics Server for local kind cluster..."

kubectl patch deployment metrics-server \
  -n kube-system \
  --type=json \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'

echo "Waiting for Metrics Server..."

kubectl rollout status deployment/metrics-server \
  -n kube-system \
  --timeout=120s

echo "Metrics Server installation complete."
