# StartTech Application: CI/CD and Deployment

A full-stack to-do application with automated delivery to AWS. The infrastructure lives in [starttech-infra](https://github.com/SeunDeve/starttech-infra).

## Stack

- **Backend:** Go API (MuchToDo) with JWT authentication, MongoDB, and Redis caching
- **Frontend:** React and TypeScript
- **Backend hosting:** Docker image in Amazon ECR, deployed to Amazon EKS
- **Frontend hosting:** Amazon S3 and CloudFront

## Repository structure

```
backend/              # Go API and Dockerfile
frontend/             # React app
k8s/                  # Kubernetes manifests
scripts/              # Deploy, health check, and rollback scripts
.github/workflows/    # Backend and frontend pipelines
```

## CI/CD

**Backend:** runs Go tests, builds the Docker image, pushes it to ECR, and deploys to EKS.

**Frontend:** installs dependencies, runs `npm audit`, builds the site, and deploys it to S3 and CloudFront.

## Local development

Copy the example environment files before you start, and never commit real values.

```bash
cp backend/MuchToDo/.env.example backend/MuchToDo/.env
cd backend/MuchToDo && docker compose up
```
