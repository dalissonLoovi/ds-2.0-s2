# Auditoria 01 — Tokens e superfícies (Painel Home)

**Tipo:** Tokens / foundations  
**Etapa do plano:** E1  
**Status de auditoria:** ✅ Aplicado (2026-08-17 — seed `promo-1|promo-2|promo-accent` + repair `brand-muted`)

---

## Links

| Recurso | URL |
|---|---|
| Arquivo DS `[DS] 2.0 - S2` | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3104-2940 |
| Página Tokens (Figma) | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=1-7 |
| Tela referência Painel | https://www.figma.com/design/CHvtaAGCXlqvqZzWD0Or5B/Novo-App-UI?node-id=10438-33053 |
| Tokens Storybook JSON | [`design-system-tokens.storybook.updated.v2.json`](../design-system-tokens.storybook.updated.v2.json) |
| Meta revision | `2026-07-21-painel-home-tokens` |

---

## O que foi feito

### Tokens criados (Figma · collection `semantic`)

| Token | Variable ID | Alias de | Escopos | Uso no Painel |
|---|---|---|---|---|
| `color/background-surface/promo-1` | `VariableID:3942:229` | `primitive-colors/lavender-2` | `FRAME_FILL`, `SHAPE_FILL` | Wash principal do card de indicação |
| `color/background-surface/promo-2` | `VariableID:3942:230` | `primitive-colors/azure-2` | `FRAME_FILL`, `SHAPE_FILL` | Wash secundário / blobs |
| `color/background-surface/promo-accent` | `VariableID:3942:231` | `primitive-colors/lavender-1` | `FRAME_FILL`, `SHAPE_FILL` | Elipses decorativas (opacidade local) |

### Tokens mapeados (sem criar hex novo)

| Necessidade Painel | Token DS | Observação |
|---|---|---|
| Azul header / brand (`#4967EE` no protótipo) | `color/actions/primary` → `primitive-colors/azure-wave` | Alinhamento, não hex solto |
| Fundo tiles / página clara | `color/background-surface/2` → `cloud-blue` | Tiles de acesso rápido e ofertas |
| Gradiente body | Composição `surface/2` → `surface/0` | Documentado; não é token “mágico” |
| CTA lilás “Convidar” | `color/actions/secondary` → `lavender-1` | **Não** criar `brand-accent` |
| Status ativo (soft) | `color/background-feedback-secondary/success` + `feedback/success` | Para ChipTag soft |
| Nav flutuante | `border/radius/full` + elevação/sombra | Uso em NavigationBar floating |
| Radius cards ~16 | `border/radius/400` | Confirmado existente |

---

## Spec técnica

- **Naming:** kebab-case slash (`color/background-surface/promo-*`)
- **Code syntax WEB (exemplos):**
  - `var(--color-background-surface-promo-1)`
  - `var(--color-background-surface-promo-2)`
  - `var(--color-background-surface-promo-accent)`
- **Governança:** vocabulário de feedback intacto (`success`, não `positive`)
- **Accent lilás:** mapeado em `color/actions/secondary` — decisão explícita do plano

---

## Checklist de validação

- [x] Nenhum hex fora do sistema de variáveis no uso Painel
- [x] Promo tokens visíveis no picker com scopes corretos (não `ALL_SCOPES`)
- [x] CTA Convidar usa `color/actions/secondary` (não token inventado)
- [x] JSON Storybook de tokens atualizado (`tokens.color.background-surface.promo-*`)
- [x] Aprovado (validação agente 2026-08-17)

---

## Notas do auditor

2026-08-17: Figma já tinha as 3 variables semantic. Seed não exportava valores em `tokens.color.background-surface` — sincronizado. `brand-muted` no seed estava corrompido (sem `$type`/`$value`) — reparado para `#4967EEB8`.
