# Auditoria 08 — VehicleSummaryCard (novo)

**Tipo:** Novo componente  
**Etapa do plano:** E8  
**Status de auditoria:** ✅ Validado (2026-08-17 — live set `4581:1451`; audit id legado `3942:25249` inexistente)

---

## Links

| Recurso | URL |
|---|---|
| Componente `VehicleSummaryCard` | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3942-25249 |
| Página Card | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3670-10786 |
| Dependência `ChipTag` soft | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3653-23220 |
| Storybook — VehicleSummaryCard | [`design-system-storybook.md`](../design-system-storybook.md) |
| Referência Painel — Chevrolet Agile / FIT8744 | https://www.figma.com/design/CHvtaAGCXlqvqZzWD0Or5B/Novo-App-UI?node-id=10438-33053 |

**Node ID canônico:** `4581:1451`

---

## O que foi feito

- Component set `VehicleSummaryCard`
- Variants: `status=active|inactive`
- Props: `brandModel`, `plate`, `coverages`
- Nested `ChipTag` soft para status (“Ativo” / “Inativo”)
- Anatomia: ícone veículo + nome + status + placa + coberturas
- Card clicável (comportamento documentado)

**Dependências:** tokens E1 + ChipTag soft (E2)

---

## Spec técnica

### Variants

| Eixo | Valores |
|---|---|
| `status` | active \| inactive |

### Props

| Prop | Tipo | Exemplo Painel |
|---|---|---|
| `brandModel` | TEXT | `Chevrolet Agile` |
| `plate` | TEXT | `FIT8744` |
| `coverages` | TEXT | `Furto e roubo + Colisão + Vidros` |
| `vehicleIcon` | asset / swap | ícone carro local |
| `onPress` | runtime | detalhe do veículo |

### Tokens

- `color/background-surface/0`
- `border/radius/400`
- elevação (drop shadow)
- Nested ChipTag soft (`background-feedback-secondary/success`)

### Não é

Card genérico, OfferProductCard, ListItem.

---

## Checklist de validação

- [ ] Match visual vs card Agile / Ativo / FIT8744
- [ ] ChipTag soft correto (não Badge)
- [ ] Inactive coerente
- [ ] A11y: card como link/button + status exposto
- [ ] Aprovo / peço ajuste: _______________

---

## Notas do auditor

_Preencher durante a revisão._
