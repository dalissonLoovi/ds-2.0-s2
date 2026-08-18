# React contributing — @ds/react

## Layout

```text
packages/tokens/     # CSS vars from seed JSON (`text/*`, `feedback/*`, `interactive/*`, `color/*`, …)
packages/react/      # React components + Code Connect (*.figma.tsx)
storybook/           # Hybrid catalog: Autodocs CSF3 + seed MDX
```

## Public API vs draft

| Import | Meaning |
| --- | --- |
| `@ds/react` | Polished DoD components (`reactImplemented: true`) — W0–W7 |
| `@ds/react/draft` | Empty (CommentItem is Figma-only; no remaining React scaffolds) |

Do not re-export scaffolds from the package root. Prefer seed MDX until a component is polished.

## Definition of Done (per component)

1. Props/variants match seed (`design-system-tokens.storybook.updated.v2.json`)
2. Styles use CSS vars from `@ds/tokens` only (no stray hex for brand/feedback)
3. CSF3 story with `tags: ['autodocs']` under the polished title (not `Draft/`)
4. Smoke test (render + one interaction)
5. Seed: `"reactImplemented": true`, `"reactPackage": "@ds/react"`; remove `reactScaffold`
6. Move export from `draft.ts` → `index.ts`
7. Code Connect file `Component.figma.tsx` with seed `nodeId`
8. `npm run lint:variants` + `npm test` + Storybook build green
9. Seed MDX for that name is skipped by `docs:generate`

## Commands

```bash
npm install
npm run tokens:build
npm run test
npm run lint:variants
npm run storybook
```

## Naming

- PascalCase React name = Figma/seed name
- Subcomponents: `*Item` (never new `*Block`)
- Feedback vocab: `info | system | success | warning | danger`

## Figma

Audit → report → wait for `aplicar` before changing Figma. React must not invent variants; fix seed/Figma first.
