# SLO — Service Level Objectives
## devops-platform-aws

## Objetivo

Define os objetivos de nível de serviço da API de pedidos
rodando no EKS. Serve como referência para alertas do
CloudWatch e dashboards do Grafana.

## SLOs Definidos

### Disponibilidade

| Métrica | Objetivo | Janela |
|---|---|---|
| Uptime da API | >= 99.5% | 30 dias |
| Taxa de erro HTTP 5xx | <= 0.5% | 1 hora |

Por que 99.5%:
Permite até 3h36min de indisponibilidade por mês.
Adequado para ambiente não crítico com janela de manutenção.

### Latência

| Métrica | Objetivo | Percentil |
|---|---|---|
| Tempo de resposta | < 400ms | P95 |
| Tempo de resposta | < 1000ms | P99 |

Por que P95 < 400ms:
95% das requisições respondem em menos de 400ms.

### Throughput

| Métrica | Objetivo |
|---|---|
| Requisições por segundo | >= 100 rps com latência dentro do SLO |

## Como Medimos

- CloudWatch → métricas de CPU, memória, erros HTTP
- Metrics Server → métricas de pods e nodes para HPA
- Grafana → dashboards consolidados em tempo real

## Alertas — CloudWatch Alarms

| Alarme | Threshold | Ação |
|---|---|---|
| CPU dos pods > 80% | 5 minutos | HPA escala pods |
| Erros 5xx > 1% | 5 minutos | Notifica Slack |
| RDS CPU > 70% | 10 minutos | Notifica Slack |
| Nodes CPU > 70% | 10 minutos | Node group escala |

## Error Budget

Com SLO de 99.5% em 30 dias:
- Total de minutos no mês: 43.200
- Budget de erros 0.5%: 216 minutos

Se o budget for consumido antes do fim do mês
— congelar deploys e focar em estabilidade.

## Componentes que Garantem os SLOs

| Componente | Problema que resolve |
|---|---|
| HPA | Escala pods automaticamente — mantém latência |
| PDB | Garante mínimo de pods — mantém disponibilidade |
| RDS Multi-AZ | Failover automático — mantém disponibilidade |
| Liveness Probe | Reinicia pods com falha — mantém disponibilidade |
| Readiness Probe | Não envia tráfego para pods não prontos |
| Multi-AZ Nodes | Resiliência a falha de AZ |

Documento criado no M5 — maio 2026
Revisão: a cada trimestre ou após incidente
