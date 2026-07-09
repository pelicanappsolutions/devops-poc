# CGI DevOps Interview Guide

## Your interview identity

You are a DevOps-minded engineer with hands-on experience from a real SaaS platform, Hoaflo, plus Linux/CLI practice, SaaS support, AWS exposure, Security+, documentation habits, and a development foundation.

Your core message:

> My background sits between development and operations. I understand code, but I also understand support, troubleshooting, logs, infrastructure, access control, documentation, and keeping systems stable.

## Your 60-second introduction

I’m a Security+ certified technology professional with hands-on experience across SaaS application support, AWS-based infrastructure exposure, Linux and CLI troubleshooting, scripting, documentation, access-control awareness, and operational problem-solving.

A lot of my DevOps-related experience comes from Hoaflo, a SaaS platform I helped build with my partner. Through that, I worked around AWS infrastructure, CI/CD concepts, CloudWatch-style logging, user access issues, environment configuration, application troubleshooting, and documentation. I also have a software development foundation, so I understand both the development side and the operations side.

What makes DevOps interesting to me is that it combines automation, troubleshooting, reliability, security, and communication. CGI interests me because I want to grow in a structured enterprise DevOps environment where reliability, documentation, security, and teamwork matter.

## Hoaflo master story

Hoaflo is a SaaS platform for HOA operations. It includes areas like billing, documents, dashboard, directory, collections, and user access. My experience with it exposed me to application support, AWS infrastructure concepts, authentication and authorization, deployment troubleshooting, environment configuration, and operational documentation.

The biggest DevOps lesson I learned was:

> Merged does not mean deployed, and deployed does not mean routed.

You have to verify the pipeline ran, the artifact was built, the environment variables were included, the correct version reached the right environment, routing points to it, and logs/health checks confirm it is working.

## Main troubleshooting formula

Use this for almost every technical scenario:

Impact -> recent changes -> service status -> logs -> resources -> disk -> network -> ports -> permissions -> environment variables -> deployment version -> safest fix -> documentation/prevention.

## Linux / CLI must-know commands

Navigation:
- `pwd`: show current directory
- `ls -la`: list files, including hidden files and permissions
- `cd`: change directory

Files:
- `cat`: print a file
- `less`: view large file page by page
- `head`: first lines
- `tail -f`: follow live logs
- `cp`: copy
- `mv`: move/rename
- `rm`: remove
- `mkdir`: create directory
- `touch`: create empty file/update timestamp

Search/text:
- `grep`: search text
- `awk`: extract/process fields
- `sed`: replace/edit text
- `find`: find files by name, type, size, time
- `sort`, `uniq`, `wc`: process text output

Permissions:
- `chmod`: change permissions
- `chown`: change owner/group
- `stat`: detailed file metadata

Processes/resources:
- `ps aux`: list processes
- `top`: live process/resource view
- `kill`: terminate process
- `free -h`: memory
- `df -h`: filesystem disk usage
- `du -sh *`: directory/file sizes
- `uptime`: load average

Services/logs:
- `systemctl status service`
- `systemctl restart service`
- `journalctl -u service -f`
- `journalctl -xe`

Network:
- `curl`: test HTTP
- `ping`: reachability
- `ss -tulpn`: listening ports
- `nc -zv host port`: test port
- `dig` / `nslookup`: DNS
- `ssh`: remote login
- `scp`: copy files

Archives:
- `tar -czf file.tar.gz folder`
- `tar -xzf file.tar.gz`

## Linux Q&A

### A server is slow. What do you check?

I first understand impact and recent changes. Then I check CPU, memory, disk, heavy processes, logs, and network.

Commands:
```bash
top
free -h
df -h
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head
journalctl -xe
```

I gather evidence before restarting anything.

### A website is down. What do you check?

```bash
ping server
systemctl status nginx
ss -tulpn
curl http://localhost
journalctl -u nginx -f
tail -f /var/log/nginx/error.log
```

I also check DNS, firewall/security groups, recent deployments, environment variables, and routing/CDN if applicable.

### Disk is full. What do you do?

