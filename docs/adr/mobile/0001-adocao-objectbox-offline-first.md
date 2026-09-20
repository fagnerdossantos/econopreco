# ADR 0001: Adoção do ObjectBox para Armazenamento e Busca Local Offline-First

* **Status:** Aceito
* **Data:** 2026-09-02
* **Decisores:** Time Mobile / Engenharia

## Contexto e Declaração do Problema
O Econopreço é uma plataforma comparadora de preços de supermercados onde o usuário frequentemente se encontra em ambientes de baixa ou nula conectividade móvel (como subsolos e galpões de atacarejos). 
A experiência de uso exige:
1. **Busca instantânea (conforme o usuário digita):** Filtragem em uma base local de milhares de itens sem engasgos de interface (60/120 fps).
2. **Persistência de listas de compras:** Cestas comparativas com sincronização assíncrona bidirecional com o backend em Rust.
3. **Eficiência de Bateria e CPU:** O cálculo de totais de cestas em tempo real não pode aquecer o aparelho ou travar a thread de UI do Dart.

## Opções Consideradas
1. **SQLite (`sqflite` / `drift`):** Padrão relacional consolidado no ecossistema Flutter.
2. **Hive:** Solução NoSQL em Dart puro baseada em caixas (key-value).
3. **ObjectBox:** Banco de dados NoSQL transacional embarcado em C/C++ nativo de altíssima performance.
4. **SharedPreferences:** Inadequado para dados estruturados complexos.

## Critérios de Decisão
* Latência de leitura e filtragem em coleções com mais de 5.000 itens.
* Suporte a índices secundários e relações (Cesta -> Itens -> Histórico de Preços).
* Transações atômicas (ACID) para evitar inconsistência de carrinho durante o cálculo.
* Suporte a tipagem estrita e geração de código com `build_runner`.

## Decisão Escolhida
Optou-se pelo **ObjectBox**.

### Consequências e Trade-offs

#### Pontos Positivos (Prós):
* **Latência Sub-Milissegundo:** As leituras e consultas no ObjectBox operam na escala de micro/milissegundos por rodarem diretamente sobre bindings nativos em C, eliminando sobrecargas de serialização/desserialização JSON na thread Dart.
* **Consultas Reativas:** Suporte nativo a queries reativas integradas com facilidade a streams do `flutter_bloc`.
* **Zero Overhead de SQL:** Modelo NoSQL orientado a objetos elimina o mapeamento manual Objeto-Relacional (impedance mismatch).
* **Relações Fortes:** Suporte simples a `ToOne` e `ToMany` nativos com integridade referencial.

#### Pontos Negativos (Contras e Mitigações):
* **Aumento do Binário:** A inclusão das bibliotecas C nativas para arquiteturas ARM/x86 adiciona cerca de 3 a 5 MB ao APK final. *(Mitigação: Compilação segmentada por ABI via `split-per-abi` no build de release).*
* **Não suporta Web nativa da mesma forma que SQLite/WASM:** *(Mitigação: O foco prioritário do app do Econopreço é Android e iOS nativos).*

---

## ⚠️ Desafio de Engenharia Resolvido: Reconciliação de Grafos Aninhados (Deep Upsert)

### O Problema do Grafo de Entidades Aninhadas
O modelo de dados do Econopreço possui estruturas profundamente aninhadas, por exemplo:
`Market -> Products -> Price -> Location`.

No ObjectBox, a inserção inicial (`insert`) resolve os nós filhos em cascata automaticamente. Porém, na operação de **atualização (update / upsert)**, invocar `marketBox.put(market)` de forma direta não reconcilia adequadamente os nós filhos existentes:
1. Pode gerar duplicações de registros filhos se os IDs não forem rigorosamente rastreados.
2. Pode sobrescrever parcialmente dados ou romper referências de `ToOne` e `ToMany`.

### A Solução Customizada Implementada
Em vez de recorrer a soluções destrutivas (como recriar coleções inteiras), foi desenvolvido um pipeline transacional customizado de **Desmembramento e Reconciliação em Cascata**:
1. **Desmembramento do Grafo:** A função customizada isola cada camada do grafo de objetos.
2. **Atualização Atômica das Folhas:** Os nós mais profundos (`Price`, `Location`) são atualizados individualmente em seus respectivos `Box<T>`, preservando seus IDs de chave primária.
3. **Reconciliação das Entidades Intermediárias:** O produto é atualizado com as referências já persistidas.
4. **Persistência da Raiz:** O `Market` final é persistido já com todas as referências associadas e consistentes.
5. **Garantia ACID:** Todo esse ciclo é executado dentro de um bloco atômico `store.runInTx()`, assegurando que, caso ocorra qualquer falha no meio do grafo, nenhum dado inconsistente permaneça no banco local.

> **💡 Oportunidade Open Source:** Este pipeline de deep upsert resolve uma dor recorrente da comunidade ObjectBox no Dart e possui potencial para ser abstraído e publicado como um pacote complementar no pub.dev (`objectbox_cascade_upsert`).

