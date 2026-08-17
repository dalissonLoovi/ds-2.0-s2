# Auditoria 02 — ChipTag (emphasis soft)

**Tipo:** Evolução de componente existente  
**Etapa do plano:** E2  
**Status de auditoria:** ✅ Validado (2026-08-17 — Figma `3653:23220` + seed `emphasis` soft)

---

## Links

| Recurso | URL |
|---|---|
| Componente `ChipTag` (set) | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3653-23220 |
| Página Chip | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3242-5614 |
| Storybook — ChipTag | [`design-system-storybook.md`](../design-system-storybook.md) (seção ChipTag) |
| Referência visual no Painel | Status “Ativo” no card do veículo — https://www.figma.com/design/CHvtaAGCXlqvqZzWD0Or5B/Novo-App-UI?node-id=10438-33053 |

**Node ID canônico:** `3653:23220`

---

## O que foi feito

- Nova variante **`emphasis`:** `strong` | `soft`
- Variantes existentes renomeadas para `emphasis=strong`
- Matriz **soft** intencionalmente esparsa: `intent=success` + `state=default` (sm/md × hug/fill)
- Soft fill: `color/background-feedback-secondary/success`
- Exemplar de uso Painel: label **Ativo** + `showLeadingIcon=true`

**Não é:** Badge, botão, ChipClickable.

---

## Spec técnica

### Variants

| Eixo | Valores |
|---|---|
| `size` | `sm` \| `md` |
| `intent` | `info` \| `system` \| `success` \| `warning` \| `danger` \| `outline` |
| `width` | `hug` \| `fill` |
| `state` | `default` \| `disabled` |
| `emphasis` | `strong` \| `soft` |

### Props

| Prop | Tipo |
|---|---|
| `label` | TEXT |
| `showLeadingIcon` | boolean |
| `leadingIcon` | INSTANCE_SWAP |
| `showAvatar` | boolean |
| `size` / `intent` / `width` / `state` / `emphasis` | variants |

### Tokens

- strong → `color/background-feedback-primary/{intent}`
- soft → `color/background-feedback-secondary/{intent}`
- indicador → `feedback/success` (quando aplicável)
- `border/radius/full`

### Uso Painel recomendado

`size=sm` · `intent=success` · `emphasis=soft` · `width=hug` · `showLeadingIcon=true` · `label="Ativo"`

---

## Checklist de validação

- [ ] Soft ≠ fill saturado de strong
- [ ] Não confundir com Badge
- [ ] Chip continua não interativo
- [ ] Docs Storybook com `emphasis`
- [ ] Aprovo / peço ajuste: _______________

---

## Notas do auditor

_Preencher durante a revisão._
