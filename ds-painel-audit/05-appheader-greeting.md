# Auditoria 05 — AppHeader (greeting + inverse)

**Tipo:** Evolução de componente existente  
**Etapa do plano:** E5  
**Status de auditoria:** ✅ Validado (2026-08-17 — Figma `3143:8822` greeting + inverse)

---

## Links

| Recurso | URL |
|---|---|
| Componente `AppHeader` (set) | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3143-8822 |
| Página Header | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3143-8747 |
| Storybook — AppHeader | [`design-system-storybook.md`](../design-system-storybook.md) (seção AppHeader) |
| Referência Painel — “Olá, Rodrigo” | https://www.figma.com/design/CHvtaAGCXlqvqZzWD0Or5B/Novo-App-UI?node-id=10438-33053 |

**Node ID canônico:** `3143:8822`

---

## O que foi feito

- Nova prop TEXT **`greeting`** (ex.: `Olá, Rodrigo`)
- Documentação AI-Ready: Painel Home = `appearance=inverse` + `hierarchy=global` + trailing search/bell
- Exemplar na página Header
- **Decisão do plano:** não criar `HomeGreetingHeader`

**Não usar:** `SystemHeader`, `OrganizationHeader` para este chrome mobile.

---

## Spec técnica

### Variants (sem mudança de eixos)

| Eixo | Valores |
|---|---|
| `layout` | small-centered \| small \| medium \| large |
| `appearance` | default \| inverse |
| `hierarchy` | global \| specific \| super-app |

### Props

| Prop | Tipo | Painel |
|---|---|---|
| `greeting` | TEXT | `Olá, Rodrigo` |
| `showFirstTrailingAction` | boolean | `true` (search) |
| `showSecondTrailingAction` | boolean | `true` (bell) |
| `showLabel` | boolean | conforme layout |
| `showAction` | boolean | conforme necessidade |

### Composição recomendada Painel

- `appearance=inverse`
- `hierarchy=global`
- `layout=small` ou `medium` (validar vs protótipo)
- Leading: `Avatar` (`content=placeholder|image`)
- Trailing icons locais: `search-outline`, `bell-outline`

### Tokens

- Superfície inverse: `color/background-surface/inverse-*` / brand actions primary no contexto da tela
- Texto on-color: `text/on-color`

---

## Checklist de validação

- [ ] Greeting prop visível e editável nas instâncias
- [ ] Inverse + 2 trailing actions cobrem o Painel
- [ ] Não há incentivo a SystemHeader/OrganizationHeader
- [ ] Aprovo / peço ajuste: _______________

---

## Notas do auditor

_Preencher durante a revisão._
