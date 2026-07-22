# Design System 2.0 — Storybook

Catálogo de documentação (seed) gerado a partir de:

`../design-system-tokens.storybook.updated.v2.json`

Enquanto os componentes React não existem, este Storybook é **docs-only**: páginas MDX com AI-READY, variants, props, rules, tokens e link Figma.

## Requisitos

- Node.js 20+
- npm 10+

## Comandos

```bash
cd storybook
npm install
npm run docs:generate   # JSON → MDX
npm run storybook       # http://localhost:6006
npm run build-storybook # saída em storybook-static/
```

## Fluxo de atualização

1. Auditar / fechar componente no Figma (`[DS] 2.0 - S2`)
2. Atualizar o JSON na raiz do repo (`design-system-tokens.storybook.updated.v2.json`)
3. `npm run docs:generate` (já roda no `prestorybook` / `prebuild-storybook`)
4. Revisar localmente → PR → merge em `main`
5. GitHub Actions publica no **GitHub Pages**

Não edite os MDX em `src/components/` e `src/foundations/` à mão — eles são gerados.

## Publish

- **Git (fonte da verdade do seed):** JSON + este pacote
- **GitHub Pages:** site estático do build (workflow `.github/workflows/storybook.yml`)
- **Chromatic:** opcional depois (review visual)

Para Pages em project site, o `base` do Vite usa `GITHUB_REPOSITORY` automaticamente no CI.

## Evolução (por componente)

Quando um componente existir em React:

1. Criar `*.stories.tsx` (CSF3) + `tags: ['autodocs']`
2. Mover narrativa para MDX colado à story
3. Remover a página seed gerada daquele componente
4. Prop tables passam a vir do TypeScript

## Estrutura

```text
storybook/
  .storybook/          # main + preview
  scripts/             # generate-docs-from-json.mjs
  src/
    Introduction.mdx
    Changelog.mdx
    foundations/       # gerado
    components/        # gerado
```
