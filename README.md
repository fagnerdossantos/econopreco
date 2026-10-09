# Econopreço

![Flutter](https://img.shields.io/badge/Flutter-027DF7?logo=flutter&logoColor=white&style=flat-square)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white&style=flat-square)
![License](https://img.shields.io/badge/license-GPL--3.0-blue?style=flat-square)
![Status](https://img.shields.io/badge/status-in%20development-orange?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Android-green?style=flat-square)

App mobile para comparar preços de supermercado no Rio de Janeiro. Você pesquisa um
produto (ou escaneia o código de barras), vê o preço em cada rede lado a lado e monta
a cesta para saber onde compensa comprar — sem ficar abrindo site por site e baixando
encarte em PDF.

Este repositório é o **frontend** (Flutter), em código aberto. A parte de dados —
API, ingestão, normalização e processamento de imagens — é **privada** e não está aqui.

> **Estado atual:** fase inicial, ainda um esqueleto. Hoje o repositório tem o
> `main.dart`, o bootstrap do tema e uma tela `Home` de exemplo. A arquitetura descrita
> abaixo é o alvo, não o que já está pronto. Se você quer entender a *ideia* do produto,
> leia [`docs/visao_de_produto.md`](docs/visao_de_produto.md).

---

## O que tem aberto e o que não tem

Aqui (público):

- app mobile em Flutter/Dart
- tema e design system (fonte, tipografia, espaçamento, cor)
- arquitetura, fluxo de autenticação, navegação
- catálogo, comparação de preços e cesta
- documentação de produto e de arquitetura (ADRs)

Não aqui (privado):

- API backend, normalizador de dados, injetor e image worker
- coleta, tratamento e enriquecimento dos preços

Resumo: a experiência do cliente pode ser aberta; o motor de dados continua fechado.

---

## Stack

Flutter e Dart, com as bibliotecas que o projeto usa de verdade (veja `pubspec.yaml`):

- **Estado:** flutter_bloc
- **Injeção de dependência:** get_it
- **Rede:** dio
- **Banco local (offline-first):** objectbox
- **Storage seguro:** flutter_secure_storage
- **Imagem em cache:** cached_network_image
- **UI base:** material_ui
- **Modelos/geração de código:** freezed + json_serializable
- **Preview de device (debug):** device_preview

> Leitor de código de barras (`scanner`) ainda é planejado — a tela ainda não usa a
> dependência.

---

## Estrutura

O que **já existe** hoje:

```text
lib/
├── main.dart                 # bootstrap + DevicePreview (debug)
├── app_widget.dart           # MaterialApp com o tema do app
├── home_view.dart            # tela inicial (exemplo)
└── app/
    └── theme/                # fonte, tipografia, espaçamento, ThemeData
```

Para onde o projeto está indo:

```text
lib/
├── app/                      # tema, rotas e bootstrap
├── core/                     # network, storage, errors, di
└── features/                 # auth, catalog, scanner, basket
```

---

## Rodando

Pré-requisitos: **Flutter SDK 3.13+** (o projeto trava `sdk: ^3.13.1`), um editor com
Flutter (VS Code ou Android Studio) e um emulador/dispositivo — ou Chrome/desktop Linux.

```bash
# 1) clonar
git clone https://github.com/fagnerdossantos/econopreco.git
cd econopreco

# 2) dependências
flutter pub get

# 3) gerar código (ObjectBox, freezed, etc.)
dart run build_runner build --delete-conflicting-outputs

# 4) rodar
flutter run
```

> O app depende de um backend para dados reais. Sem ele, você roda a interface e os
> dados locais.

## Testes

```bash
flutter test
```

## Commits

O histórico segue o padrão `type(scope): subject`. As regras estão em
[`docs/commit-guide.md`](docs/commit-guide.md).

---

## Documentação

Tudo em `docs/`:

- [Visão de produto (PT)](docs/visao_de_produto.md)
- [Product vision (EN)](docs/product_vision.md)
- [Sistema de design](docs/design_system.md) — fonte, tipografia, espaçamento e cor
- [Guia de commits](docs/commit-guide.md)
- [ADRs](docs/adr) — decisões de arquitetura, separadas em `mobile/` e `backend/`

---

## Licença

Copyright (c) 2026 **Fagner Santos**.

Este projeto é licenciado sob a **GNU General Public License v3.0 ou versão posterior**
([`LICENSE`](LICENSE)).

Na prática, isso significa:

- **Use, estude, modifique e redistribua** — é código aberto.
- **Dê os créditos.** Ao distribuir o original ou qualquer derivação, os avisos de
  autoria/copyright devem ser preservados.
- **Não pode fechar.** Qualquer versão derivada precisa ser distribuída sob a **mesma
  licença** (GPL-3.0-or-later), com o código-fonte disponível. Quem pegar este projeto e
  mudar não pode transformá-lo em software proprietário.

Se esses termos não servem para o seu caso, fale com o autor.
