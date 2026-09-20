# ADR Backend 0003: Ingestão em Round-Robin Adaptativo com Cooldowns Isolados (Anti-WAF)

* **Status:** Aceito
* **Data:** 2026-09-02
* **Decisores:** Time Backend / Arquitetura
* **Contexto:** Econopreço Service V2

## Contexto e Declaração do Problema
O Econopreço extrai preços de 7 grandes redes varejistas do Brasil (*Carrefour, Pão de Açúcar, Extra, Mundial, Supermarket, SuperPrix e Guanabara*).
Na V1, o ingestor processava um supermercado por vez em lote (`--market carrefour`). Essa estratégia gerava um pico de dezenas de requisições HTTP concentradas no mesmo host em poucos segundos, ativando defesas automáticas de WAF (Cloudflare, Akamai, Imperva), resultando em respostas `429 Too Many Requests`, bloqueios de IP e necessidade de rotação de proxies de alto custo financeiro.

## Decisão Escolhida
Implementar um **Scheduler Concorrente em Round-Robin Adaptativo com Cooldowns Isolados por Domínio** utilizando o runtime assíncrono do Tokio:

```text
Fila de Tarefas: [Carrefour_Item1, Guanabara_Item1, Mundial_Item1, Extra_Item1, ...]
                         │
                         ▼
        ┌───────────────────────────────────┐
        │  Round-Robin Task Dispatcher      │
        └───────────────────────────────────┘
          │ (Host A)        │ (Host B)        │ (Host C)
          ▼                 ▼                 ▼
     [Cooldown: 8s]    [Cooldown: 5s]    [Cooldown: 12s]
```

### Regras do Scheduler:
1. **Fila Intercalada:** O despachante nunca executa duas requisições consecutivas para o mesmo domínio se houver requisições pendentes de outros domínios na fila.
2. **Temporizadores de Cooldown Independentes:** Cada rede varejista possui seu próprio semáforo de taxa de limite configurável via TOML (`requests_per_minute` e `cooldown_ms`).
3. **Backoff Exponencial Adaptativo:** Ao receber status `429` ou `503`, apenas o semáforo daquele domínio específico dobra sua janela de espera; os workers continuam processando as outras 6 redes normalmente.

## Consequências e Trade-offs

### Prós:
* **Taxa de Sucesso de 99.4%:** Bloqueios de WAF reduzidos a índices insignificantes sem necessidade de infraestrutura de proxies caros.
* **Comportamento Humano e Polido (Good Citizen):** O tráfego de crawling respeita a capacidade dos servidores dos supermercados, evitando degradação dos serviços do varejista.
* **Aproveitamento Máximo da CPU e Conexão:** A esteira de workers nunca fica ociosa esperando cooldowns; ela sempre tem requisições de outros domínios prontas para envio.

### Contras e Mitigações:
* **Complexidade de Concorrência:** Necessidade de gerenciar semáforos assíncronos (`tokio::sync::Semaphore`) e timers de forma thread-safe. *(Mitigação: Testes unitários com simulação de rede e runtime do Tokio).*
