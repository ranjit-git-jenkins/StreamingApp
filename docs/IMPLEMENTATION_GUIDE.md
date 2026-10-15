# Orchestration and Scaling — Implementation Guide

## Scope and status
This is a **deployment-ready starter configuration, not a verified live deployment**. AWS, Jenkins, Kubernetes, Docker builds, image pushes, app endpoints and autoscaling have not been tested. Do not submit screenshots of simulated output as actual AWS evidence.

## Source and assumptions
Fork: https://github.com/ranjit-git-jenkins/StreamingApp
Known source paths: `frontend`, `backend/authService`. Assumed additional paths: `backend/streamingService`, `backend/adminService`, `backend/chatService`. **Verify spelling and Dockerfiles** against the fork before running the pipeline. Expected ports: auth 3001, streaming 3002, admin 3003, chat 3004, frontend container 80. Inspect `docker-compose.yml` and `.env.example` files for authoritative app configuration.

## Architecture
GitHub webhook -> Jenkins -> Docker build -> Amazon ECR -> Helm -> Amazon EKS -> HPA. CloudWatch for metrics and logs. MongoDB is external to this chart and must be provisioned securely. The architecture is conceptual, not deployed.

## Prerequisites
AWS CLI, Docker, Jenkins with Pipeline/Git/AWS Credentials plugins, ECR repositories, IAM permissions, eksctl, kubectl, Helm, EKS with suitable worker nodes, metrics-server, a working MongoDB URI and an ingress/load balancer solution. EKS/ECR/EC2/CloudWatch may incur charges.

## Suggested steps
1. Inspect and correct backend paths and `Dockerfile`s; ensure `npm run start` works for all services.
2. Check each backend's MongoDB variable names, auth/JWT secrets, streaming storage, WebSocket and CORS settings. `MONGO_URI` is only a placeholder assumption.
3. Inspect React `REACT_APP_*` build arguments. Provide real public URLs **before building** frontend image. Jenkinsfile is a baseline and does not yet pass these build arguments.
4. Set AWS_REGION and run `scripts/create-ecr.sh` using least-privilege AWS credentials.
5. Create a Jenkins pipeline from SCM with this repository, install required plugins, configure Jenkins credential ID `aws-jenkins`, AWS CLI and Docker agent, and configure GitHub webhook securely. `PUSH_TO_ECR` defaults to false to avoid accidental pushes.
6. Review EKS costs, IAM, networking and run `scripts/create-eks-example.sh` only with approved AWS access.
7. Use Helm `helm lint helm/streamingapp` and `helm template streamingapp helm/streamingapp`; update values with account ID, version tag and app-specific settings.
8. Supply database secrets through External Secrets / Secrets Manager for production; **do not commit secrets**. The chart's Secret is a demonstrative placeholder.
9. Deploy using Helm after updating backend env variables and frontend URLs. Verify `kubectl get pods,svc,hpa -n streamingapp`, logs and service connectivity.
10. Install/configure CloudWatch Observability add-on or Fluent Bit for EKS application logs; configure log retention, dashboards and alarms. The included CloudWatch agent JSON is an EC2 example, **not** a complete EKS logging deployment.
11. Validate frontend and all backend APIs; generate load to validate HPA and document measured results.

## Gaps before production
No real AWS resources provisioned; no verified Jenkins run; no tested images; frontend public access/Ingress not configured; app secrets/env not fully mapped; MongoDB deployment is external; CloudWatch EKS integration is instructions only; Helm chart is an initial template and needs application-specific testing. No guarantee of grading acceptance.

## Suggested evidence screenshots (only after actual execution)
Jenkins successful build, ECR repositories and tags, EKS nodes/pods, Helm release, frontend UI and API health, HPA scaling, CloudWatch log group/metrics.
