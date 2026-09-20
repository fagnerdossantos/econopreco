# ADR Backend 0005: Cache L2 com Redis e Queries Preparadas em Tempo de Compilação com SQLx

* **Status:** Aceito
* **Data:** 2026-09-02
* **Decisores:** Time Backend / Arquitetura
* **Contexto:** Econopreço Service V2

## Contexto e Declaração do Problema
O Econopreço atende a consultas repetitivas de catálogo de supermercado (ex: busca por código EAN de arroz, café, leite) disparadas por milhares de usuários navegando simultaneamente pelo app mobile.
O banco de dados relacional (PostgreSQL) deve ser preservado de sobrecarga para suportar transações de escrita e agregação de cestas.
Além disso, queries dinâmicas baseadas em strings concatenadas aumentam o risco de SQL Injection e falhas de runtime que só são descobertas em produção.

## Decisão Escolhida
Implementar uma arquitetura de dados em duas camadas:
1. **Cache L2 Read-Through com Redis 7:** Consultas de busca por EAN e catálogo de produtos passam primeiro pelo Redis serializadas em binário enxuto ou JSON comprimido.
2. **SQLx com Verificação em Tempo de Compilação:** Todas as queries do PostgreSQL utilizam o macro `sqlx::query!` / `sqlx::query_as!`.

```rust
// O compilador do Rust conecta no PostgreSQL durante o build e valida:
// 1. Se a tabela e colunas existem
// 2. Se os tipos de dados do Rust batem exatamente com os tipos do SQL
let product = sqlx::query_as!(
    ProductRecord,
    r#"
    SELECT id, ean, name, category_id, created_at
    FROM products
    WHERE ean = $1
    "#,
    ean.as_str()
)
.fetch_optional(&self.pool)
.await?;
```

## Consequências e Trade-offs

### Prós:
* **Latência Sub-3ms:** Consultas com cache hit no Redis respondem em menos de 2 a 3 milissegundos.
* **Segurança Absoluta contra SQL Injection:** Como todas as queries são preparadas e parametrizadas nativamente, o risco de injeção de SQL é zero.
* **Impossibilidade de Erros de Schema em Produção:** Se uma coluna do PostgreSQL for renomeada ou removida sem atualizar o código Rust, o projeto **recusa-se a compilar**.

### Contras e Mitigações:
* **Invalidação de Cache:** Quando os crawlers atualizam o preço de um item, o cache antigo precisa ser invalidado. *(Mitigação: Padrão Cache Eviction via pub/sub interno ou TTL dinâmico de 1 a 4 horas nos nós de produto).*
* **Build Requer Conexão com Banco:** O `cargo build` precisa validar o schema contra um banco de desenvolvimento. *(Mitigação: Uso do modo offline do SQLx com arquivo `sqlx-data.json` salvo no repositório para builds no CI/CD).*
