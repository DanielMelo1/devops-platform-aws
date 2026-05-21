# devops-platform-aws

![CI/CD](https://github.com/DanielMelo1/devops-platform-aws/actions/workflows/pipeline.yml/badge.svg)


Plataforma DevOps completa na AWS — do commit ao deploy em produção.
Construída para demonstrar o ciclo completo de operação: infraestrutura como código,
containerização, orquestração, CI/CD, segurança e observabilidade.

---

## Arquitetura

![Arquitetura](./docs/architecture.png)

> Arquivo editavel disponivel em [draw.io](https://drive.google.com/file/d/1rShSoSYqLz2x4_eYpWcZQh0acEYt6Uy2/view?usp=sharing)

---

## Stack

| Camada | Tecnologia | Por que foi escolhida |
|---|---|---|
| Aplicação | Python Flask + PostgreSQL | API REST simples — foco na operação, não no código |
| Container | Docker multi-stage | Imagem menor e segura — sem ferramentas de build expostas |
| Registry | Amazon ECR | Registry gerenciado — integração nativa com EKS e IAM |
| Orquestração | EKS + Helm | Kubernetes gerenciado — padrão em 80% das empresas com K8s |
| IaC | Terraform modular | Reutilizável, versionado, separação clara entre ambientes |
| CI/CD | GitHub Actions | Integrado ao repositório — zero infraestrutura adicional |
| Segurança IaC | TFLint + Checkov | Valida boas práticas e segurança antes do apply |
| Segurança imagem | Trivy | Detecta CVEs na imagem antes do deploy |
| Banco | RDS PostgreSQL Multi-AZ | Failover automático — banco nunca é single point of failure |
| Rede | VPC + Subnets + NAT | Isolamento — workloads privados sem IP público |
| Segredos | SSM Parameter Store | Credenciais nunca hardcoded — padrão obrigatório em times reais |
| Observabilidade | CloudWatch + Grafana | Métricas, alarmes e dashboards consolidados |
| Auto Scaling | HPA | Escala pods em segundos baseado em CPU |
| Estado Terraform | S3 + DynamoDB | Remote state com lock — evita conflitos em times |
| Resiliência | Pod Disruption Budget | Disponibilidade garantida durante manutenções |

---

## O que cada componente resolve

**VPC Multi-AZ**
Isola os workloads da internet. Subnets privadas garantem que RDS e nodes EKS
nunca recebem IP público. Duas zonas de disponibilidade eliminam a dependência
de uma única região física.

**RDS PostgreSQL Multi-AZ**
Banco gerenciado com failover automático. Se a instância primária falhar,
a réplica assume em menos de 60 segundos sem intervenção manual.
Backup automático de 7 dias garante recuperação pontual.

**EKS + Helm**
Kubernetes gerenciado elimina a operação do control plane.
Helm Charts com values separados por ambiente permitem o mesmo chart
em contextos diferentes sem duplicação de código.

**IRSA — IAM Roles for Service Accounts**
Pods assumem IAM roles automaticamente via OIDC.
Elimina completamente chaves de acesso hardcoded.
Credenciais temporárias expiram automaticamente.

**HPA + PDB**
HPA escala pods horizontalmente quando CPU ultrapassa 70%.
PDB garante que pelo menos 1 pod permanece disponível durante
atualizações do cluster — zero downtime em manutenções.

**GitHub Actions Pipeline**
Automatiza o ciclo completo: validação de IaC, scan de segurança,
build, scan de imagem, push e deploy. Nenhum código chega em produção
sem passar por TFLint, Checkov e Trivy.

**CloudWatch + Grafana**
CloudWatch coleta métricas nativas AWS — RDS CPU, conexões, latência.
Grafana consolida em dashboards operacionais com alertas via SNS.

---

## SLOs

| Métrica | Objetivo |
|---|---|
| Disponibilidade | >= 99.5% em 30 dias |
| Latência P95 | < 400ms |
| Taxa de erros 5xx | <= 0.5% |
| Error budget mensal | 216 minutos |

Detalhes em [SLO.md](./SLO.md).

---

## Estrutura do Repositório

    terraform/modules/
      network/     — VPC, subnets, IGW, NAT Gateway
      database/    — RDS PostgreSQL, subnet group, security group
      security/    — Security Groups EKS, IAM roles, IRSA
      compute/     — EKS cluster, node group
      monitoring/  — CloudWatch alarms, SNS

    envs/dev/      — Ambiente de desenvolvimento
    envs/prod/     — Ambiente de produção

    helm/app/      — Helm Chart da API Flask
    helm/grafana/  — Helm Chart do Grafana

    k8s/           — Pod Disruption Budget, Metrics Server
    app/           — Aplicação Flask + Dockerfile
    .github/       — GitHub Actions pipeline

---

## Como Provisionar

**1. Bootstrap**

    cd bootstrap/
    terraform init && terraform apply

**2. Infraestrutura**

    cd envs/dev/
    terraform init
    terraform apply -var="db_password=SUA_SENHA"

**3. Configurar kubectl**

    aws eks update-kubeconfig --name devops-platform-dev --region us-east-1

**4. Criar Secret do banco**

    kubectl create secret generic db-secret \
      --from-literal=host=ENDPOINT_RDS \
      --from-literal=password=SUA_SENHA

**5. Instalar Metrics Server**

    kubectl apply -f k8s/metrics-server.yaml

**6. Deploy da aplicação**

    helm upgrade --install app ./helm/app \
      -f ./helm/app/values-dev.yaml \
      --set image.tag=SHA_DO_COMMIT

**7. Deploy do Grafana**

    helm upgrade --install grafana grafana/grafana \
      -f ./helm/grafana/values-dev.yaml \
      --namespace monitoring --create-namespace

---

## Decisões Técnicas

**Terraform modular e não um único arquivo**
Módulos permitem reutilização entre ambientes e times.
Separação de responsabilidades reduz o blast radius de mudanças.

**EKS e não ECS**
EKS é o padrão de mercado para workloads Kubernetes.
Helm Charts, HPA e PDB são nativos do K8s.

**SSM Parameter Store e não Secrets Manager**
Para o escopo do projeto SSM Standard tier é gratuito.
Secrets Manager tem custo por secret — adequado para prod com muitos segredos.

**endpoint_public_access = true no EKS**
Necessário para kubectl do ambiente local durante o desenvolvimento.
Em produção seria false — acesso via VPN ou bastion host.

---

## Pipeline CI/CD

Cada push na branch main dispara automaticamente:

    Validate IaC  → terraform validate + tflint + checkov
    Build         → docker build com tag git SHA
    Scan          → trivy — bloqueia em CRITICAL
    Push          → docker push ECR
    Deploy        → helm upgrade no EKS
    Verify        → kubectl rollout status

---

## Autor

Daniel Melo — DevOps | SRE | AWS Certified Solutions Architect Professional

[LinkedIn](https://linkedin.com/in/danielaugustormelo) | [GitHub](https://github.com/DanielMelo1)


