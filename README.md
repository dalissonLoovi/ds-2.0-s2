# Design System 2.0 — workspace

Artefatos do Design System Figma **[DS] 2.0 - S2** e catálogo Storybook (docs seed).

## Documentação Storybook

O catálogo vive em [`storybook/`](./storybook/).

```bash
cd storybook
npm install
npm run storybook
```

- **Fonte do seed:** [`design-system-tokens.storybook.updated.v2.json`](./design-system-tokens.storybook.updated.v2.json)
- **Gerador:** `storybook/scripts/generate-docs-from-json.mjs`
- **Publish:** GitHub Pages via [`.github/workflows/storybook.yml`](./.github/workflows/storybook.yml)

Fluxo: Figma → atualiza JSON → `npm run docs:generate` → PR → Pages.

Guia completo: [`storybook/README.md`](./storybook/README.md).

## Outros

- `design-system-storybook.md` — export Markdown espelhando o JSON (legado/auxiliar)
- `ds-painel-audit/` — auditorias Painel Home
