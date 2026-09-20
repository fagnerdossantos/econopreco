# Econopreco

Aplicativo mobile para comparar preços de supermercado, montar cestas e facilitar decisões de compra de forma simples e prática.

Este repositório contém o frontend open source do projeto. A infraestrutura por trás do app — incluindo a API, o normalizador de dados, o injestor e o image worker — permanece privada e não está disponível publicamente aqui.

---

## Visão geral

O Econopreco foi pensado para reduzir o esforço da compra do dia a dia. Em vez de comparar preços manualmente em vários supermercados, o usuário pode:

- encontrar produtos rapidamente
- comparar valores entre redes
- montar cestas de compra
- entender melhor o custo total da compra
- usar o app com mais fluidez mesmo em redes instáveis

A proposta é tornar a decisão de compra mais consciente e menos cansativa.

---

## O que está aberto neste repositório

Aqui fica a parte pública do projeto, incluindo:

- app mobile em Flutter
- arquitetura do frontend
- fluxos de autenticação e navegação
- interface, estado, catálogo e comparação de preços
- integrações expostas ao cliente
- documentação técnica e de produto

O que não está aqui:

- API backend
- normalizador de dados
- injestor de dados
- image worker
- coleta, transformação e enriquecimento dos dados de origem

Em resumo: esta é a parte do produto que pode ser aberta, enquanto a infraestrutura de dados e processamento continua fechada.

---

## O problema que resolve

O uso de supermercados envolve decisões repetitivas e demoradas: pesquisar ofertas, comparar itens, revisar preços, montar uma lista e escolher onde vale mais a pena comprar.

O Econopreco centraliza essa experiência em um app simples, com foco em:

- velocidade
- clareza na comparação
- economia de tempo e dinheiro
- uso confiável em contexto real de compra

---

## Stack

- Flutter + Dart
- flutter_bloc
- get_it
- dio
- objectbox
- flutter_secure_storage
- mobile_scanner

---

## Estrutura do projeto

```text
lib/
├── app/                  # tema, rotas e bootstrap da aplicação
├── core/
│   ├── network/          # cliente HTTP, interceptors e erros
│   ├── storage/          # persistência local
│   ├── errors/           # exceções e tratamento de falhas
│   └── di/               # injeção de dependências
├── features/
│   ├── auth/             # autenticação
│   ├── catalog/          # busca e catálogo
│   ├── scanner/          # leitura de código de barras
│   └── basket/           # cestas e comparação de preços
├── main.dart
└── ...
```

A arquitetura também foi documentada em ADRs para registrar decisões relevantes sobre:

- armazenamento local
- gerenciamento de estado
- autenticação
- injeção de dependências
- resiliência de integração

---

## Documentação

A visão do produto e a documentação técnica estão organizadas em `docs/`:

- [docs/visao_de_produto.md](docs/visao_de_produto.md) — visão do produto em português
- [docs/product_vision.md](docs/product_vision.md) — visão do produto em inglês
- [docs/adr](docs/adr) — registros de decisão de arquitetura

Esses arquivos ajudam a entender não só o que o app faz, mas também o porquê de certas escolhas de arquitetura e produto.

---

## Como funciona

1. O usuário pesquisa um produto ou escaneia o código de barras.
2. O app tenta resolver dados locais e, quando necessário, consulta a API.
3. Os preços são apresentados de forma clara para comparação.
4. A cesta de compra ajuda a visualizar o custo total antes da compra.

A experiência foi pensada para funcionar bem também com rede instável.

---

## Pré-requisitos

- Flutter SDK 3.3+
- Android Studio ou VS Code com Flutter configurado
- Emulador ou dispositivo físico
- Backend disponível em ambiente de execução

---

## Rodando localmente

### 1) Clonar o projeto

```bash
git clone https://github.com/seu-usuario/econopreco_mobile.git
cd econopreco_mobile
```

### 2) Instalar dependências

```bash
flutter pub get
```

### 3) Gerar código

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4) Executar a aplicação

```bash
flutter run
```

---

## Testes

```bash
flutter test
```

Cobertura:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## Status

Em desenvolvimento ativo.

---

## Licença

A definir.
