# Kubernetes DevOps Lab

A hands-on Kubernetes project demonstrating containerization, declarative infrastructure configuration, rolling deployments, self-healing, resource management, monitoring, and horizontal autoscaling.

## Technology Stack

- **Docker** — Containerized an nginx web application
- **Kubernetes** — Container orchestration and workload management
- **kind** — Local Kubernetes cluster running in Docker
- **kubectl** — Kubernetes deployment and administration
- **Metrics Server** — CPU and memory utilization monitoring
- **Git** — Version control

## Architecture

```text
Windows Browser
      |
      | localhost:8082
      v
Docker Published Port
      |
      | NodePort 30080
      v
Kubernetes Service
      |
      +---- nginx Pod 1
      +---- nginx Pod 2
      +---- nginx Pod 3
      |
      +---- HPA (3–6 replicas)
```

## Features

### Rolling Deployments

Configured rolling updates with:

- `maxSurge: 1`
- `maxUnavailable: 0`
- HTTP readiness probes
- A 5-second minimum readiness period
- A 10-second preStop delay for graceful termination

Tested application availability during version updates using continuous HTTP requests.

### Self-Healing

Verified that Kubernetes automatically recreates deleted Pods to maintain the desired replica count.

### Resource Management

Configured per-container resource requests and limits:

| Resource | Request | Limit |
|---|---|---|
| CPU | 50m | 200m |
| Memory | 32Mi | 128Mi |

### Horizontal Pod Autoscaling

Configured CPU-based autoscaling:

- Minimum replicas: 3
- Maximum replicas: 6
- Target CPU utilization: 50%

**Test results:** Under synthetic CPU load, utilization reached 401%, triggering an increase from 3 to 6 replicas. After load stopped, utilization returned to approximately 2%, and Kubernetes automatically scaled back to 3 replicas.

## Running the Project

### Prerequisites

- Docker
- kind
- kubectl

### Create the Cluster

```bash
kind create cluster --name devops-lab --config kind-config.yaml
```

### Build and Load the Application

```bash
docker build -t kubernetes-lab:v2 .
kind load docker-image kubernetes-lab:v2 --name devops-lab
```

### Deploy to Kubernetes

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f hpa.yaml
```

The HPA requires Metrics Server to be installed and functioning.

### Access the Application

Open:

http://localhost:8082

### Monitor the Deployment

```bash
kubectl get deployments
kubectl get pods
kubectl get hpa
kubectl top pods
```

## Lessons Learned

- Declarative Kubernetes configuration enables repeatable deployments.
- Readiness probes help prevent traffic from reaching unready Pods.
- Graceful shutdown procedures can reduce connection failures during rolling updates.
- Kubernetes Deployments automatically replace failed or deleted Pods.
- CPU requests influence scheduling and HPA utilization calculations.
- Horizontal Pod Autoscaling responds to changing application demand.

## Future Improvements

- Add CI/CD with GitHub Actions
- Implement automated deployment validation
- Add liveness and startup probes where appropriate
- Deploy to a managed Kubernetes service such as Amazon EKS
- Provision cloud infrastructure using Terraform
