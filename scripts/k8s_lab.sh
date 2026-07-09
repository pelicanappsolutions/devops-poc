#!/usr/bin/env bash
set -euo pipefail

echo "Build local image first:"
echo "  docker build -t cgi-devops-practice-app:local ."
echo

echo "Apply Kubernetes manifests:"
kubectl apply -f k8s/

echo
echo "Check resources:"
kubectl get all -n cgi-devops-practice

cat <<'NEXT'

Practice these commands:
kubectl get namespaces
kubectl get pods -n cgi-devops-practice
kubectl describe pod <pod-name> -n cgi-devops-practice
kubectl logs <pod-name> -n cgi-devops-practice
kubectl get svc -n cgi-devops-practice
kubectl port-forward -n cgi-devops-practice service/cgi-devops-practice-service 3000:80
curl http://localhost:3000/healthz
kubectl rollout status deployment/cgi-devops-practice-app -n cgi-devops-practice
kubectl rollout history deployment/cgi-devops-practice-app -n cgi-devops-practice
kubectl scale deployment cgi-devops-practice-app --replicas=3 -n cgi-devops-practice
kubectl delete -f k8s/
NEXT
