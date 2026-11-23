# Backlog DS 2.0 — Próximas etapas (humano)

**Atualizado:** 2026-11-23  
**Arquivo:** [[DS] 2.0 - S2](https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2)  
**Storybook:** https://dalissonloovi.github.io/ds-2.0-s2/  
**Seed:** `design-system-tokens.storybook.updated.v2.json` (130 componentes · 127 com React · 23 vars `product-theme`)  
**Revision recente:** `2026-09-21-link-audit-apply`

**Estado:** fundação + temas core + Docs humanas + fila Painel Home + React W0–W7 **fechados**.  
**Modo atual:** melhoria contínua (gap de produto → decisão → Figma → seed → Pages).  
**Últimos applies:** 2026-09-18 ChipTag / ChipClickable `intent=brand` + superfícies soft · 2026-09-21 Link (size, tipografia, tokens, paridade React).

---

## Visão — 3 frentes em paralelo

```mermaid
flowchart TB
  subgraph A[A Decisão de evolução]
    D1[Pedido / gap]
    D2{Reusar / Variante / Novo?}
    D3[Aplicar no Figma]
    D1 --> D2 --> D3
  end
  subgraph B[B Docs humanas no Figma]
    F1[Páginas de uso]
    F2[Do / Dont]
    F3[Anatomia + tokens]
  end
  subgraph C[C Storybook / GitHub]
    S1[JSON metadata]
    S2[docs:generate]
    S3[Commit push Pages]
  end
  D3 --> F1
  D3 --> S1
  S1 --> S2 --> S3
```

| Frente | Para quem | Objetivo |
|---|---|---|
| **A — Fluxo de melhoria** | Designers / DS | Decidir reusar, variante ou componente novo sem inflar o DS |
| **B — Documentação visual Figma** | Humanos (produto + design) | Usar o DS sem depender só de AI-Ready |
| **C — Storybook / GitHub** | Time + agentes | Catálogo publicado, changelog, sync com Figma |

---

## Frente A — Fluxo de melhoria do DS (decisão)

Usar **sempre** que surgir pedido de tela/produto ou gap.

### Árvore de decisão

1. **Já existe componente que resolve o caso?**  
   → **Reusar** (instância + props). Preferir composition a fork.
2. **É o mesmo papel, só muda look/estado/densidade/layout?**  
   → **Variante** (`variant` / `size` / `appearance` / `emphasis` / `layout`…) **ou** token `product-theme` se for diferença **por produto**.  
   Não criar segundo master.
3. **É papel novo (anatomia/comportamento diferente) e não cabe em props?**  
   → **Componente novo** (foundation) **ou** padrão de produto (`*Card`, tile, etc.) com nome claro.
4. **É só layout de tela?**  
   → **Não** vira componente DS; documentar como composição de tela.

### Checklist antes de criar variante / novo

- [ ] Nome kebab-case; subcomponente → sufixo `Item` (não `Block`)
- [ ] Tokens locais S2; sem hex solto relevante
- [ ] Descrição `AI-READY COMPONENT:` (EN)
- [ ] Props TEXT/BOOLEAN/INSTANCE_SWAP claros
- [ ] Feedback vocab: `info|system|success|warning|danger`
- [ ] Decisão registrada: reuso / variante / novo / composição

### Quando pedir ajuda ao orientador

> Pedido: [descrição do gap]  
> Opções que considerei: reusar X / variante em Y / novo Z  
> Links Figma: […]  
> Pergunta: qual caminho e por quê?

Página Figma: [Como evoluir o DS](https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=4807-72)

---

## Frente B — Documentação visual no Figma (humano)

Objetivo: páginas **para pessoas** (não só metadata AI).

### Por componente (mínimo)

| Bloco | Conteúdo |
|---|---|
| **Overview** | Quando usar / quando não usar |
| **Anatomy** | Camadas nomeadas + slots |
| **Variants** | Matrix visual kebab-case |
| **Content** | Props de texto/ícone com exemplos reais |
| **Tokens** | Binds principais (e `product-theme` se houver) |
| **Do / Don’t** | 2–4 exemplos |
| **A11y** | Nome acessível, foco, estados |

### Por família / produto

- Página **“Como evoluir o DS”** — ✅ (`node-id=4807-72`)
- ~~Docs humanas W0–W6~~ ✅ — [`DS-HUMAN-DOCS-REGISTRY.md`](./DS-HUMAN-DOCS-REGISTRY.md)
- ~~Auditoria W0–W6 + orphans W4~~ ✅ (2026-08-17)
- **Próximo (opcional):** página **App-cliente / Painel** com composições oficiais (só instâncias)
- Página **Temas** (quando necessário): trocar mode, não fork

