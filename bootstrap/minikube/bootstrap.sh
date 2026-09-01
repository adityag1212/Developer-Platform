#!/usr/bin/env bash

set -euo pipefail

CLUSTER_NAME="developer-platform"
ARGOCD_NAMESPACE="argocd"
ARGOCD_MANIFEST_URL="https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"

echo "========================================"
echo " Developer Platform - Minikube Bootstrap"
echo "========================================"

command -v minikube >/dev/null 2>&1 || {
  echo "ERROR: minikube is not installed."
  exit 1
}

command -v kubectl >/dev/null 2>&1 || {
  echo "ERROR: kubectl is not installed."
  exit 1
}

command -v helm >/dev/null 2>&1 || {
  echo "ERROR: helm is not installed."
  exit 1
}

echo
echo "[1/6] Starting Minikube..."

if ! minikube status --profile "${CLUSTER_NAME}" >/dev/null 2>&1; then
  minikube start \
    --profile "${CLUSTER_NAME}" \
    --driver=docker
else
  echo "Minikube profile already exists."
fi

echo
echo "[2/6] Verifying Kubernetes..."

kubectl config use-context "${CLUSTER_NAME}"

kubectl wait \
  --for=condition=Ready \
  node \
  --all \
  --timeout=120s

echo
echo "[3/6] Creating Argo CD namespace..."

kubectl get namespace "${ARGOCD_NAMESPACE}" >/dev/null 2>&1 || \
  kubectl create namespace "${ARGOCD_NAMESPACE}"

echo
echo "[4/6] Installing Argo CD..."

kubectl apply \
  -n "${ARGOCD_NAMESPACE}" \
  --server-side \
  --force-conflicts \
  -f "${ARGOCD_MANIFEST_URL}"

echo
echo "[5/6] Waiting for Argo CD..."

kubectl wait \
  --for=condition=Available \
  deployment/argocd-server \
  -n "${ARGOCD_NAMESPACE}" \
  --timeout=300s

kubectl wait \
  --for=condition=Available \
  deployment/argocd-repo-server \
  -n "${ARGOCD_NAMESPACE}" \
  --timeout=300s

echo
echo "[6/6] Verifying Argo CD..."

kubectl get pods -n "${ARGOCD_NAMESPACE}"

echo
echo "========================================"
echo " Bootstrap completed successfully"
echo "========================================"

echo
echo "Cluster:"
kubectl config current-context

echo
echo "Argo CD:"
kubectl get pods -n "${ARGOCD_NAMESPACE}"

echo
echo "Next:"
echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"