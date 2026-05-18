# Estágio 1 — instala dependências
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Estágio 2 — imagem final limpa
FROM python:3.12-slim

WORKDIR /app

# Atualiza pacotes do SO — corrige CVEs com fix disponível
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

# Copia só as dependências instaladas — não o ambiente de build
COPY --from=builder /install /usr/local

COPY app.py .

EXPOSE 5000

# Usuário não-root — nunca rodar container como root em produção
RUN useradd -m appuser
USER appuser

CMD ["python", "app.py"]
