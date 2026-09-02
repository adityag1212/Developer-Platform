#!/usr/bin/env bash

set -euo pipefail

CLUSTER_NAME="developer-platform"
ARGOCD_NAMESPACE="argocd"

REPO_URL="https://github.com/Adityag1212/Developer-Platform.git"
APPLICATION_SET_PATH="gitops/environments/application-set.yaml"

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
echo "[1/7] Starting Minikube..."

if minikube status --profile "${CLUSTER_NAME}" >/dev/null 2>&1; then
  echo "Minikube profile already exists."
else
  minikube start \
    --profile "${CLUSTER_NAME}" \
    --driver=docker
fi

echo
echo "[2/7] Selecting Kubernetes context..."

kubectl config use-context "${CLUSTER_NAME}"

echo
echo "[3/7] Verifying Kubernetes node..."

kubectl wait \
  --for=condition=Ready \
  node \
  --all \
  --timeout=120s

echo
echo "[4/7] Creating Argo CD namespace..."

kubectl get namespace "${ARGOCD_NAMESPACE}" >/dev/null 2>&1 || \
  kubectl create namespace "${ARGOCD_NAMESPACE}"

echo
echo "[5/7] Installing Argo CD..."

kubectl apply \
  -n "${ARGOCD_NAMESPACE}" \
  --server-side \
  --force-conflicts \
  -f "${ARGOCD_MANIFEST_URL}"

echo
echo "[6/7] Waiting for Argo CD..."

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
echo "[7/7] Registering GitOps ApplicationSet..."

kubectl apply \
  -f "${REPO_URL}/${APPLICATION_SET_PATH}?ref=develop"

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
echo "Applications:"
kubectl get applications -n "${ARGOCD_NAMESPACE}" || true

echo
echo "ApplicationSets:"
kubectl get applicationsets -n "${ARGOCD_NAMESPACE}" || true

echo
echo "Argo CD UI:"
echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"