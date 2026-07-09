#!/usr/bin/env bash
set -euo pipefail

echo "Build local image first:"
echo "  docker build -t devops-poc-app:local ."
echo

echo "Apply Kubernetes manifests:"
kubectl apply -f k8s/

echo
echo "Check resources:"
kubectl get all -n devops-poc

cat <<'NEXT'

Practice these commands:
kubectl get namespaces
kubectl get pods -n devops-poc
kubectl describe pod <pod-name> -n devops-poc
kubectl logs <pod-name> -n devops-poc
kubectl get svc -n devops-poc
kubectl port-forward -n devops-poc service/devops-poc-service 3000:80
curl http://localhost:3000/healthz
kubectl rollout status deployment/devops-poc-app -n devops-poc
kubectl rollout history deployment/devops-poc-app -n devops-poc
kubectl scale deployment devops-poc-app --replicas=3 -n devops-poc
kubectl delete -f k8s/
NEXT
