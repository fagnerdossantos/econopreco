# ADR 0002: Gerenciamento de Estado com BLoC e Event-Driven Architecture

* **Status:** Aceito
* **Data:** 2026-09-02
* **Decisores:** Time Mobile / Engenharia

## Contexto e Declaração do Problema
O aplicativo do Econopreço lida com múltiplos fluxos concorrentes e assíncronos:
* Emissão sucessiva de códigos EAN lidos pelo sensor de câmera.
* Atualização de listas colaborativas sincronizadas em tempo real.
* Filtros de busca de produtos com debounce enquanto o usuário digita.
* Estados de carrinho e totalização de cesta com diferentes combinações de supermercados.

A arquitetura necessita de um padrão de gerenciamento de estado previsível, auditável, livre de mutações diretas no ciclo de vida dos widgets e que permita testes automatizados unitários isolados de qualquer dependência visual.

## Opções Consideradas
1. **`flutter_bloc`:** Arquitetura orientada a eventos e transições de estado imutáveis baseadas em streams.
2. **`riverpod`:** Solução moderna e reativa com injeção embutida, porém com menor presença histórica em grandes sistemas corporativos legados.
3. **`provider` / `ChangeNotifier`:** Solução oficial básica, mas propensa a acoplamento excessivo e mutabilidade indevida em fluxos de negócio densos.
4. **`getx`:** Descartado por violar princípios fundamentais de inversão de dependência e ofuscar o contexto de build do Flutter.

## Decisão Escolhida
Optou-se pelo **`flutter_bloc`**.

### Consequências e Trade-offs

#### Pontos Positivos (Prós):
* **Rastreabilidade e Previsibilidade Estrita:** Toda mutação de estado é resultado exclusivo de um evento disparado (`Event -> BLoC -> State`). O uso de `BlocObserver` permite interceptar e logar todas as transições da aplicação.
* **Testabilidade de Excelência:** O pacote `bloc_test` permite validar entradas de eventos e saídas de estados com syntax declarativa e desacoplada de UI.
* **Padrão da Indústria:** É o padrão corporativo mais exigido em testes técnicos de empresas de tecnologia de grande porte no Brasil e no exterior.

#### Pontos Negativos (Contras e Mitigações):
* **Verbosidade (Boilerplate):** Necessidade de declarar classes separadas para Events e States. *(Mitigação: Adoção de `sealed classes` do Dart 3, permitindo pattern matching exaustivo no `switch` de estados e redução drástica de boilerplate).*
