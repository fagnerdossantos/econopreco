# Guia de Commits

Este projeto usa um padrão simples, legível e consistente para mensagens de commit. O objetivo é deixar o histórico do Git fácil de revisar, entender e manter.

## Padrão recomendado

Use o formato:

```bash
type(scope): subject
```

Exemplos:

```bash
feat(auth): add login flow
fix(catalog): handle empty product list
docs(readme): improve project overview
refactor(core): simplify api client setup
chore(ci): update workflow config
```

## Tipos mais comuns

- `feat`: nova funcionalidade
- `fix`: correção de bug
- `docs`: documentação
- `refactor`: reorganização sem mudança funcional
- `test`: testes
- `chore`: manutenção, setup, config, arquivos não funcionais
- `style`: formatação sem mudança de lógica
- `perf`: melhoria de performance
- `ci`: integração contínua
- `build`: mudanças de build ou dependências de compilação

## Regras práticas

- Use verbo no imperativo: `add`, `fix`, `remove`, `update`, `refactor`
- Mantenha a mensagem curta, direta e objetiva
- Evite commits genéricos como `update` ou `fixes`
- Faça commits pequenos e focados em uma mudança por vez
- Se a mudança for grande, divida em partes lógicas

## Exemplos bons

```bash
feat(scanner): add barcode scanning flow
fix(auth): handle expired session redirect
docs(readme): explain private backend architecture
refactor(di): centralize service registration
```

## Exemplos ruins

```bash
update stuff
fix bug
melhorias
ajustes finais
```

## Corpo do commit (quando necessário)

Quando a mudança exigir contexto extra, use:

```bash
feat(catalog): add price comparison filters

- add category filter
- add price range support
- update empty states in catalog screen
```

## Dicas para manter o histórico limpo

- um commit = uma mudança lógica
- não misture correção e refatoração em um mesmo commit
- não inclua arquivos gerados automaticamente sem necessidade
- revise antes de confirmar

## Regra de ouro

Se alguém olhar o log do projeto, a mensagem do commit deve responder:

- o que mudou?
- por que mudou?
- em que parte do sistema?

Isso é o que torna o histórico útil.
