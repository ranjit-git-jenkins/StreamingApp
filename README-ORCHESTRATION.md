# StreamingApp — Orchestration and Scaling Project Add-on

This directory is a **supplemental add-on** for the fork at https://github.com/ranjit-git-jenkins/StreamingApp. Copy the contents into the root of the existing fork; do not delete the original application files.

## Included
- `Jenkinsfile`: five Docker image builds; optional Amazon ECR push
- `scripts/`: example ECR creation, EKS creation, Helm deployment
- `helm/streamingapp/`: baseline Deployments, Services, CPU HPA, sample Secret
- `monitoring/`: example CloudWatch agent config (EC2)
- `docs/architecture.drawio`: editable conceptual architecture
- `docs/IMPLEMENTATION_GUIDE.md`: deployment workflow, limitations, evidence checklist

## Important
**Not executed or verified against AWS, Jenkins, Docker, Helm, or EKS.** Check repository path names, backend environment variables and frontend build-time URLs. HPA requires metrics-server. No Ingress is included; app public access requires separate configuration. MongoDB is not deployed by this Helm chart. Do not commit real credentials or use demo secrets in production.

See `docs/IMPLEMENTATION_GUIDE.md` for exact next steps and limitations.
