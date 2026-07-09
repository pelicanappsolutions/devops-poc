.PHONY: run smoke docker-build docker-run docker-logs docker-stop k8s-apply k8s-status k8s-logs k8s-port-forward k8s-delete linux-lab troubleshoot

run:
	node server.js

smoke:
	node scripts/smoke-test.js

docker-build:
	docker build -t devops-poc-app:local .

docker-run:
	docker run --rm -d --name devops-poc-app -p 3000:3000 devops-poc-app:local

docker-logs:
	docker logs -f devops-poc-app

docker-stop:
	docker stop devops-poc-app || true

k8s-apply:
	kubectl apply -f k8s/

k8s-status:
	kubectl get all -n devops-poc
	kubectl describe deployment devops-poc-app -n devops-poc

k8s-logs:
	kubectl logs -n devops-poc -l app=devops-poc-app --tail=100 -f

k8s-port-forward:
	kubectl port-forward -n devops-poc service/devops-poc-service 3000:80

k8s-delete:
	kubectl delete -f k8s/ || true

linux-lab:
	bash scripts/linux_command_lab.sh

troubleshoot:
	bash scripts/troubleshoot_app.sh
