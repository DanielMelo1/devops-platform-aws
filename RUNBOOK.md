# RUNBOOK — devops-platform-aws

Registro de problemas encontrados durante a construção e operacao do projeto.
Serve como referencia para resolucao rapida de incidentes recorrentes.

---

## M2 — RDS + Docker

### P1 — TFLint: required_version faltando
**Sintoma:** tflint --recursive reporta warning em modules/database/main.tf
**Causa:** bloco terraform sem required_version
**Solucao:** adicionar required_version = ">= 1.5.0" em todos os modulos
**Licao:** padrao obrigatorio em todos os modulos Terraform

### P2 — AWS API: caracteres especiais nas descriptions
**Sintoma:** terraform plan falha com erro de validacao no Security Group
**Causa:** travessoes e acentos nao sao aceitos pela AWS nas descriptions
**Solucao:** substituir travessoes por hifen e remover acentos
**Licao:** descriptions da AWS sempre em ASCII puro

### P3 — RDS versao depreciada
**Sintoma:** terraform apply falha — Cannot find version 15.7 for postgres
**Causa:** PostgreSQL 15.7 foi depreciado pela AWS
**Solucao:** atualizar para versao mais recente disponivel
**Comando para verificar:** aws rds describe-db-engine-versions --engine postgres --output table --region us-east-1

### P4 — Checkov: 12 failures no modulo database
**Sintoma:** checkov reporta failures no aws_db_instance e aws_security_group
**Solucao aplicada:**
  - CKV_AWS_16  → storage_encrypted = true
  - CKV_AWS_23  → description adicionada nas regras do SG
  - CKV_AWS_226 → auto_minor_version_upgrade = true
  - CKV2_AWS_60 → copy_tags_to_snapshot = true
  - 8 checks    → skip com justificativa tecnica documentada

---

## M3 — EKS + Helm

### P5 — TFLint: variaveis nao usadas no compute
**Sintoma:** tflint reporta vpc_id e eks_nodes_sg_id declaradas mas nao usadas
**Causa:** EKS descobre VPC pelas subnets. SG dos nodes gerenciado via tags
**Solucao:** remover as duas variaveis do variables.tf e do envs/dev/main.tf

### P6 — IRSA: data source antes do cluster existir
**Sintoma:** terraform plan falha — couldn't find resource aws_eks_cluster
**Causa:** data "aws_eks_cluster" no modulo security tentava ler cluster inexistente
**Solucao:** mover irsa.tf para modulo compute — referenciar aws_eks_cluster.main diretamente
**Licao:** data sources que dependem de recursos devem estar no mesmo modulo

### P7 — Service Account faltando no Kubernetes
**Sintoma:** pods em FailedCreate — serviceaccount app-service-account not found
**Causa:** IRSA cria IAM role mas nao cria Service Account no Kubernetes
**Solucao:** criar helm/app/templates/serviceaccount.yaml
**Licao:** IRSA exige criacao explicita do Service Account no cluster

### P8 — Variavel de ambiente nao resolvia no pod
**Sintoma:** CrashLoopBackOff — could not translate host name "$(DB_HOST)"
**Causa:** DB_HOST declarado depois de DATABASE_URL que o referencia
**Solucao:** declarar DB_PASSWORD e DB_HOST antes de DATABASE_URL no deployment.yaml
**Licao:** no Kubernetes a interpolacao de variaveis depende da ordem de declaracao

### P9 — ECR criado manualmente
**Decisao:** aceito para o projeto
**Comando:** aws ecr create-repository --repository-name devops-platform --region us-east-1
**Producao real:** adicionar ao modulo compute via aws_ecr_repository

### P10 — Secret db-secret criado manualmente
**Decisao:** aceito para o projeto — passo manual pre-deploy
**Comando:**
  kubectl create secret generic db-secret
    --from-literal=host=ENDPOINT_RDS
    --from-literal=password=SENHA
**Producao real:** External Secrets Operator integrado ao SSM

---

## M4 — GitHub Actions

### P11 — AWS credentials erro no pipeline
**Sintoma:** Credential must have exactly 5 slash-delimited elements
**Causa:** AWS_ACCESS_KEY_ID cadastrado incorretamente no GitHub Secrets
**Solucao:** recadastrar — Access Key comeca com AKIA e tem 20 caracteres

### P12 — Terraform version incompativel no pipeline
**Sintoma:** use_lockfile is not expected here
**Causa:** pipeline usava terraform_version 1.5.0 — use_lockfile requer 1.10+
**Solucao:** atualizar terraform_version para 1.15.2 no pipeline.yml

### P13 — setup-terraform@v3 incompativel
**Sintoma:** mesmo erro apos atualizar versao do Terraform
**Solucao:** atualizar hashicorp/setup-terraform@v3 para @v4

---

## Checklist pre-deploy

    terraform validate
    tflint --recursive
    checkov -d . --framework terraform
    docker build + trivy scan
    terraform plan — revisar antes do apply
    kubectl create secret db-secret
    helm upgrade --install

---

## Contato

Daniel Melo
linkedin.com/in/danielaugustormelo
github.com/DanielMelo1

---

## Comandos Operacionais

### Verificar saude do cluster
    kubectl get nodes
    kubectl get pods -A
    kubectl top nodes
    kubectl top pods

### Verificar logs da aplicacao
    kubectl logs -l app=app --tail=100
    kubectl logs -l app=app --tail=100 --previous

### Rollback de deploy
    helm rollback app 1
    kubectl rollout undo deployment/app

### Verificar status do HPA
    kubectl get hpa
    kubectl describe hpa app

### Verificar RDS via AWS CLI
    aws rds describe-db-instances --db-instance-identifier devops-platform-dev --query DBInstances[0].DBInstanceStatus --output text

### Verificar alarmes CloudWatch
    aws cloudwatch describe-alarms --state-value ALARM --region us-east-1

### Recriar secret do banco apos destroy
    kubectl create secret generic db-secret       --from-literal=host=ENDPOINT_RDS       --from-literal=password=SENHA

---

## Custo Estimado por Hora

| Recurso | Custo/hora |
|---|---|
| NAT Gateway | ~USD 0.045 |
| RDS t3.micro | ~USD 0.017 |
| EKS control plane | ~USD 0.10 |
| 2x EC2 t3.medium | ~USD 0.083 |
| Total estimado | ~USD 0.245 |

Destruir apos validacao: terraform destroy
