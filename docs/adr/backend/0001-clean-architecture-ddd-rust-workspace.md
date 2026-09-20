# ADR Backend 0001: Clean Architecture (Hexagonal) e DDD em Workspace Rust

* **Status:** Aceito
* **Data:** 2026-09-02
* **Decisores:** Time Backend / Arquitetura
* **Contexto:** Econopreço Service V2

## Contexto e Declaração do Problema
Na V1 (`econopreco_service`), o código foi estruturado em crates com dependências circulares e acoplamento direto entre lógica de scraping, regras de precificação e persistência SQLx. Qualquer alteração em tabelas do banco forçava refatorações nas regras de negócio.
Para a V2, o sistema necessita de uma separação estrita onde a lógica de domínio seja 100% pura, independente de drivers externos, bibliotecas de banco de dados ou frameworks HTTP.

## Decisão Escolhida
Adotar **Clean Architecture (Hexagonal / Ports & Adapters)** combinada com **Domain-Driven Design (DDD)** estruturada como um Cargo Workspace multirate:

```text
crates/
├── domain/          # Entidades, Value Objects e Ports (Interfaces puras, zero dependências pesadas)
├── application/     # Casos de Uso (Search, Basket Comparison, Collaborative Lists)
├── infrastructure/  # Adapters: SQLx PostgreSQL, Redis L2, Cloudflare R2 e HTTP Crawlers
├── api/             # Camada de Apresentação: Axum 0.8 REST Handlers & Middlewares
└── cli/             # Binários CLI: Ingestor, Normalizer e Image Worker
```

### Inversão de Dependências (DIP)
* O crate `domain` define traits (Ports) como `ProductRepository`, `MarketCrawler` e `ListShareTokenPort`.
* O crate `infrastructure` implementa esses traits (Adapters) consumindo `sqlx::PgPool` e `redis::aio::ConnectionManager`.
* O crate `api` e os binários `cli` apenas orquestram o container de injeção de dependências no `main.rs`.

## Consequências e Trade-offs

### Prós:
* **Testabilidade de Domínio em Milissegundos:** É possível testar todas as regras de agrupamento de produtos e cálculo de cestas com mocks em memória, sem precisar subir containers Docker de banco de dados.
* **Isolamento de Mudanças:** Mudar uma query SQL ou a versão do Axum não afeta em nada as entidades de negócio.
* **Compilação Incremental:** O compilador do Rust (`rustc`) recompila apenas as crates que sofreram alterações reais.

### Contras e Mitigações:
* **Maior Verbosidade Inicial:** Necessidade de mapear DTOs entre `Entity` -> `DatabaseModel` -> `HttpResponseDto`. *(Mitigação: Implementação de traits `From` / `Into` automáticos com derive macros).*
