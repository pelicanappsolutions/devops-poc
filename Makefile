.PHONY: run smoke docker-build docker-run docker-logs docker-stop k8s-apply k8s-status k8s-logs k8s-port-forward k8s-delete linux-lab troubleshoot

run:
	node server.js

smoke:
	node scripts/smoke-test.js

docker-build:
	docker build -t cgi-devops-practice-app:local .

docker-run:
	docker run --rm -d --name cgi-devops-practice-app -p 3000:3000 cgi-devops-practice-app:local

docker-logs:
	docker logs -f cgi-devops-practice-app

docker-stop:
	docker stop cgi-devops-practice-app || true

k8s-apply:
	kubectl apply -f k8s/

k8s-status:
	kubectl get all -n cgi-devops-practice
	kubectl describe deployment cgi-devops-practice-app -n cgi-devops-practice

k8s-logs:
	kubectl logs -n cgi-devops-practice -l app=cgi-devops-practice-app --tail=100 -f

k8s-port-forward:
	kubectl port-forward -n cgi-devops-practice service/cgi-devops-practice-service 3000:80

k8s-delete:
	kubectl delete -f k8s/ || true

linux-lab:
	bash scripts/linux_command_lab.sh

troubleshoot:
	bash scripts/troubleshoot_app.sh
