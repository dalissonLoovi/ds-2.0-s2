# Auditoria 03 — ChipClickable (“Adicionar veículo”)

**Tipo:** Correção de uso + exemplar (sem componente novo)  
**Etapa do plano:** E3  
**Status de auditoria:** ✅ Aplicado (`intent=soft`, 2026-07-24; label tokens 2026-07-27)

---

## Links

| Recurso | URL |
|---|---|
| Componente `ChipClickable` (set) | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3653-23577 |
| Página Chip | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3242-5614 |
| Storybook — ChipClickable | [`design-system-storybook.md`](../design-system-storybook.md) (seção ChipClickable) |
| Referência no Painel (erro anterior: ChipTag) | https://www.figma.com/design/CHvtaAGCXlqvqZzWD0Or5B/Novo-App-UI?node-id=10438-33053 |

**Node ID canônico (set):** `3653:23577`  
**Node ID Storybook (legado/doc):** `3242:5845` — validar alinhamento no Figma

---

## O que foi feito

- Documentado que **“Adicionar veículo” não pode ser `ChipTag`** (não interativo)
- Exemplar na página Chip:
  - `intent=soft`
  - `size=sm`
  - `width=hug`
  - `showLeadingIcon=true` (circle-plus-outline / plus-outline)
  - `showAvatar=false`
  - `showDeleteAction=false`
  - `label="Adicionar veículo"`

---

## Spec técnica (uso recomendado)

| Prop / variant | Valor |
|---|---|
| `intent` | `soft` |
| `size` | `sm` |
| `state` | `default` (e estados hover/pressed/selected do set) |
| `width` | `hug` |
| `label` | `Adicionar veículo` |
| `showLeadingIcon` | `true` |
| `leadingIcon` | `circle-plus-outline` / `plus-outline` (ícone local DS) |
| `showAvatar` | `false` |
| `showDeleteAction` | `false` |

### Tokens (`intent=soft`)

- default: `color/background-surface/2` + `color/border/2`
- hover/pressed/selected: `interactive/hover|pressed|selected` + `color/border/2`

### A11y

- Deve receber foco e ativação (Enter/Space)
- Nome acessível = label do chip

---

## Checklist de validação

- [ ] Protótipo Painel não documenta mais CTA como ChipTag
- [ ] Exemplar sem avatar/delete
- [ ] Interação e contraste OK
- [ ] Aprovo / peço ajuste: _______________

---

## Notas do auditor

**2026-07-27 apply (re-audit):** soft `label` TEXT prop re-wired (16/16); label typography → local `body/small/medium` (cleared remotes on 116); danger unbound `itemSpacing=8` → `spacing/100`; AI-READY accent + docs rev `2026-07-27-chip-clickable-label-tokens`. Defaults `showAvatar`/`showDeleteAction` unchanged (exemplar override documented).
