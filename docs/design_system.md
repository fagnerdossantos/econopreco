# Sistema de Design — Econopreço

![Versão](https://img.shields.io/badge/vers%C3%A3o-v1.0.0-blue?style=flat-square) ![Status](https://img.shields.io/badge/status-ativo-orange?style=flat-square)

> Especificação canônica de **tipografia, fontes, espaçamento e cor** do app
> mobile. Todo texto novo na interface **deve** consumir os tokens descritos
> aqui — nunca valores soltos (ex.: `fontSize: 17`, `padding: EdgeInsets.all(13)`).
> A implementação vive em `lib/app/theme/`.

---

## 1. Princípios

1. **Fonte única da verdade.** Estilos vêm do `ThemeData`, nunca hardcoded no widget.
2. **Material 3.** Papéis de tipografia (`display/headline/title/body/label`) e `ColorScheme.fromSeed`.
3. **Acessibilidade por padrão.** Tamanhos derivam do `TextScaler` do sistema, então o texto escala com a configuração de fonte do aparelho.
4. **Offline.** Fontes são `.ttf` locais empacotados — sem busca em tempo de execução.
5. **Consistência de grid.** Espaçamentos são múltiplos de 4.

---

## 2. Fonte

- **Família:** **Inter** (weights estáticos `.ttf`).
- **Carregamento:** assets locais declarados em `pubspec.yaml → flutter: fonts`. Sem dependência do `google_fonts`.
- **Arquivos** (em `assets/fonts/`):

| Arquivo | Weight |
|---|---|
| `Inter-Regular.ttf` | 400 |
| `Inter-Medium.ttf` | 500 |
| `Inter-SemiBold.ttf` | 600 |
| `Inter-Bold.ttf` | 700 |

- **Constante:** `AppFonts.inter` (`lib/app/theme/app_fonts.dart`). O valor string (`'Inter'`) deve bater com o `family:` do `pubspec.yaml`.
- **Adicionar um novo weight:** coloque o `.ttf` em `assets/fonts/`, declare no `pubspec.yaml` com o `weight:` correto. Só então o peso pode ser usado no tema.

---

## 3. Tipografia

Gerada por `buildAppTextTheme(brightness:)` (`lib/app/theme/app_typography.dart`) a partir das **medidas padrão Material 3** (assim o `TextScaler` escala de forma previsível), aplicando a família Inter **diretamente em cada papel**.

> ⚠️ **Não use `.apply(fontFamily:)` em cadeia com `.copyWith(...)`.** A tipografia
> `material2021` já embute `fontFamily: 'Roboto'` em cada papel; um `.copyWith` que
> referencie o `base` sobrepõe o `.apply` e derruba para Roboto. Por isso o family é
> definido dentro de `role()` em cada estilo.

### Tabela de papéis e pesos

| Papel | Tamanho base (px) | Peso | Uso típico |
|---|---|---|---|
| `displayLarge` | 57 | 700 | — (raro) |
| `displayMedium` | 45 | 700 | — |
| `displaySmall` | 36 | 600 | — |
| `headlineLarge` | 32 | 600 | Títulos de seção |
| `headlineMedium` | 28 | 600 | Títulos de página |
| `headlineSmall` | 24 | 600 | Cabeçalhos |
| `titleLarge` | 22 | 600 | Título de card/APP BAR |
| `titleMedium` | 16 | 500 | Subtítulo |
| `titleSmall` | 14 | 500 | Rótulos de seção |
| `bodyLarge` | 16 | 400 | Texto corrido destacado |
| `bodyMedium` | 14 | 400 | Texto padrão |
| `bodySmall` | 12 | 400 | Texto auxiliar / legenda |
| `labelLarge` | 14 | 500 | Botões |
| `labelMedium` | 12 | 500 | Chips / tags |
| `labelSmall` | 11 | 500 | Metadados |

### Como usar

```dart
final theme = Theme.of(context);
Text('Título', style: theme.textTheme.headlineSmall);
Text('Descrição', style: theme.textTheme.bodyMedium);
```

---

## 4. Espaçamento

Tokens em `AppSpacing` (`lib/app/theme/app_spacing.dart`), **base de 4pt**, expostos como `ThemeExtension`:

| Token | Valor | Uso típico |
|---|---|---|
| `xs` | 4 | Entre ícone e label, gap fino |
| `sm` | 8 | Entre itens relacionados |
| `md` | 12 | Padding interno de card |
| `lg` | 16 | Padding de tela / entre blocos |
| `xl` | 24 | Separação de seções |
| `xxl` | 32 | respiros grandes / hero |

### Como usar

```dart
final spacing = Theme.of(context).extension<AppSpacing>() ?? AppSpacing.standard;

Padding(
  padding: EdgeInsets.all(spacing.lg),
  child: Column(
    children: [
      Text('A', style: theme.textTheme.titleMedium),
      SizedBox(height: spacing.md),
      Text('B', style: theme.textTheme.bodyMedium),
    ],
  ),
)
```

---

## 5. Cor

- **Seed / marca:** verde — `Color(0xFF16A34A)` (economia/frescor).
- Os papéis (`primary`, `surface`, `onSurface`, etc.) são derivados automaticamente por `ColorScheme.fromSeed(seedColor: ...)`. **Não** fixe cores de texto/fundo por cima do `ColorScheme`; use `theme.colorScheme.*`.
- **Modos:** claro e escuro definidos em `AppTheme.light()` / `AppTheme.dark()` (`lib/app/theme/app_theme.dart`). O app roda em `ThemeMode.light` por padrão; trocar para `.system` quando o dark for habilitado oficialmente.

---

## 6. Configuração raiz

`AppWidget` (`lib/app_widget.dart`) conecta tudo:

```dart
MaterialApp(
  theme: AppTheme.light(),
  darkTheme: AppTheme.dark(),
  themeMode: ThemeMode.light,
  home: const HomeView(),
)
```

---

## 7. Armadilha: `material_ui`

O app é construído sobre o pacote **`material_ui`** (fork do Material do Flutter), que possui seu **próprio** `Theme`/`_InheritedTheme`.

- Leia o tema com o `Theme.of` **de `package:material_ui/material_ui.dart`** — o `Theme.of` do `package:flutter/material.dart` não enxerga esse ancestral e cai no fallback **Roboto**.
- Na dúvida sobre qual fonte está aplicada, inspecione o `RichText.text.style.fontFamily` renderizado (é o que de fato é pintado).

---

## 8. Checklist antes de abrir PR de UI

- [ ] Nenhum `fontSize`/`fontWeight` hardcoded — use `Theme.of(context).textTheme.*`.
- [ ] Nenhum valor de padding/margin solto — use os tokens de `AppSpacing`.
- [ ] Nenhuma cor fixa de texto/fundo — use `theme.colorScheme.*`.
- [ ] Nova fonte/peso declarada no `pubspec.yaml` **e** presente em `assets/fonts/`.
- [ ] `flutter analyze` limpo e `flutter test` passando (inclui `test/theme_font_test.dart`, que garante o Inter).

---

## 9. Referências

- Implementação: `lib/app/theme/` (`app_fonts.dart`, `app_typography.dart`, `app_spacing.dart`, `app_theme.dart`).
- Regressão de fonte: `test/theme_font_test.dart`.
- ADRs mobile: `docs/adr/mobile/`.
- [Material 3 — Type](https://m3.material.io/styles/typography/type-scale-tokens)
