# AGENTS — Design System 2.0 (S2)

Orientações para agentes Cursor neste repositório. Leia antes de auditar Figma, editar tokens/docs ou publicar Storybook.

## Contexto

| Item | Valor |
| --- | --- |
| Figma | [[DS] 2.0 - S2](https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2) |
| File key | `mHm12Zu9tgNmaSYnooihE5` |
| Repo | https://github.com/dalissonLoovi/ds-2.0-s2 |
| Storybook (Pages) | https://dalissonloovi.github.io/ds-2.0-s2/ |
| Metadata seed | `design-system-tokens.storybook.updated.v2.json` |
| Storybook app | `storybook/` |

## Dinâmica padrão — Figma (obrigatória)

No Design System Figma ([DS] 2.0 - S2 e componentes relacionados):

1. **Só auditar / revisar** o componente contra a estrutura consolidada (tokens kebab-case, props, variants, AI-Ready, storybook).
2. **Reportar** inconsistências e correções sugeridas.
3. **NUNCA aplicar correções de imediato** — esperar confirmação explícita do usuário (`aplicar`, etc.) antes de editar Figma, tokens, props ou storybook.
4. Depois de aplicar: atualizar documentação no padrão atual (JSON v2, MD, changelog/`recentUpdates`, metadata do componente). **Não** copiar para `Downloads`.

### Regras de conteúdo (Figma / docs)

- Descrições de componente: **inglês**, prefixo `AI-READY COMPONENT:` (ou `AI-READY INTERNAL COMPONENT:` quando for interno).
- Tokens: **kebab-case** local S2; sem remotes; sem Title Case legado.
- Ícones: preferir ícones locais do DS; layers internas `{icon-name}-path`.
- Vocabulário de feedback: `info` \| `system` \| `success` \| `warning` \| `danger`. Deprecated: `positive`, `negative`, `delete`, `error` (como intent/status).
- Não editar descrições de props VARIANT via API Figma quando isso for restrição conhecida; documentar TEXT/BOOLEAN no storybook metadata se a API falhar.

### Nomenclatura — sufixo `Item` (subcomponentes)

**Regra:** componente feito para ser usado **especificamente dentro de outro componente** (célula, linha, slot, segmento, pedaço da anatomia do pai) → sufixo **`Item`**.

| Usar | Não usar (para esse papel) |
| --- | --- |
| `BreadcrumbItem`, `ListItem`, `VerificationCodeInputItem` | `*Block` como sinônimo de subcomponente |

- `Item` = filho / building block **do pai** (não é página/standalone).
- O nome do pai vem primeiro: `{Parent}Item` (ex.: `NavigationBarItem`, `VerificationCodeInputItem`).
- Se `{Parent}Item` já existir com outro papel, usar qualificador + `Item` (ex.: `FileUploaderDropzoneItem` vs `FileUploaderItem`).
- **Não** criar novos `*Block` para esse papel. Em auditorias, reportar `*Block` legado que seja subcomponente como inconsistência de naming (P2), sugerindo rename → `*Item`.
- **Não renomear no Figma/docs sem confirmação explícita** do usuário (mesma dinâmica de apply).
- Exceções só se o usuário definir outro significado para um nome legado. Na dúvida, reportar e perguntar.

Inventário alinhado (rename 2026-07-22):

- **`Item` (incl. renomes):** BreadcrumbItem, FileUploaderItem, FileUploaderDropzoneItem (ex-FileUploaderBlock; dropzone — não colidir com FileUploaderItem), ListItem, ListActionDropdownItem, VerticalStepperItem, TabItem, PaginationSelectMenuItem, PaginationItem, NavigationRail*Item, NavigationBarItem, NavigationDrawerItem, CommentItem, ImageItem, VerificationCodeInputItem, DatePickerSelectItem
- **Colisão resolvida:** `FileUploaderBlock` → `FileUploaderDropzoneItem` (não `FileUploaderItem`)

## Fluxo de documentação → Storybook

O JSON é a **fonte do seed** enquanto não houver React. O Storybook MDX é **gerado** — não editar à mão.

```text
Figma (audit/apply)
  → design-system-tokens.storybook.updated.v2.json
  → (opcional) design-system-storybook.md
  → cd storybook && npm run docs:generate
  → commit + push em main
  → GitHub Pages publica o catálogo
```

### Comandos

```bash
cd storybook
npm install          # primeira vez
npm run docs:generate
npm run storybook    # http://localhost:6006
```

`docs:generate` também roda no `prestorybook` / `prebuild-storybook`.

### O que NÃO editar manualmente

- `storybook/src/components/**/*.mdx`
- `storybook/src/foundations/**/*.mdx`
- Em geral: MDX gerados sob `storybook/src/` (exceto se o usuário pedir ajuste no gerador)

Edite o gerador em `storybook/scripts/generate-docs-from-json.mjs` se o formato das páginas precisar mudar.

### Após atualizar o JSON (Definition of Done parcial)

1. Atualizar entrada do componente em `storybook.components` (description, variants, props, rules, tokenRules, accessibility, composition, nodeId).
2. Atualizar `meta.storybookRevision`, `meta.storybookUpdatedAt`, `meta.changelog` e `storybook.recentUpdates`.
3. Regenerar MD se o time ainda mantiver `design-system-storybook.md` (`json-to-storybook-md.ps1` ou equivalente).
4. Rodar `npm run docs:generate` em `storybook/`.
5. Commitar JSON + MDX gerados (+ MD se aplicável) e fazer push em `main` para republicar Pages.

Não commitar `storybook/node_modules` nem `storybook/storybook-static`.

## Escopo do seed vs SoT futuro

| Fase | Fonte da verdade | Storybook |
| --- | --- | --- |
| Agora (construção Figma) | Figma + JSON metadata | Docs-only (seed MDX) |
| Temas por produto (depois) | Tokens/themes + Foundations | Modes / foundations pages |
| Componente em React | Código + CSF3 stories | Autodocs; remover seed daquele componente |

- **Não esperar** “todos os componentes + temas” para documentar: documentar por fatia (componente fechado na auditoria).
- **Chromatic:** ainda não; só quando o time pedir review visual.

## Git / publish

- Branch de publish: `main`.
- Workflow: `.github/workflows/storybook.yml` (build + GitHub Pages).
- Repo público (Pages no plano atual exige public).
- Não usar `git push --force` em `main` sem pedido explícito.
- Só criar commit quando o usuário pedir.

## O que está fora deste fluxo

- Implementar React dos componentes (outro passo, por componente).
- Editar o site storybook.js.org (é documentação da ferramenta, não o nosso catálogo).
- Tratar o Markdown legado como destino final — o publish canônico do catálogo é o Storybook gerado + Pages.

## Checklist rápido — auditoria de um componente

- [ ] Auditar no Figma; reportar P1/P2/P3; **não aplicar** sem confirmação
- [ ] Com “aplicar”: corrigir Figma conforme combinado
- [ ] Atualizar JSON v2 (+ changelog/recentUpdates)
- [ ] Atualizar `design-system-storybook.md` se for o padrão da sessão
- [ ] `cd storybook && npm run docs:generate`
- [ ] Commit/push só se o usuário pedir
