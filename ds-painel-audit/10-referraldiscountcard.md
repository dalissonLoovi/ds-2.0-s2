# Auditoria 10 — ReferralDiscountCard (novo)

**Tipo:** Novo componente  
**Etapa do plano:** E10  
**Status de auditoria:** ✅ Validado (2026-08-17 — live set `4594:995`; audit id legado `3943:24343` inexistente)

---

## Links

| Recurso | URL |
|---|---|
| Componente `ReferralDiscountCard` | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3943-24343 |
| Página Card | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3670-10786 |
| Tokens promo | ver [01-tokens-painel-home.md](./01-tokens-painel-home.md) |
| Nested Button secondary | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3104-3723 |
| Storybook — ReferralDiscountCard | [`design-system-storybook.md`](../design-system-storybook.md) |
| Referência Painel — Zere sua mensalidade | https://www.figma.com/design/CHvtaAGCXlqvqZzWD0Or5B/Novo-App-UI?node-id=10438-33053 |

**Node ID canônico:** `4594:995`

---

## O que foi feito

- Component set `ReferralDiscountCard` com **descontômetro** (10 nós)
- Variants esparsas: `referralCount=0|2|10`
- Props: `title`, `description`
- Anatomia:
  - superfície promo (`promo-1|2|accent`)
  - título + descrição
  - link “Simulador de indicação”
  - track 10 steps (completed / current / pending)
  - resumo de desconto
  - CTA **Convidar** via `Button` `intent=secondary`
- Regra de negócio: **10 indicações = 100%** (mensalidade zerada)

### Explicitamente NÃO reutilizar

- `ProgressBar`
- `StepProgressIndicator`
- `StepperPrimary` (apenas inspiração de ícones de step)

**Dependências:** tokens promo (E1), Button secondary (E4), Link (existente / texto link)

---

## Spec técnica

### Variants

| Eixo | Valores | Nota |
|---|---|---|
| `referralCount` | 0 \| 2 \| 10 | Esparso; runtime pode ser 0..10 |

### Props

| Prop | Tipo | Exemplo |
|---|---|---|
| `title` | TEXT | `Zere sua mensalidade` |
| `description` | TEXT | `Indique amigos e ganhe desconto…` |
| `referralCount` | variant / number | `2` |
| `maxReferrals` | runtime | `10` |
| `discountPercent` | runtime | `20` |
| `discountAmount` | runtime | `- R$ 40,00/ mês` |
| `interactive` | runtime | slider/simulador |
| `onInvite` / `onOpenSimulator` | runtime | CTAs |

### Tokens

- `color/background-surface/promo-1|promo-2|promo-accent`
- Track filled → `color/actions/primary`
- CTA → `color/actions/secondary` / Button secondary
- Link → `text/link` ou `color/actions/primary`

### A11y

- Expor progresso em texto (“2 de 10 indicações”, “20%”)
- Nós do track decorativos se houver equivalente textual
- CTA e link do simulador focáveis

---

## Checklist de validação

- [ ] Visual próximo do card promo do Painel
- [ ] Regra 0 / 2 / 10 coerente (10% por indicação no exemplar)
- [ ] CTA lilás = secondary (não primary)
- [ ] Não foi forçado ProgressBar/StepProgress
- [ ] Complexidade/a11y do track ok
- [ ] Aprovo / peço ajuste: _______________

---

## Notas do auditor

_Preencher durante a revisão._
