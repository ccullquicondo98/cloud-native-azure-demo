# Cloud Native Azure Demo

## Overview

This project implements a **cloud-native application on Microsoft Azure**, designed as part of a technical challenge for a Cloud Engineer role.  
The solution follows modern cloud principles, leveraging managed services, container orchestration, Infrastructure as Code (IaC), and CI/CD automation.

The architecture is composed of:
- A **containerized backend API** running on Azure Kubernetes Service (AKS)
- A **managed relational database** (Azure Database for MySQL – Flexible Server)
- **Object storage** using Azure Blob Storage
- A **serverless frontend** deployed with Azure Static Web Apps
- Infrastructure provisioned using **Terraform**
- Full source control and automation via **GitHub**



## 🧩 Architecture Diagram (Logical View)
┌──────────────────────────────┐
│ Azure Static Web Apps (HTTPS)│
│ - HTML / JS Frontend │
└───────────────┬──────────────┘
│
┌───────────────▼──────────────┐
│ Azure Kubernetes Service │
│ (AKS) │
│ │
│ ┌────────────────────────┐ │
│ │ FastAPI Backend Pod │ │
│ │ - REST API │ │
│ │ - File Upload/Download │ │
│ └───────────┬────────────┘ │
│ │ │
│ ┌───────▼────────┐ │
│ │ MySQL Flexible │ │
│ │ Server │ │
│ └────────────────┘ │
│ │ │
│ ┌───────▼────────┐ │
│ │ Blob Storage │ │
│ │ (objects) │ │
│ └────────────────┘ │
└──────────────────────────────┘


> **Note**: In a production-grade deployment, the backend would be exposed through an HTTPS Ingress Controller with TLS termination, enabling secure frontend-to-backend communication.

---

## Backend

- **Framework**: FastAPI (Python)
- **Containerized** using Docker
- **Endpoints**:
  - `/health` – Health check
  - `/items` – Read data from MySQL
  - `/files/upload` – Upload files to Blob Storage
  - `/files/download/{filename}` – Download files from Blob Storage
- **Secrets management**:
  - Kubernetes Secrets used for database credentials and storage connection strings

---

## Database

- **Service**: Azure Database for MySQL – Flexible Server
- **Access mode**: Private network access
- Used to store application data (`items`)

---

## Object Storage

- **Service**: Azure Blob Storage
- **Container**: `objects`
- Used for file upload and download operations from the backend API

---

## Frontend

- **Service**: Azure Static Web Apps
- **Technology**: HTML, JavaScript, CSS
- **Features**:
  - Backend health validation
  - MySQL items listing
  - File upload to Blob Storage
  - File download from Blob Storage

> Due to HTTPS enforcement in Azure Static Web Apps, browser-based fetch calls to an HTTP backend are blocked by security policies (Mixed Content). This is documented as a known limitation and addressed as a future improvement.

---

## Infrastructure as Code (IaC)

- **Tool**: Terraform
- **Provisioned resources**:
  - Resource Group
  - Virtual Network and Subnets
  - Azure Kubernetes Service (AKS)
  - Azure Database for MySQL
  - Azure Container Registry
  - Azure Blob Storage

Terraform ensures:
- Reproducible infrastructure
- Version-controlled cloud resources
- Clean teardown and redeployment

---

## CI/CD

- **Source Control**: GitHub
- **Automation**:
  - Azure Static Web Apps CI/CD via GitHub Actions
  - Automatic frontend deployment on each push to `main`

---

## Security Considerations

- Private networking for database access
- Secrets stored in Kubernetes Secrets
- HTTPS enforced at frontend level
- Backend HTTPS via Ingress + TLS documented as production improvement

---

## Known Limitations & Future Improvements

- Expose backend via **HTTPS Ingress Controller**
- Enable TLS using **cert-manager + Let’s Encrypt**
- Introduce API Gateway or Application Gateway
- Add authentication (Entra ID)
- Implement observability (logs, metrics, alerts)

---

## Conclusion

This project demostrates the implementation of a modern cloud-native architecture on Azure, covering container orchestration, managed services, object storage, infrastructure automation, and CI/CD.  
The solution is designed with scalability, maintainability, and security best practices in mind, while clearly documenting limitations and future improvements.

---
