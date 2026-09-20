# ADR Backend 0004: Adoção de UUIDv7 para Chaves Primárias no PostgreSQL

* **Status:** Aceito
* **Data:** 2026-09-02
* **Decisores:** Time Backend / Arquitetura
* **Contexto:** Econopreço Service V2

## Contexto e Declaração do Problema
O Econopreço persiste centenas de milhares de produtos, preços históricos e listas de compras.
* **Inteiros Sequenciais (`BIGSERIAL` / `IDENTITY`):** Permitem adivinhação de IDs (enumeração de URLs públicas), expõem métricas de negócio e dificultam a geração de chaves em nós distribuídos sem ida ao banco.
* **UUIDv4 Tradicional:** É totalmente aleatório. Em bancos relacionais baseados em árvores B-Tree (como o PostgreSQL), a inserção aleatória de UUIDv4 provoca fragmentação severa de páginas no disco (*B-Tree page splitting*), degradação progressiva de performance de escrita e inflação do tamanho dos índices no cache de memória RAM.

## Decisão Escolhida
Padronizar todas as chaves primárias e identificadores de entidades com **UUIDv7** (RFC 9562).

```rust
use uuid::Uuid;

pub fn generate_id() -> Uuid {
    Uuid::now_v7()
}
```

### Características do UUIDv7:
1. **Ordenação Cronológica (Time-Ordered):** Os primeiros 48 bits contêm o timestamp Unix em milissegundos, seguidos por bits de aleatoriedade criptográfica.
2. **Geração Descentralizada:** Os IDs podem ser gerados com segurança no cliente Flutter ou nos workers do Rust antes de qualquer escrita no PostgreSQL, sem risco de colisão.
3. **Compatibilidade Nativa:** Armazenado nativamente no tipo `UUID` (16 bytes) do PostgreSQL.

## Consequências e Trade-offs

### Prós:
* **Preservação da Localidade de Índice (B-Tree Locality):** Inserções ocorrem sempre no final da árvore de índices, eliminando page splits e mantendo a escrita em alta velocidade mesmo com milhões de linhas.
* **Ordenação Natural por Data:** Permite ordenar registros por data de criação (`ORDER BY id DESC`) sem necessidade de criar índices adicionais sobre a coluna `created_at`.
* **Impossibilidade de Enumeração:** Ao contrário de inteiros sequenciais (1, 2, 3), o UUIDv7 não permite que concorrentes adivinhem o número de produtos ou listas cadastradas.

### Contras e Mitigações:
* **Dependência de Relógio:** Se o relógio do sistema retroceder drasticamente, a ordenação estrita entre milissegundos adjacentes pode oscilar. *(Mitigação: A crate `uuid` no Rust implementa proteção monotônica de contador para timestamps idênticos).*