```bash
df -h
du -sh /*
du -sh /var/log/*
lsof | grep deleted
```

I avoid deleting blindly. I look for logs, old artifacts, temp files, backups, and add log rotation or cleanup automation.

### A service will not start. What do you check?

```bash
systemctl status service-name
journalctl -u service-name -xe
ss -tulpn
df -h
```

I look for bad config, missing env vars, permission issues, port conflicts, dependency failures, and disk problems.

### Difference between chmod and chown?

`chmod` changes permissions. `chown` changes ownership.

### Difference between kill and kill -9?

`kill` sends a graceful termination signal. `kill -9` forcefully kills the process. Use `kill -9` only when needed.

## Docker Q&A

### What is Docker?

Docker packages an application and its dependencies into an image. A container is a running instance of that image. It helps applications run consistently across environments.

Must-know commands:
```bash
docker build -t app:local .
docker run -d --name app -p 3000:3000 app:local
docker ps
docker images
docker logs app
docker exec -it app sh
docker inspect app
docker stop app
docker rm app
```

### Docker troubleshooting flow

1. Is the container running? `docker ps`
2. Did it exit? `docker ps -a`
3. What do logs say? `docker logs container`
4. Is the port mapped? `docker port container`
5. Is the app healthy? `curl localhost:port/healthz`
6. Does the image contain the expected files/env vars? `docker exec`

## Kubernetes Q&A

### What is Kubernetes?

Kubernetes orchestrates containers. It handles scheduling, scaling, health checks, service discovery, rolling updates, and recovery.

Core objects:
- Pod: smallest deployable unit
- Deployment: manages replicas and rolling updates
- Service: stable network endpoint for pods
- ConfigMap: non-secret config
- Secret: sensitive config
- Namespace: logical isolation
- Ingress: external HTTP routing

Must-know commands:
```bash
kubectl get nodes
kubectl get namespaces
kubectl get pods -A
kubectl get pods -n namespace
kubectl describe pod pod-name -n namespace
kubectl logs pod-name -n namespace
kubectl logs -f pod-name -n namespace
kubectl get deployments -n namespace
kubectl rollout status deployment/name -n namespace
kubectl rollout history deployment/name -n namespace
kubectl rollout undo deployment/name -n namespace
kubectl get svc -n namespace
kubectl port-forward service/name 3000:80 -n namespace
kubectl apply -f file.yaml
kubectl delete -f file.yaml
```

### Pod is CrashLoopBackOff. What do you do?

I check logs and events:

```bash
kubectl logs pod-name -n namespace --previous
kubectl describe pod pod-name -n namespace
```

I look for app startup errors, missing env vars, bad config, failed probes, image issues, permissions, or dependencies.

### Pod is running but service is not reachable. What do you check?

```bash
kubectl get svc -n namespace
kubectl get endpoints -n namespace
kubectl describe svc service-name -n namespace
kubectl get pods --show-labels -n namespace
```

I check whether the Service selector matches the pod labels, whether targetPort is correct, and whether the app is listening on the expected port.

### ImagePullBackOff. What does it mean?

Kubernetes cannot pull the image. Causes include wrong image name/tag, registry auth issue, missing image pull secret, or network issue.

## Azure / AKS Q&A

### What Azure services matter for this role?

- AKS: managed Kubernetes
- ACR: Azure Container Registry
- Azure DevOps: pipelines/repos/boards
- Azure Monitor / Log Analytics: logs and metrics
- Key Vault: secrets/certificates
- Azure RBAC / Entra ID: identity and access
- Storage Accounts: object/file storage
- VNets / NSGs / Load Balancers: networking

### AKS deployment flow

1. Build image
2. Push image to ACR
3. AKS pulls image from ACR
4. Apply Kubernetes manifests
5. Verify pods, services, logs, health endpoints, and rollout status

Commands:
```bash
az login
az account show
az group create --name rg-name --location eastus
az acr create --resource-group rg-name --name acrname --sku Basic
az acr login --name acrname
docker build -t acrname.azurecr.io/app:v1 .
docker push acrname.azurecr.io/app:v1
az aks create --resource-group rg-name --name aks-name --attach-acr acrname --node-count 1 --enable-managed-identity --generate-ssh-keys
az aks get-credentials --resource-group rg-name --name aks-name
kubectl apply -f k8s/
kubectl get pods -n namespace
```

