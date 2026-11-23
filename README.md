# Design System 2.0 — workspace

Artefatos do Design System Figma **[DS] 2.0 - S2**, pacote React `@ds/react`, tokens CSS e catálogo Storybook.

## Monorepo

```text
packages/tokens   → CSS custom properties (geradas do seed JSON)
packages/react    → componentes React + Code Connect (*.figma.tsx)
storybook/        → Autodocs CSF3 + seed MDX (híbrido)
```

```bash
npm install
npm run tokens:build
npm test
npm run lint:variants
npm run storybook
```

Guia React: [`REACT-CONTRIBUTING.md`](./REACT-CONTRIBUTING.md)

### Flutter (App Cliente)

```text
packages/flutter_tokens      → loovi_tokens (ThemeExtension gerado do seed, mode app-cliente)
packages/flutter_ds          → loovi_ds (widgets)
packages/flutter_widgetbook  → catálogo Widgetbook
```

Guia: [`FLUTTER-CONTRIBUTING.md`](./FLUTTER-CONTRIBUTING.md) · inventário: [`FLUTTER-INVENTORY.md`](./FLUTTER-INVENTORY.md)

## Storybook

- **Seed metadata:** [`design-system-tokens.storybook.updated.v2.json`](./design-system-tokens.storybook.updated.v2.json)
- Componentes com `reactImplemented: true` usam **Autodocs** (CSF3); seed MDX é pulado pelo gerador
- **Publish:** GitHub Pages via [`.github/workflows/storybook.yml`](./.github/workflows/storybook.yml)

## Outros

- `design-system-storybook.md` — export Markdown (legado/auxiliar)
- `ds-painel-audit/` — auditorias Painel Home
- [`AGENTS.md`](./AGENTS.md) — regras para agentes
