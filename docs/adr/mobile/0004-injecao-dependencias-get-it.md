# ADR 0004: Injeção de Dependências e Desacoplamento com GetIt

* **Status:** Aceito
* **Data:** 2026-09-02
* **Decisores:** Time Mobile / Engenharia

## Contexto e Declaração do Problema
Seguindo os princípios da Clean Architecture (Dependency Inversion Principle - DIP), a camada de apresentação (BLoCs e Widgets) e a camada de domínio (UseCases) não devem conhecer implementações concretas da infraestrutura (como `DioClient` ou `ObjectBoxStore`).

Precisamos de uma solução de Service Locator / Injeção de Dependências que permita:
1. Registro desacoplado de dependências em módulos ou arquivos centrais (`injection_container.dart`).
2. Facilidade de substituição de dependências reais por mocks em testes unitários (`mocktail`).
3. Controle fino de ciclo de vida (Singletons para conexões persistentes vs Factories para BLoCs e UseCases transientes).

## Opções Consideradas
1. **`get_it`:** Service locator em Dart puro, rápido, leve e independente do widget tree.
2. **`provider`:** Injeção amarrada ao `BuildContext` do Flutter.
3. **`injectable`:** Camada de geração de código sobre o `get_it`.

## Decisão Escolhida
Optou-se pelo **`get_it`** (com registro manual ou auxiliado por anotações).

### Consequências e Trade-offs

#### Pontos Positivos (Prós):
* **Independente do Context:** Permite resolver dependências fora da árvore de widgets (em workers de background ou isolados).
* **Alta Performance:** Resolução O(1) de instâncias em memória via hash table interna.
* **Testes Limpos:** Permite invocar `getIt.reset()` antes de cada bateria de testes, garantindo isolamento total entre suítes.

#### Pontos Negativos (Contras e Mitigações):
* **Erros em Runtime se Esquecer de Registrar:** Chamar `getIt<T>()` para um tipo não registrado lança exceção em tempo de execução. *(Mitigação: Baterias de testes de inicialização que validam o container de injeção no CI/CD).*
