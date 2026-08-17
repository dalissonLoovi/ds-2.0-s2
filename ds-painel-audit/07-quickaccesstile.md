# Auditoria 07 — QuickAccessTile (novo)

**Tipo:** Novo componente  
**Etapa do plano:** E7  
**Status de auditoria:** ✅ Validado (2026-08-17 — Figma+seed `4203:447`)

---

## Links

| Recurso | URL |
|---|---|
| Componente `QuickAccessTile` | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=4203-447 |
| Página Card (onde foi criado) | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3670-10786 |
| Storybook — QuickAccessTile | [`design-system-storybook.md`](../design-system-storybook.md) |
| Referência Painel — Acesso rápido | https://www.figma.com/design/CHvtaAGCXlqvqZzWD0Or5B/Novo-App-UI?node-id=10438-33053 |

**Node ID canônico:** `4203:447`

---

## O que foi feito

- Component set `QuickAccessTile`
- Variants: `state=default|pressed|disabled`
- Prop TEXT `label`
- Anatomia: ícone 24 + label (até 2 linhas), ~80×88
- Grupo “Acesso rápido” documentado como **composição de tela** (não set separado)
- Exemplar com 4 tiles do Painel

---

## Spec técnica

### Variants

| Eixo | Valores |
|---|---|
| `state` | default \| pressed \| disabled |

### Props

| Prop | Tipo | Default / exemplo |
|---|---|---|
| `label` | TEXT | `Pagar fatura` |
| `icon` | (INSTANCE_SWAP — evoluir se ainda placeholder) | ícones locais DS |
| `onPress` | runtime | doc React |

### Tokens

- `color/background-surface/2`
- `border/radius/400`
- `color/actions/primary` (ícone)
- `text/primary`
- Tipografia ~10/14 Medium

### Exemplares Painel

1. Pagar fatura  
2. Antecipar Parcela  
3. Meu Seguro  
4. Assistência 24hs  

### Não é

Button, Chip, Card de marketing, NavigationBarItem.

---

## Checklist de validação

- [ ] Dimensão/radius próximos do Painel (~80×88, radius 16)
- [ ] Estados pressed/disabled claros
- [ ] Ícones: placeholder aceitável ou falta INSTANCE_SWAP real?
- [ ] Grupo não virou componente indevido
- [ ] Aprovo / peço ajuste: _______________

---

## Notas do auditor

_Preencher durante a revisão._
