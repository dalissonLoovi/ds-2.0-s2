# Auditoria Painel Home × DS 2.0 — Índice

> **Quando usar:** backlog de produto (`app-cliente`) — validar entregas Painel vs DS.  
> Ciclo Docs humanas W0–W6 fechado (2026-08-17). Validação desta fila: **2026-08-17**.

Use este índice para validar **uma entrega por vez**. Marque o status após revisar o documento correspondente.

**Arquivo DS:** [[DS] 2.0 - S2](https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3104-2940)  
**File key:** `mHm12Zu9tgNmaSYnooihE5`  
**Tela de referência (Painel):** [Novo App UI — Painel](https://www.figma.com/design/CHvtaAGCXlqvqZzWD0Or5B/Novo-App-UI?node-id=10438-33053)  
**Storybook seed:** [`design-system-tokens.storybook.updated.v2.json`](../design-system-tokens.storybook.updated.v2.json) · revision `2026-08-17-painel-promo-tokens-seed`

---

## Ordem de auditoria

| # | Entrega | Tipo | Documento | Status |
|---|---|---|---|---|
| 01 | Tokens e superfícies | Tokens | [01-tokens-painel-home.md](./01-tokens-painel-home.md) | ✅ Aplicado (seed promo + brand-muted, 2026-08-17) |
| 02 | ChipTag (emphasis soft) | Evolução | [02-chiptag-soft.md](./02-chiptag-soft.md) | ✅ Validado (Figma+seed) |
| 03 | ChipClickable (Adicionar veículo) | Uso / exemplar | [03-chipclickable-adicionar-veiculo.md](./03-chipclickable-adicionar-veiculo.md) | ✅ Aplicado (`intent=soft`) |
| 04 | Button (secondary + icon-only) | Evolução | [04-button-secondary-icon-only.md](./04-button-secondary-icon-only.md) | ✅ Validado (Figma+seed) |
| 05 | AppHeader (greeting + inverse) | Evolução | [05-appheader-greeting.md](./05-appheader-greeting.md) | ✅ Validado (Figma+seed) |
| 06 | NavigationBar (floating) | Evolução | [06-navigationbar-floating.md](./06-navigationbar-floating.md) | ✅ Validado (Figma+seed) |
| 07 | QuickAccessTile | Novo | [07-quickaccesstile.md](./07-quickaccesstile.md) | ✅ Validado (Figma+seed) |
| 08 | VehicleSummaryCard | Novo | [08-vehiclesummarycard.md](./08-vehiclesummarycard.md) | ✅ Validado (live `4581:1451`) |
| 09 | OfferProductCard | Novo | [09-offerproductcard.md](./09-offerproductcard.md) | ✅ Aplicado |
| 10 | ReferralDiscountCard | Novo | [10-referraldiscountcard.md](./10-referraldiscountcard.md) | ✅ Validado (live `4594:995`) |

**Resultado 2026-08-17:** único gap de seed = tokens promo (+ `brand-muted` corrompido no JSON). Componentes 02–08/10 já alinhados no Figma e no seed — sem segundo gap material nesta passagem.