## CI/CD Q&A

### What is CI/CD?

CI/CD automates build, test, scan, package, deploy, and validation.

Typical flow:
Code push -> build -> test -> scan -> containerize -> push artifact -> deploy -> health check -> monitor.

### Pipeline failed. What do you do?

I identify which stage failed, read logs, check dependencies, credentials/secrets, permissions, image tags, environment variables, target environment, and health checks.

## Security Q&A

### How do you handle secrets?

Never hardcode secrets or commit them to Git. Use Key Vault, CI/CD secret variables, Kubernetes Secrets, or approved secret stores. Use least privilege and rotate exposed secrets.

### What does least privilege mean?

Users and services get only the permissions required to do their job, nothing more.

## STAR answers

### Production issue

Situation: On Hoaflo, a feature appeared unavailable but browser errors were not obvious.
Task: Identify whether it was frontend, backend, deployment, or routing.
Action: Verified backend independently, inspected deployed artifact, checked environment variables, deployment state, and routing.
Result: Found a missing build-time environment variable and deployment/routing gaps. Improved checklist.

### CI/CD or deployment learning

Situation: Code was merged but expected behavior was not live.
Task: Find why the deployed environment did not match the repo.
Action: Checked pipeline status, artifact, environment variables, CDN/routing, and health endpoint.
Result: Learned to verify live deployment state. "Merged does not mean deployed."

### Authentication / authorization

Situation: Hoaflo needed users to access only allowed areas.
Task: Support proper role-based access thinking.
Action: Treated backend as the enforcement point, not just UI visibility.
Result: Stronger security mindset. "The server is the real gate; the UI is just UX."

### Working under pressure

Situation: User-facing SaaS issue needed quick resolution.
Task: Restore service safely.
Action: Stayed calm, checked recent changes, logs, health endpoints, routing, config, and deployment state.
Result: Resolved issue and improved runbook/checklist.

## LeetCode patterns

Use Python. Explain first, then code.

### Two Sum — hash table
```python
def two_sum(nums, target):
    seen = {}
    for i, n in enumerate(nums):
        need = target - n
        if need in seen:
            return [seen[need], i]
        seen[n] = i
    return []
```

### Valid Parentheses — stack
```python
def is_valid_parentheses(s):
    stack = []
    pairs = {")": "(", "]": "[", "}": "{"}
    for c in s:
        if c in "([{":
            stack.append(c)
        elif c in pairs:
            if not stack or stack[-1] != pairs[c]:
                return False
            stack.pop()
    return len(stack) == 0
```

### Valid Palindrome — two pointers
```python
def is_palindrome(s):
    l, r = 0, len(s) - 1
    while l < r:
        while l < r and not s[l].isalnum():
            l += 1
        while l < r and not s[r].isalnum():
            r -= 1
        if s[l].lower() != s[r].lower():
            return False
        l += 1
        r -= 1
    return True
```

### Binary Search
```python
def binary_search(nums, target):
    l, r = 0, len(nums) - 1
    while l <= r:
        m = (l + r) // 2
        if nums[m] == target:
            return m
        if nums[m] < target:
            l = m + 1
        else:
            r = m - 1
    return -1
```

### Longest substring without repeats — sliding window
```python
def length_of_longest_substring(s):
    seen = set()
    left = 0
    longest = 0
    for right in range(len(s)):
        while s[right] in seen:
            seen.remove(s[left])
            left += 1
        seen.add(s[right])
        longest = max(longest, right - left + 1)
    return longest
```

## Final questions to ask CGI

- What tools does the team use for CI/CD, Azure, Docker, Kubernetes, monitoring, and incident response?
- Is this role more focused on Linux troubleshooting, pipeline support, AKS/Kubernetes, Azure operations, or infrastructure automation?
- What does success look like in the first 60 to 90 days?
