# ADR 0003: Resiliência de Autenticação com Dio Interceptors, RFC 7807 e SecureStorage

* **Status:** Aceito
* **Data:** 2026-09-02
* **Decisores:** Time Mobile / Engenharia

## Contexto e Declaração do Problema
O backend do Econopreço (Axum/Rust) expõe APIs protegidas por tokens JWT de curta duração com suporte a rotação de `refresh_token`, além de padronizar mensagens de falha sob o padrão **RFC 7807 (Problem Details for HTTP APIs)**.

A aplicação mobile não pode interromper a jornada de compra do usuário deslogando-o abruptamente quando o `access_token` expirar durante uma requisição de checkout, leitura de preços ou sincronização em segundo plano.

## Decisão Escolhida
Implementar uma camada HTTP baseada no **`QueuedInterceptor` do Dio** em conjunto com o pacote **`flutter_secure_storage`**.

### Arquitetura da Solução
1. **Armazenamento Seguro:** `access_token` e `refresh_token` são gravados exclusivamente no Keystore nativo do Android e Keychain do iOS.
2. **Fila de Requisições (Queue):** Quando uma requisição recebe status `401 Unauthorized`:
   * O `QueuedInterceptor` bloqueia requisições concorrentes subsequentes para evitar "refresh token storms" (múltiplos disparos simultâneos de renovação).
   * Dispara uma chamada assíncrona ao endpoint `/api/v2/auth/refresh`.
   * Atualiza as credenciais no armazenamento seguro do aparelho.
   * Repete a requisição original com o novo cabeçalho `Authorization: Bearer <novo_token>`.
   * Libera a fila de chamadas pendentes.
3. **Tratamento Estruturado de Erros (RFC 7807):** Respostas de erro 4xx/5xx que retornam `Content-Type: application/problem+json` são mapeadas automaticamente para classes fortemente tipadas no Dart (`ProblemDetailsException`), fornecendo `type`, `title`, `status` e `detail`.

### Consequências e Trade-offs

#### Pontos Positivos (Prós):
* **Zero Fricção para o Usuário:** A renovação de sessão ocorre de forma invisível.
* **Segurança Reforçada:** Eliminação de tokens em texto plano em `SharedPreferences`.
* **Consistência de Erros:** Erros retornados pelo backend em Rust são tratados de forma previsível e amigável na UI.

#### Pontos Negativos (Contras e Mitigações):
* **Complexidade no Interceptor:** Risco de loop infinito se o endpoint de refresh falhar. *(Mitigação: Tratamento explícito para erros no próprio refresh, disparando logout forçado e limpando a sessão apenas quando o refresh_token expirar definitivamente).*
