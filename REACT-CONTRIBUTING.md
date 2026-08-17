# React contributing — @ds/react

## Layout

```text
packages/tokens/     # CSS vars from seed JSON
packages/react/      # React components + Code Connect (*.figma.tsx)
storybook/           # Hybrid catalog: Autodocs CSF3 + seed MDX
```

## Definition of Done (per component)

1. Props/variants match seed (`design-system-tokens.storybook.updated.v2.json`)
2. Styles use CSS vars from `@ds/tokens` only (no stray hex for brand/feedback)
3. CSF3 story with `tags: ['autodocs']`
4. Smoke test (render + one interaction)
5. Mark seed entry: `"reactImplemented": true`, `"reactPackage": "@ds/react"`
6. Code Connect file `Component.figma.tsx` with seed `nodeId`
7. `npm run lint:variants` + `npm test` + Storybook build green
8. Seed MDX for that name is skipped by `docs:generate`

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
