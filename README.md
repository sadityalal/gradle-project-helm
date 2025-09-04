# Gradle Project Helm Charts

This repository contains the **Helm charts** required to deploy the **Gradle Project Application**.  
It works in tandem with the [Application Repository](https://github.com/sadityalal/gradle-project-app) and is designed to integrate with **ArgoCD** for automated deployments.

---

## Purpose

- Provide Helm charts for deploying the application in **development** and **production** environments.
- Enable **CI/CD automation** where Docker images from the application repository are deployed automatically.
- Ensure **environment-specific configurations** through separate values files.

---

## Repository Structure

```bash

.
├── helm-chart/
│ ├── Chart.yaml # Helm chart metadata
│ ├── templates/ # Kubernetes templates (Deployment, Service, etc.)
│ │ └── deployment.yaml
│ ├── values-gradle.yaml # Production environment values
│ └── values-gradle-dev.yaml # Development environment values
├── argo-app-dev.yaml # ArgoCD Application manifest for dev
├── argo-app-prod.yaml # ArgoCD Application manifest for prod
└── README.md
```


---

## How It Works

1. The **Application Repo** builds Docker images and pushes them to a registry.  
2. GitHub Actions updates the Helm chart **values files** (`values-gradle.yaml` and `values-gradle-dev.yaml`) with the latest image tag and repository.  
3. **ArgoCD** watches this Helm repository and automatically deploys updates to Kubernetes:

| Environment | Branch        | Helm Values File          | Kubernetes Namespace |
|------------|---------------|--------------------------|--------------------|
| Development | `develop`    | `values-gradle-dev.yaml` | `backend-dev`       |
| Production  | `main`       | `values-gradle.yaml`     | `backend`           |

---

## Deployment Instructions

1. **Clone this repo**:

```bash
git clone https://github.com/sadityalal/gradle-project-helm.git
cd gradle-project-helm
```

2. **Install ArgoCD** on your Kubernetes cluster if not already installed.
3. **Apply ArgoCD manifests** :

```bash
kubectl apply -f argo-app-dev.yaml
kubectl apply -f argo-app-prod.yaml
```

4. Make sure your application repository is configured to update image tags in this Helm repo via CI/CD.


## Best Practices

- **Developers should only push to the `develop` branch.**
- **After thorough testing and review, merge changes to `main` for production deployment.**
- **Ensure secrets** (like Docker registry credentials) are managed properly to allow image pulls in Kubernetes.
