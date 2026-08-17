# Backlog DS 2.0 — Próximas etapas (humano)

**Atualizado:** 2026-08-14  
**Arquivo:** [[DS] 2.0 - S2](https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2)  
**Storybook:** https://dalissonloovi.github.io/ds-2.0-s2/  
**Seed:** `design-system-tokens.storybook.updated.v2.json` (~124 componentes · 23 vars `product-theme`)

**Estado:** fundação + temas core + padrões app-cliente/Painel **já avançados**.  
**Modo atual:** melhoria contínua (não reabrir matriz de temas sem necessidade).

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

### Por família / produto (recomendado)

- Página **“Como evoluir o DS”** — ✅ criada (`node-id=4807-72`)  
  [Abrir no Figma](https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=4807-72)  
- Página **App-cliente / Painel** com composições oficiais (só instâncias)  
- Página **Temas** (quando necessário): trocar mode, não fork

### Ordem sugerida de docs Figma

1. ~~Fluxo de decisão~~ ✅  
2. ~~W0–W6 docs humanas~~ ✅ — [`DS-HUMAN-DOCS-REGISTRY.md`](./DS-HUMAN-DOCS-REGISTRY.md)  
3. **Próximo:** auditoria dos frames (tokens, props, copy, Do/Don’t) — reportar; aplicar só com confirmação  
4. *Item / *Block: sem página própria (só Anatomy do pai)

| Onda | Status | Qtd |
|---|---|---|
| W0 Core | ✅ | 7 (+ governança) |
| W1 Formulários | ✅ | 15 |
| W2 Feedback | ✅ | 8 |
| W3 Nav/headers | ✅ | 14 |
| W4 Dados | ✅ | 11 |
| W5 Cards app | ✅ | 11 |
| W6 Complexos | ✅ | 9 |

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

### Melhorias do catálogo (próximas)

| Prioridade | Item | Notas |
|---|---|---|
| P0 | Manter sync por fatia | JSON + MDX + push após cada fechamento |
| P1 | Foundations no Storybook | Global rules, feedback, product-theme (já parcial) |
| P1 | Introduction / Changelog legíveis | Revisar copy humana (não só seed técnico) |
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
| Fundação + catálogo seed (~124) | 🟢 Avançado |
| `product-theme` core (23 vars) | 🟢 Feito — só sob demanda |
| Padrões app-cliente / Painel | 🟢 Fechamento declarado; polish contínuo |
| Fluxo decisão Reusar/Variante/Novo | 🟢 Página Figma publicada |
| Docs visuais Figma (humanas) | 🟢 **Completo** — ver `DS-HUMAN-DOCS-REGISTRY.md` (~75 frames) |
| Painel Home audit queue | 🟢 Validada 2026-08-17 — seed promo tokens; componentes alinhados |
| Storybook Pages sync | 🟢 Operacional |
| React / Chromatic / Code Connect | ⬜ Depois |

---

## Próximos passos (ordem recomendada)

1. ~~Publicar no Figma a página “Como evoluir o DS”~~ ✅  
2. ~~Docs humanas W0–W6~~ ✅ → [`DS-HUMAN-DOCS-REGISTRY.md`](./DS-HUMAN-DOCS-REGISTRY.md)  
3. ~~**Auditar** frames no Figma~~ ✅ W0–W6 aplicadas (2026-08-17)  
4. ~~Limpar orphans W4~~ ✅ DividerHorizontal `3298:1409` + PaginationItem `3382:9339` removidos após rewire  
5. **Manter** sync Storybook a cada ajuste de metadata  
6. **Opcional:** limpar untracked legado  
7. **Só quando o time pedir:** React → Autodocs → Code Connect

---

## Papel do agente

- Orientar decisão (reusar / variante / novo)  
- Auditar / mapear tokens quando pedido  
- Sync docs JSON → Storybook → commit/push quando você pedir  
- **Não** aplicar Figma sem `aplicar` explícito
