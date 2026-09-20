# ADR Backend 0002: Value Object Money com Centavos Inteiros (Eliminação de Ponto Flutuante)

* **Status:** Aceito
* **Data:** 2026-09-02
* **Decisores:** Time Backend / Arquitetura
* **Contexto:** Econopreço Service V2

## Contexto e Declaração do Problema
Na V1 do Econopreço, os preços dos produtos eram representados por números de ponto flutuante (`f64`). 
Em operações de agregação de cestas familiares de supermercado (compostas por dezenas ou centenas de itens), as discrepâncias inerentes à aritmética binária do padrão IEEE 754 (`0.1 + 0.2 = 0.30000000000000004`) provocavam erros acumulados de arredondamento nos totais da cesta e quebras de validação de cupons e descontos.

## Decisão Escolhida
Criar um **Value Object `Money`** fortemente tipado e imutável no crate `domain`:

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Serialize, Deserialize)]
pub struct Money {
    cents: i64,
    currency: Currency, // BRL
}
```

### Regras de Domínio Aplicadas:
1. **Centavos Inteiros (`i64`):** O valor R$ 19,99 é armazenado estritamente como `1999` centavos.
2. **Sobrecarga de Operadores Seguros (`std::ops`):** Implementados `Add`, `Sub` e `Mul`. Qualquer tentativa de somar moedas de tipos distintos dispara erro de domínio em tempo de compilação ou execução.
3. **Persistência Relacional:** Gravado no PostgreSQL como `BIGINT` (tipo numérico inteiro exato), eliminando divergências no driver do banco de dados.

## Consequências e Trade-offs

### Prós:
* **Zero Divergência Matemática:** 100% de exatidão em somas, subtrações e comparações de carrinhos de compras.
* **Segurança de Tipos:** Impossibilita que um desenvolvedor subtraia um `Money` de um tipo escalar arbitrário sem conversão explícita.
* **Performance:** Operações com inteiros nativos (`i64`) em processadores x86_64/ARM são ordens de grandeza mais rápidas do que operações com tipos de precisão arbitrária baseados em software (como `BigDecimal`).

### Contras e Mitigações:
* **Divisão com Resto:** Divisões de parcelas podem gerar centavos residuais. *(Mitigação: Implementação do método de distribuição de centavos pelo algoritmo de Hare-Niemeyer / Maior Resto no domain).*
