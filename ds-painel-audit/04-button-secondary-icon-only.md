# Auditoria 04 — Button (intent secondary + icon-only)

**Tipo:** Evolução de componente existente  
**Etapa do plano:** E4  
**Status de auditoria:** ✅ Validado (2026-08-17 — Figma `3104:3723` + seed `intent=secondary`)

---

## Links

| Recurso | URL |
|---|---|
| Componente `Button` (set) | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3104-3723 |
| Página Button | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3104-2940 |
| Storybook — Button | [`design-system-storybook.md`](../design-system-storybook.md) (seção Button) |
| Uso Painel — “Convidar” | https://www.figma.com/design/CHvtaAGCXlqvqZzWD0Or5B/Novo-App-UI?node-id=10438-33053 |
| Uso Painel — search/bell no header | mesmo link (topo) |

**Node ID canônico:** `3104:3723`

---

## O que foi feito

1. **`intent=secondary`** (matriz esparsa):
   - `variant=solid`, `size=md`, `disabled=false`
   - states: `default` | `hover` | `pressed` | `focus`
   - Fill bound a `color/actions/secondary` (lavender)
2. Documentado **icon-only**: `showLabel=false` + `showIcon=true` (search/bell em superfície inverse)
3. Exemplar “Convidar” na página Button

**Não quebra:** `intent=primary|success|danger` existentes.

---

## Spec técnica

### Variants (delta)

| Eixo | Antes | Depois |
|---|---|---|
| `intent` | primary \| success \| danger | + **secondary** |

### Props relevantes

| Prop | Uso Painel |
|---|---|
| `label` | `Convidar` / `Adicionar ao plano` |
| `showLabel` | `false` para icon-only no header |
| `showIcon` | `true` no icon-only |
| `Icon` | `search-outline` / `bell-outline` |
| `variant` | `solid` (Convidar secondary; ofertas primary) |
| `size` | `md` (ou `sm` conforme densidade) |

### Tokens

- secondary fill → `color/actions/secondary`
- primary CTA ofertas → `color/actions/primary`
- label on inverse / on-color conforme appearance do contexto

---

## Checklist de validação

- [ ] Secondary visual = lilás do protótipo (lavender)
- [ ] Icon-only legível sobre azul (inverse)
- [ ] Loading/disabled dos intents originais intactos
- [ ] Matriz secondary permanece esparsa (ok documentado)
- [ ] Aprovo / peço ajuste: _______________

---

## Notas do auditor

_Preencher durante a revisão._