### Ondas Docs humanas

| Onda | Status | Qtd |
|---|---|---|
| W0 Core | ✅ | 7 (+ governança) |
| W1 Formulários | ✅ | 15 |
| W2 Feedback | ✅ | 8 |
| W3 Nav/headers | ✅ | 14 |
| W4 Dados | ✅ | 11 |
| W5 Cards app | ✅ | 11 |
| W6 Complexos | ✅ | 9 |

`*Item` / `*Block`: sem página própria (só Anatomy do pai).

---

## Frente C — Storybook / GitHub

### Fluxo canônico (já em uso)

```text
Figma (ajuste)
 → design-system-tokens.storybook.updated.v2.json
 → cd storybook && npm run docs:generate
 → commit + push main
 → GitHub Pages
```

### Melhorias do catálogo

| Prioridade | Item | Notas |
|---|---|---|
| P0 | Manter sync por fatia | JSON + MDX + push após cada fechamento |
| P1 | Foundations no Storybook | Global rules, feedback, product-theme (já parcial) |
| P1 | Introduction / Changelog legíveis | ✅ Copy humana (2026-08-17); hoje Autodocs 127/130; changelog truncado |
| P2 | Chromatic | Só se o time pedir review visual |
| P2 | React + CSF3 | Por componente; Autodocs substitui seed daquele item |
| P3 | Code Connect | Depois do React estabilizar |

### Definition of Done (fatia)

- [ ] Figma aplicado  
- [ ] JSON (`description`, props, rules, changelog, recentUpdates)  
- [ ] `npm run docs:generate`  
- [ ] Commit/push `main`  
- [ ] (Ideal) bloco visual no Figma atualizado na Frente B

---

## Status — o que já fechou vs o que falta

| Item | Status |
|---|---|
| Fundação + catálogo seed (130) | 🟢 Avançado |
| `product-theme` core (23 vars) | 🟢 Feito no Figma/seed |
| `product-theme` em código (tokens por mode + React) | ⬜ Não feito — React emite só o visual Escritório Virtual |
| Fluxo decisão Reusar/Variante/Novo | 🟢 Página Figma publicada |
| Docs visuais Figma (humanas) W0–W6 | 🟢 Completo + auditadas |
| Orphans W4 (DividerHorizontal / PaginationItem) | 🟢 Removidos após rewire |
| Painel Home audit queue | 🟢 Validada — [`ds-painel-audit/`](./ds-painel-audit/00-INDICE-AUDITORIA.md); promo tokens no seed |
| Limpeza untracked legado | 🟢 Feita (scripts/patches/JSON legado); audit versionado |
| Storybook Pages sync | 🟢 Operacional |
| Página composições App-cliente / Painel | ⬜ Opcional |
| React `@ds/react` + CSF3 Autodocs | 🟢 W0–**W7** polish (2026-08-17); hoje 127/130 (sem React: CommentItem, BrandLogo, PaymentMethodMark) |
| Code Connect (W0–W7) | 🟢 `*.figma.tsx` no piloto + ondas |
| Introduction / Changelog copy | 🟢 Polish 2026-08-17 — gerador, não MDX à mão |
| Tipografia Poppins no React/Storybook | 🟢 P1 2026-08-18 — `--font-family-base` + woff2; escala px→token ainda P2 |
| Chromatic / npm público | ⬜ Depois (pedido explícito) |

---

## Próximos passos (ordem recomendada)

1. ~~Publicar “Como evoluir o DS”~~ ✅  
2. ~~Docs humanas W0–W6~~ ✅  
3. ~~Auditar frames Docs humanas~~ ✅  
4. ~~Limpar orphans W4~~ ✅  
5. ~~Validar fila Painel Home + sync promo tokens~~ ✅  
6. ~~Limpar untracked legado~~ ✅  
7. ~~React foundation + W0 Autodocs/Code Connect~~ ✅ — ver [`REACT-CONTRIBUTING.md`](./REACT-CONTRIBUTING.md)  
8. ~~React leftovers draft~~ ✅ W7 (ChipGroup, ImageItem/PhotoTextItem, PaginationSelect*, TableSkeleton, ModalHeader/ModalCheckItem)  
   - ~~W1 Formulários~~ ✅ React DoD (2026-08-17)
   - ~~W2 Feedback~~ ✅ React DoD (2026-08-17)
   - ~~W3 Nav/headers~~ ✅ React DoD (2026-08-17)
   - ~~W4 Dados & display~~ ✅ React DoD (2026-08-17)
   - ~~W5 Cards & app-cliente~~ ✅ React DoD (2026-08-17)
   - ~~W6 Complexos~~ ✅ React DoD (2026-08-17)
   - ~~W7 Internals & leftovers~~ ✅ React DoD (2026-08-17)
