# CGI DevOps Interview Practice Project

This project upgrades your original small DevOps POC into a full interview-practice lab covering:

- Linux and CLI troubleshooting
- Docker
- Kubernetes
- Azure / AKS concepts
- CI/CD
- Logs, health checks, and incident response
- STAR stories and interview answers

## Quick start

Run locally:

```bash
node server.js
```

In another terminal:

```bash
curl http://localhost:3000/
curl http://localhost:3000/healthz
curl http://localhost:3000/readyz
curl http://localhost:3000/error
```

## Linux command lab

```bash
bash scripts/linux_command_lab.sh
```

This creates a safe lab in `/tmp/cgi-devops-linux-lab` and practices:

- `pwd`, `ls`, `cd`
- `cat`, `head`, `tail`
- `grep`, `awk`, `sed`
- `find`
- `chmod`, `stat`
- `df`, `du`, `free`
- `ps`, `kill`
- `curl`, `ping`, `ss`
- `tar`

## Troubleshooting lab

Start the app:

```bash
node server.js
```

Then run:

```bash
bash scripts/troubleshoot_app.sh
```

Practice explaining:

> I checked health endpoints, logs, CPU, memory, disk, ports, container state, Kubernetes state, and then applied the safest fix.

## Docker lab

```bash
bash scripts/docker_lab.sh
```

Useful commands:

```bash
docker build -t cgi-devops-practice-app:local .
docker run -d --name cgi-devops-practice-app -p 3000:3000 cgi-devops-practice-app:local
docker ps
docker logs cgi-devops-practice-app
docker exec -it cgi-devops-practice-app sh
docker inspect cgi-devops-practice-app
docker stop cgi-devops-practice-app
```

## Kubernetes lab

For local Kubernetes, use Docker Desktop Kubernetes, minikube, kind, or another local cluster.

Build image:

```bash
docker build -t cgi-devops-practice-app:local .
```

Apply manifests:

```bash
kubectl apply -f k8s/
kubectl get all -n cgi-devops-practice
kubectl logs -n cgi-devops-practice -l app=cgi-devops-practice-app
kubectl port-forward -n cgi-devops-practice service/cgi-devops-practice-service 3000:80
curl http://localhost:3000/healthz
```

Clean up:

```bash
kubectl delete -f k8s/
```

## Azure / AKS study

Read:

```bash
bash scripts/azure_aks_commands.sh
```

## Interview guide

Read and memorize:

```text
docs/CGI_DEVOPS_INTERVIEW_GUIDE.md
```

## The master troubleshooting answer

When troubleshooting a DevOps issue, I first understand the impact and what changed recently. Then I check service status, logs, system resources, disk space, network connectivity, open ports, environment variables, permissions, and deployment status. I use commands like `systemctl status`, `journalctl`, `tail -f`, `top`, `free -h`, `df -h`, `ss -tulpn`, `curl`, and `ping`. Once I find the likely root cause, I apply the safest fix, such as correcting configuration, restarting a service, freeing disk space, fixing permissions, or rolling back a deployment. Afterward, I document the root cause and suggest improvements like better monitoring, alerts, automation, or deployment checks.
