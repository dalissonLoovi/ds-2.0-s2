# Auditoria 09 — OfferProductCard (novo)

**Tipo:** Novo componente  
**Etapa do plano:** E9  
**Status de auditoria:** ✅ Aplicado (2026-07-24)

---

## Links

| Recurso | URL |
|---|---|
| Componente `OfferProductCard` | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=4227-418 |
| Página Card | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3670-10786 |
| Nested `Button` | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3104-3723 |
| Storybook — OfferProductCard | [`design-system-storybook.md`](../design-system-storybook.md) |
| Referência Painel — Ofertas | https://www.figma.com/design/CHvtaAGCXlqvqZzWD0Or5B/Novo-App-UI?node-id=10438-33053 |

**Node ID canônico:** `4227:418`

---

## O que foi feito

- Component set `OfferProductCard`
- Variant: `state=default`
- Props: `title`, `description`, `price`, `ctaLabel`
- Anatomia: ícone + título + descrição + preço + CTA `Button` solid/md/primary
- **Carrossel horizontal = padrão de tela**, não componente DS

**Dependência:** Button (E4)

---

## Spec técnica

### Variants

| Eixo | Valores |
|---|---|
| `state` | default |

### Props

| Prop | Tipo | Exemplo Painel |
|---|---|---|
| `title` | TEXT | `App de rastreamento` |
| `description` | TEXT | texto de cobertura GPS… |
| `price` | TEXT | `R$ 14,99/mês` |
| `ctaLabel` | TEXT | `Adicionar ao plano` |
| `icon` | swap / asset | shopping-cart etc. |
| `onAdd` | runtime | adicionar ao plano |

### Tokens

- `color/background-surface/2`
- `border/radius/400`
- Nested Button → `color/actions/primary`
- `text/primary` | `text/secondary`

### Não é

VehicleSummaryCard, Banner, Card genérico, Carousel DS.

---

## Checklist de validação

- [ ] Match vs card “App de rastreamento” / CTA
- [ ] Button nested é instância do DS (não desenho solto)
- [ ] Carrossel não foi publicado como componente indevido
- [ ] Aprovo / peço ajuste: _______________

---

## Notas do auditor

_Preencher durante a revisão._