9. **Opcional:** página Figma de composições App-cliente / Painel  
10. ~~Polish copy Introduction / Changelog~~ ✅ (2026-08-17) — gerador; Autodocs 123/124; CommentItem seed  
11. **Só quando o time pedir:** Chromatic / publish npm
12. **Gaps para o Site Loovi** (cada um passa por auditar → reportar → `aplicar`):
    - `product-theme` em código: gerador de tokens emite modes (`escritorio-virtual` | `site-loovi` | `app-cliente`) + React consome `--component-*` + toolbar de produto no Storybook
    - Breakpoints do seed (`xxs 0 · xs 360 · sm 700 · md 834 · lg 1152 · xl 1280`) em `tokens.css` + grid / container / colunas
    - Biblioteca de ícones do `site-loovi` (contrato `*-outline` / `*-filled`)
    - Escala tipográfica de marketing (> 40px) e tipografia responsiva
    - Componentes de site (header de marketing, footer, hero, cards de plano, depoimento, cotação): decidir reusar / variante / novo / composição
    - Forma de consumo dos pacotes (git, GitHub Packages ou monorepo)
13. React para CommentItem, BrandLogo e PaymentMethodMark (quando pedido)
14. **Saída Flutter (App Cliente)** — onda 1 entregue em 2026-11-23 (`loovi_tokens` + `loovi_ds`, 21 componentes; ver [`FLUTTER-CONTRIBUTING.md`](./FLUTTER-CONTRIBUTING.md) e [`FLUTTER-INVENTORY.md`](./FLUTTER-INVENTORY.md)). Próxima onda só quando pedida.

### Achados da auditoria Flutter (2026-11-23)

**Aplicado em 2026-11-23** (revision `2026-11-23-flutter-audit-seed-sync`):
- Seed ← Figma: `interactive/selected` #D0D9E8, `color/overlay/overlay` 48%, `feedback/info` (#54DEF8) adicionado, `color/elevation/focus` adicionado (`pressed` deprecated).
- `tokens.component` completo (23/23); `app-header/leading-action/background` [escritorio-virtual] → #FCFCFE.
- nodeIds: Switch → `3653:4741`, NavigationBarItem → `3653:15180` (seed + Code Connect).
- Impacto: CSS/React (Escritório Virtual) — selected fica azulado e o overlay mais claro; Flutter regenerado; Storybook regenerado.

**Pendente — decisão de design (não sincronizado de propósito)**

| Variável | Figma | Seed (mantido) | Motivo |
| --- | --- | --- | --- |
| `feedback/success` | #2DBE5E | #00723E | Figma falha AA como texto |
| `feedback/danger` | #F54444 | #D83E3E | idem |
| `feedback/warning` | #FFB74C | #8C7502 | idem |

Proposta: separar cor de ícone/indicador (clara) de cor de texto (AA) antes de sincronizar.

**Ícones App Cliente** — auditoria completa em [`ds-icons-audit/2026-11-23-app-cliente-aliases.md`](./ds-icons-audit/2026-11-23-app-cliente-aliases.md): 605 `*-filled` sem preenchimento, 7 seta×chevron trocados, 3 traços fora do contrato, 2 nomes inválidos. Correção no Figma aguarda `aplicar`. Faltam ainda `player-play-outline` e `player-record-filled` no pacote Flutter.

**Figma — componentes (reportado)**
- RadioButton disabled on × off idênticos (3653:5321 / 3653:5304) — P1 a11y visual.
- AppHeader specific: ações trailing sobrepostas no mesmo slot de 40; large default sem SPACE_BETWEEN (3143:8856).
- ModalHeader close com `size-[40px]` cru (3786:9384, 3802:205); ChipTag md ícone 32 (3653:23235); ChipClickable sm avatar 22 (3653:23581); Alert inverse brand sem variável (4406:31).
- Frames sem variável (gaps 4/8/10, alturas 36/56/64/160) — detalhe nos relatórios da onda.

**Exceções mantidas no Flutter (fora do seed, decisão 2026-11-23)**
- `LooviAlert` com ação de fechar (desligada por padrão) e `LooviModal` com `footer` (existe no React). Oficializar no Figma/seed ou remover numa próxima onda.

**Propostas de componente**
- `LooviButton` appearance `inverse` (Alert inverse usa recolor provisório).
- LoadingSpinner Flutter (hoje interno ao Button).

---

## Papel do agente

- Orientar decisão (reusar / variante / novo)  
- Auditar / mapear tokens quando pedido  
- Sync docs JSON → Storybook → commit/push quando você pedir  
- **Não** aplicar Figma sem `aplicar` explícito
