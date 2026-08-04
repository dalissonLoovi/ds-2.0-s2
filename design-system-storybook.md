# Design System 2.0 — Storybook

> **Arquivo Figma:** [[DS] 2.0 - S2](https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3104-2940)  
> **File key:** `mHm12Zu9tgNmaSYnooihE5`  
> **Schema:** ds-storybook-metadata/v2  
> **Atualizado em:** 2026-07-29T13:30:00-03:00  
> **Revision:** 2026-07-29-alert-fill-stack

Component documentation, controls, variant options and AI-Ready rules for Storybook docs. Token values remain under tokens.

---

## Regras globais

| Regra | Valor |
|---|---|
| Variants | variant keys use lower camelCase; values use lowercase or kebab-case where possible |
| Tokens | use local DS variables only; do not create tokens from Storybook docs |
| Component tokens | `component/[component]/[part]/[property]/[modifier?]` |
| Icon layers | generic Vector layers should be renamed to `{icon-name}-path` in source components |
| Icon scale | sizes `80/64/40/32/24/20/16`; stroke scales from master `24px` + `border/width/025` (2px) |
| Icon libraries | Library Swap + shared `*-outline` / `*-filled` contract (EV Tabler / App Hugeicons + aliases) |
| Code Connect | not configured in this JSON |

### VocabulÃ¡rio de feedback

**Usar:** `info`, `system`, `success`, `warning`, `danger`

**Deprecated (nÃ£o usar):** `positive`, `negative`, `delete`, `error`

### GovernanÃ§a adicional

- **Nomenclatura:** kebab-case path segments, slash hierarchy, no spaces, no title case
- **Disabled:** use disabled, never disable
- **DescriÃ§Ãµes de componentes:** AI-Ready component documentation aligned with current variables, kebab-case variants, semantic tokens and future React readiness.
- **Camadas de Ã­cone:** Inner vector layers in icons should use `{icon-name}-path` instead of generic Vector.
- **Escala de Ã­cone:** ver seÃ§Ã£o [Iconografia — escala de tamanho e stroke](#iconografia--escala-de-tamanho-e-stroke)
- **Libs de Ã­cone (multi-produto):** ver seÃ§Ã£o [Iconografia — libs e Library Swap](#iconografia--libs-e-library-swap)
- **Brand surface:** `color/background-surface/brand` (`#4967EE` via `primitive-colors/brand-blue`) — fills de chrome brand (`FRAME_FILL`|`SHAPE_FILL`). NÃ£o usar para texto (`text/brand` / `color/palette/brand` = sapphire `#516CE7`) nem aÃ§Ã£o primÃ¡ria (`color/actions/primary` = azure-wave `#4C6BF8`).
- **Product theme:** ver seÃ§Ã£o [Product theme (`product-theme`)](#product-theme-product-theme)

---

## Product theme (`product-theme`)

Multi-product theming for S2. One published component master stays mode-aware via `product-theme` aliases — switch `escritorio-virtual` | `site-loovi` | `app-cliente` to preview. Do not fork components per product; do not hardcode product fills/radii on themed slots.

| Field | Value |
|---|---|
| Collection | `product-theme` (`VariableCollectionId:3218:3688`) |
| Modes | `escritorio-virtual` \| `site-loovi` \| `app-cliente` |
| Components | `AppHeader`, `Button`, `Modal`, `ModalHeader`, `Input`, `InputTextArea`, `ListActionDropdown`, `List` |
| Variable count | 20 |

| Token | Component | Bind | escritorio-virtual | site-loovi | app-cliente |
|---|---|---|---|---|---|
| `component/app-header/inverse/background` | AppHeader | `appearance=inverse` root fill | `color/background-surface/inverse-3` | `color/background-surface/brand` | `color/background-surface/brand` |
| `component/app-header/leading-action/background` | AppHeader | `leadingAction` fill | `color/background-surface/0` | `color/background-surface/2` | `color/background-surface/2` |
| `component/app-header/leading-action/radius` | AppHeader | `leadingAction` radius | `border/radius/200` | `border/radius/full` | `border/radius/full` |
| `component/app-header/avatar/background` | AppHeader | Avatar fill (global × inverse) | `color/background-surface/3` | `rgba(255,255,255,0.16)` | `rgba(255,255,255,0.16)` |
| `component/app-header/avatar/icon-color` | AppHeader | Avatar icon stroke (global × inverse) | `text/primary` | `text/on-color` | `text/on-color` |
| `component/app-header/title/font-size` | AppHeader | title small\|small-centered × default × specific | `heading/h3/font-size` | `heading/h3/font-size` | `body/medium/font-size` |
| `component/app-header/title/line-height` | AppHeader | title small\|small-centered × default × specific | `heading/h3/line-height` | `heading/h3/line-height` | `body/medium/line-height` |
| `component/app-header/title/font-weight` | AppHeader | title small\|small-centered × default × specific | `font-weight/medium` | `font-weight/medium` | `font-weight/regular` |
| `component/button/container/background` | Button | solid container fill | `color/actions/primary` | `color/background-feedback-primary/success` | `color/actions/primary` |
| `component/button/container/radius/lg` | Button | radius size=md\|lg | `border/radius/200` | `border/radius/full` | `border/radius/full` |
| `component/button/container/radius/sm` | Button | radius size=sm | `border/radius/150` | `border/radius/full` | `border/radius/full` |
| `component/button/label/color` | Button | solid label | `text/on-color` | `text/primary` | `text/on-color` |
| `component/button/label/font-weight` | Button | label weight | `font-weight/medium` | `font-weight/semi-bold` | `font-weight/medium` |
| `component/button/icon/color` | Button | solid/outline icon | `text/on-color` | `text/primary` | `text/on-color` |
| `component/modal-header/close-action/background` | ModalHeader | closeAction fill | `color/background-surface/0` | `color/background-surface/2` | `color/background-surface/2` |
| `component/modal-header/close-action/radius` | ModalHeader | closeAction radius | `border/radius/200` | `border/radius/full` | `border/radius/full` |
| `component/modal-header/close-action/size-mobile` | ModalHeader | closeAction size (mobile) | `40` | `40` | `32` |
| `component/modal/container/radius` | Modal | shell corner radius | `border/radius/600` | `border/radius/600` | `border/radius/800` |
| `component/input/field/radius` | Input | field corner radius | `border/radius/200` | `border/radius/full` | `border/radius/full` |
| `component/input-textarea/field/radius` | InputTextArea | field corner radius | `border/radius/200` | `border/radius/500` | `border/radius/500` |
| `component/list-action/container/radius` | ListActionDropdown \| List | shell corner radius (menu + List plain\|dropdown) | `border/radius/200` | `border/radius/500` | `border/radius/500` |

### Notes

- site-loovi solid Button uses success feedback fill + `text/primary` label/icon (not on-color).
- app-cliente AppHeader titles on `small|small-centered` × default × specific use `body/medium/regular`; apply `text-transform:uppercase` in product UI (Figma `textCase` stays ORIGINAL).
- app-cliente ModalHeader close-action: mobile `size-mobile`=32 + surface/2 + radius/full; desktop close stays `spacing/500` (40). EV|site-loovi mobile stay 40.
- Modal shell radius binds `component/modal/container/radius` — EV|site-loovi→`border/radius/600` (24); app-cliente→`border/radius/800` (32).
- Avatar backgrounds on site-loovi|app-cliente use raw rgba white @ 16% (no semantic alias yet).
- Input field radius: EV→200; site-loovi|app-cliente→full. InputTextArea field radius: EV→200; site-loovi|app-cliente→500 (not full).
- `component/list-action/container/radius` shared by ListActionDropdown and List (`plain`|`dropdown`): EV→`border/radius/200`; site-loovi|app-cliente→`border/radius/500` (same step as InputTextArea, not full).

---

## Iconografia — escala de tamanho e stroke

Outline icons no S2 sÃ£o desenhados no master **24×24** com stroke token **`border/width/025` (= 2px)**. Para usar o mesmo asset em outros tamanhos, o stroke deve ser **proporcional** — nÃ£o manter o bind absoluto de 2px.

### FÃ³rmula

`strokePx = 2 × (size / 24)`

### Escala oficial

| Size (px) | Stroke (px) | Bind de stroke | Uso tÃ­pico |
|---|---|---|---|
| **80** | 6.67 | unbind + proporcional (ou Scale **K**) | hero / onboarding |
| **64** | 5.33 | unbind + proporcional (ou Scale **K**) | empty state grande |
| **40** | 3.33 | unbind + proporcional (ou Scale **K**) | empty state mÃ©dio / featured |
| **32** | 2.67 | unbind + proporcional (ou Scale **K**) | aÃ§Ã£o enfatizada |
| **24** | **2.00** | **`border/width/025` (nativo)** | default — Button e master |
| **20** | 1.67 | unbind + proporcional (ou Scale **K**) | list row, chip, controle denso + body/medium |
| **16** | 1.33 | unbind + proporcional (ou Scale **K**) | caption / chrome compacto |

### Regras

1. **SÃ³ o size 24** pode manter `strokeWeight` bound em `border/width/025`.
2. Em **qualquer outro size**, ao redimensionar a partir do master 24: usar **Scale tool (K)** no Figma **ou** unbind `strokeWeight` e aplicar o valor da tabela.
3. **`INSTANCE_SWAP`** reinsere o bind 2px do master — reaplicar stroke proporcional quando `size !== 24`.
4. NÃ£o inventar tokens de stroke intermediÃ¡rios sÃ³ para caber a escala; a escala Ã© governanÃ§a de uso sobre o master + `border/width/025`.
5. **Futuro (Ã³ptico):** para â‰¤16 (e 20 quando o detalhe colapsar), preferir desenhos Ã³pticos dedicados; atÃ© lÃ¡, a regra proporcional Ã© a oficial.

### Pairing rÃ¡pido

- Texto `body/medium` em row densa → Ã­cone **20**
- Button / aÃ§Ã£o padrÃ£o → Ã­cone **24**
- Empty state → **40** ou **64**
- Hero → **80**

---

## Iconografia — libs e Library Swap

Ãcones multi-produto usam **Library Swap** + um **contrato de nome DS** compartilhado (`*-outline` / `*-filled`). NÃ£o codificar packs de produto como variantes multi-theme em um Ãºnico componente de Ã­cone.

### Contrato e estratÃ©gia

| Item | Regra |
|---|---|
| Name contract | `*-outline` \| `*-filled` (kebab-case) — mesmas chaves no S2, EV e aliases App |
| EstratÃ©gia | Library Swap (A) + `INSTANCE_SWAP` nos componentes S2 (B). Evitar variantes multi-theme (C) |
| Slots S2 | `INSTANCE_SWAP` sÃ³ no contrato DS — nunca nomes nativos Hugeicons (`search-02`, `notification-02`, â€¦) |

### Bibliotecas

| Library | File key | Pack | Naming | Theme |
|---|---|---|---|---|
| [[DS] Icons — EscritÃ³rio Virtual](https://www.figma.com/design/ThZ5XtMuDWUWXiSLbRyEXL/-DS--Icons---Escrit%C3%B3rio-Virtual) | `ThZ5XtMuDWUWXiSLbRyEXL` | Tabler | Nativo `*-outline` / `*-filled` | `escritorio-virtual` |
| [[DS] Icons — App Cliente](https://www.figma.com/design/4LsFOmHu3B25vXsDPjklWs/-DS--Icons---App-Cliente) | `4LsFOmHu3B25vXsDPjklWs` | Hugeicons | CatÃ¡logo Hugeicons intacto + seÃ§Ã£o **DS Semantic Aliases (swap contract)** (`7003:12884`) com clones no contrato DS | `app-cliente` |

### Regras de alias (App Cliente)

- Clonar + renomear para o contrato DS — **nÃ£o** renomear o catÃ¡logo Hugeicons in-place
- **Nunca** criar alias cujo nome jÃ¡ exista no mesmo arquivo (nome duplicado bloqueia Publish library)
- Expandir aliases a partir do inventÃ¡rio de uso do S2 / preferredValues — **nÃ£o** do Tabler completo
- **Republicar** a lib App Cliente depois de adicionar aliases, antes do Library Swap nos consumidores

### NÃ£o fazer

- Variantes multi-theme em um Ã­cone para packs de produto
- Colocar nomes nativos Hugeicons em preferredValues de `INSTANCE_SWAP` no S2
- Esperar cobertura 1:1 do inventÃ¡rio Tabler inteiro

---

## Feedback — tabela de uso por camada

Use the unified feedback vocabulary (info | system | success | warning | danger) and pick the token layer by surface role: content for text/icons, bg-primary for emphasized blocks, bg-secondary for subtle tint, interactive/*-surface for form validation backgrounds, border-feedback for accent borders.

### Resumo rÃ¡pido

| Camada | PadrÃ£o de token | Status / papÃ©is | Componentes |
|---|---|---|---|
| Content / status color | `feedback/{status}` | success, warning, danger | Button |
| Background — feedback primary | `color/background-feedback-primary/{status}` | success, warning, danger, info, system | Banner, ChipClickable, ChipTag, Badge |
| Background — feedback secondary | `color/background-feedback-secondary/{status}` | success, warning, danger | Button |
| Interactive validation surface | `interactive/{semantic}-surface` | danger, success | Button, ChipClickable |
| Border — feedback accent | `color/border-feedback/{role}` | primary, success, danger | Checkbox, Button |

### Guia de decisÃ£o

- Need readable status text/icon on a neutral surface? → `feedback/{status}`
- Need a full feedback block (Banner, alert row, strong chip)? → `color/background-feedback-primary/{status}` + `text/primary`
- Need a soft tint behind related content? → `color/background-feedback-secondary/{status}`
- Need input/control validation background? → `interactive/error-surface` (danger) or `interactive/success-surface` (success)
- Need a validation or selection border? → `color/border-feedback/{success|danger|primary}`

### Content / status color

- **PadrÃ£o:** `feedback/{status}`
- **Export prefix:** `feedback`
- **Status disponÃ­veis:** success, warning, danger
- **Status indisponÃ­veis nesta camada:**
  - **info:** `feedback/info` available (content layer).
  - **system:** No feedback/system content token. Use text/primary on color/background-feedback-primary/system or neutral surfaces with system iconography.
- **Usar para:**
  - Status text and icons on neutral surfaces
  - Inline semantic labels and helper text
  - Button intent labels for success and danger
- **NÃ£o usar para:**
  - Large tinted feedback blocks — use color/background-feedback-primary/*
  - Soft page/section tint — use color/background-feedback-secondary/*
  - Input or control validation backgrounds — use interactive/*-surface
  - Accent borders — use color/border-feedback/*
- **Variables Figma:** `feedback/success`, `feedback/warning`, `feedback/danger`
- **Componentes:** Button

### Background — feedback primary

- **PadrÃ£o:** `color/background-feedback-primary/{status}`
- **Export prefix:** `color-bg-feedback-primary`
- **Status disponÃ­veis:** success, warning, danger, info, system
- **Text pairing:** Pair with text/primary for message, label and icon on saturated fills.
- **Usar para:**
  - High-emphasis feedback blocks and inline alerts
  - Banner status backgrounds
  - ChipClickable and ChipTag intent fills (info, system, success, warning, danger)
  - Badge emphasis when a strong status fill is required
- **NÃ£o usar para:**
  - Subtle tinting behind dense content — use color/background-feedback-secondary/*
  - Form field validation — use interactive/error-surface or interactive/success-surface
  - Body copy on default page surfaces without a feedback container
- **Variables Figma:** `color/background-feedback-primary/success`, `color/background-feedback-primary/warning`, `color/background-feedback-primary/danger`, `feedback/info`, `color/background-feedback-primary/system`
- **Componentes:** Banner, ChipClickable, ChipTag, Badge

### Background — feedback secondary

- **PadrÃ£o:** `color/background-feedback-secondary/{status}`
- **Export prefix:** `color-bg-feedback-secondary`
- **Status disponÃ­veis:** success, warning, danger
- **Status indisponÃ­veis nesta camada:**
  - **info:** No bg-secondary/info token. Use feedback/info for info emphasis or a neutral surface for subtle info.
  - **system:** No bg-secondary/system token. Use color/background-feedback-primary/system for system emphasis or a neutral surface.
- **Usar para:**
  - Soft, low-contrast feedback tint behind content
  - Secondary emphasis inside cards, forms and sections
  - Button outline / secondary success states
- **NÃ£o usar para:**
  - Full-width Banner blocks — use color/background-feedback-primary/*
  - Chip fills that must read as strong status pills — prefer bg-primary
  - Validation backgrounds on inputs — use interactive/*-surface
- **Variables Figma:** `color/background-feedback-secondary/success`, `color/background-feedback-secondary/warning`, `color/background-feedback-secondary/danger`
- **Componentes:** Button

### Interactive validation surface

- **PadrÃ£o:** `interactive/{semantic}-surface`
- **Mapeamento de vocabulÃ¡rio:**
  - `error-surface` → danger — failed validation, field error, destructive input state
  - `success-surface` → success — passed validation, confirmed input state
- **Status disponÃ­veis:** danger, success
- **Status indisponÃ­veis nesta camada:**
  - **info:** No interactive/info-surface token. Keep info at container level with bg-primary/info.
  - **system:** No interactive/system-surface token. Keep system at container level with bg-primary/system.
  - **warning:** No interactive/warning-surface token. Use bg-primary/warning or bg-secondary/warning for warning containers.
- **Usar para:**
  - Input, textarea, select and control backgrounds during validation
  - Inline field success/error affordance tied to interaction
  - ChipClickable danger intent surface when the chip represents a removable/error context
- **NÃ£o usar para:**
  - Page-level Banner or toast messaging
  - Static status labels without a control surface
  - Replacing color/background-feedback-primary on Banner or Chip when the whole block is the message
- **Variables Figma:** `interactive/error-surface`, `interactive/success-surface`
- **Componentes:** Button, ChipClickable

### Border — feedback accent

- **PadrÃ£o:** `color/border-feedback/{role}`
- **Export prefix:** `color-border-feedback`
- **PapÃ©is:**
  - `primary` — Selection or focus accent not tied to success/warning/danger semantics (e.g. Checkbox checked border).
  - `success` — Success validation or approved-state borders on controls and containers.
  - `danger` — Error, failed or destructive-state borders on controls and containers.
- **Usar para:**
  - Control outlines during validation
  - Checkbox and form selection accents
  - Button outline intent borders for success and danger
- **NÃ£o usar para:**
  - Large filled feedback blocks — use bg-primary or bg-secondary
  - Body text color — use feedback/* content tokens or text/*
- **Variables Figma:** `color/border-feedback/primary`, `color/border-feedback/success`, `color/border-feedback/danger`
- **Componentes:** Checkbox, Button

---

## Componentes

## Accordion

**Node ID:** `3181:8443`

AI-READY COMPONENT: Accordion reveals or hides related content under a clickable trigger/header. Use it to progressively disclose related content. Do not use it as a card, modal, dropdown, select, tooltip, permanent list or generic container.

### Variants

- **expanded:** false | true
- **state:** default | disabled
- **size:** sm | md
- **padding:** padded | flush

### Props

| Prop | Tipo / valores |
|---|---|
| `label` | trigger label |
| `showSubtitle` | boolean |
| `subtitle` | supporting text |
| `showAction` | boolean |
| `showSummary` | boolean |
| `summary` | collapsed or supporting summary |
| `slot` | expandable content area |

### Rules

- **disabled:** disabled variants exist only with expanded=false
- **slot:** slot is the only scalable content area and maps to children in React

### Accessibility

The trigger must behave as a button, support Enter and Space, expose aria-expanded and reference the panel with aria-controls.

---

## AppHeader

**Node ID:** `3143:8822`

AI-READY COMPONENT: AppHeader is the top page/application header used to identify the current screen, provide navigation, and expose essential actions. Use `layout=small-centered` for compact centered page titles (`hierarchy=specific|super-app`) or for the Painel Home greeting chrome (`hierarchy=global`). Use `layout=small` for compact left-aligned titles, `layout=medium` for taller page headers, and `layout=large` for high-emphasis page headers. Use `appearance=default` on light surfaces and `appearance=inverse` on inverse/dark surfaces. Intentional sparse matrix (11/24): global = `small-centered` × default|inverse; super-app = `small-centered` × default only; specific = all layouts × appearance. Do not nest inside BottomSheet — use BottomSheetHeader. `showProfileMenu` / `profileMenu` are **super-app only**. **Product-theme** (`escritorio-virtual` | `site-loovi` | `app-cliente`): `component/app-header/inverse/background`, `leading-action/background` + `leading-action/radius`, `avatar/background` + `avatar/icon-color`. Optical keepers on small|small-centered and medium|large slots. Icon paths `{icon}-path`. React mapping: AppHeader(layout, appearance, hierarchy, title, description, greeting, showLabel, showAction, showFirstTrailingAction, showSecondTrailingAction, showProfileMenu). Code Connect is not configured.

### Variants

- **layout:** small-centered | small | medium | large
- **appearance:** default | inverse
- **hierarchy:** global | specific | super-app

### Props

| Prop | Tipo / valores |
|---|---|
| `layout` | small-centered \| small \| medium \| large |
| `appearance` | default \| inverse |
| `hierarchy` | global \| specific \| super-app |
| `showLabel` | boolean — toggles `headingContent` (specific/super-app) or `greeting` (global) |
| `showAction` | boolean — toggles `leadingAction` (specific/super-app) |
| `showFirstTrailingAction` | boolean — search (`default false`; hidden) |
| `showSecondTrailingAction` | boolean — bell (`default true`; visible) |
| `showProfileMenu` | boolean — toggles `profileMenu` (**super-app only**) |
| `greeting` | TEXT — `hierarchy=global` only (default `Olá, Rodrigo`) |
| `title` | TEXT via exposed `headingContent` (non-global) |
| `description` | TEXT via exposed `headingContent` (non-global) |

### Product theme (`product-theme`)

Modes: `escritorio-virtual` | `site-loovi` | `app-cliente`

| Token | Bind | escritorio-virtual | site-loovi | app-cliente |
|---|---|---|---|---|
| `component/app-header/inverse/background` | `appearance=inverse` root fill | `color/background-surface/inverse-3` | `color/background-surface/brand` | `color/background-surface/brand` |
| `component/app-header/leading-action/background` | `leadingAction` fill (specific\|super-app) | `color/background-surface/0` | `color/background-surface/2` | `color/background-surface/2` |
| `component/app-header/leading-action/radius` | `leadingAction` radius | `border/radius/200` | `border/radius/full` | `border/radius/full` |
| `component/app-header/avatar/background` | Avatar fill (global × inverse) | `color/background-surface/3` | `rgba(255,255,255,0.16)` | `rgba(255,255,255,0.16)` |
| `component/app-header/avatar/icon-color` | Avatar icon stroke (global × inverse) | `text/primary` | `text/on-color` | `text/on-color` |
| `component/app-header/title/font-size` | title on `small\|small-centered` × default × specific | `heading/h3/font-size` | `heading/h3/font-size` | `body/medium/font-size` |
| `component/app-header/title/line-height` | title on `small\|small-centered` × default × specific | `heading/h3/line-height` | `heading/h3/line-height` | `body/medium/line-height` |
| `component/app-header/title/font-weight` | title on `small\|small-centered` × default × specific | `font-weight/medium` | `font-weight/medium` | `font-weight/regular` |

### Rules

- **intentionalSparse:** 11/24 — global: `small-centered` × default\|inverse; super-app: `small-centered` × default only; specific: all layouts × appearance
- **titleThemeTypo:** `small|small-centered` × `default` × `specific`: title binds `component/app-header/title/font-size|line-height|font-weight` (EV|site-loovi→`heading/h3` + medium; app-cliente→`body/medium` + regular)
- **appClienteTitleCase:** app-cliente only — `text-transform: uppercase` in product UI; Figma keeps `textCase=ORIGINAL`
- **productTheme:** mode-aware via `product-theme`; bind themed slots to `component/app-header/*` — do not hardcode brand/inverse fills on those slots
- **globalAnatomy:** `hierarchy=global`: `leadingCluster` (Avatar exposed + greeting) + `trailingActions` — not `headingContent`/back
- **superAppAnatomy:** `leadingActions` (FIXED 96 + keeper + menu) \| TextHeader `size=small` `alignment=center` FILL \| `trailingActions` HUG (search optional + bell + profileMenu)
- **profileMenuScope:** `showProfileMenu` / `profileMenu` published only on `hierarchy=super-app`
- **painelHomeTrailing:** Painel Home keeps only bell visible; search via `showFirstTrailingAction=false`
- **localTextHeaderOnly:** `headingContent` must be local `TextHeader` (`3667:4129`)
- **textHeaderSizeMap:** `layout` → TextHeader `size`: `small|small-centered` → `size=small` (alignment left|center); `medium` → `medium`; `large` → `large`
- **globalGreetingCharacteristic:** `hierarchy=global` keeps greeting TEXT with `body/large/medium` — does **not** nest TextHeader
- **inverseTextHeader:** `appearance=inverse`: nested TextHeader title → `text/on-color`; default keeps `text/primary|secondary`
- **smallLayoutFlow:** `small|small-centered` × specific|super-app: `leadingActions` + `headingContent` FILL + `trailingActions`; keepers preserve optical center — do not bind slot `visible` to show*
- **mediumLargeFlow:** `medium|large`: `headerControls` SPACE_BETWEEN with keepers above `headingContent`; root gap `spacing/100`; pad `spacing/200` horiz + `paddingBottom spacing/150` (paddingTop 0)
- **horizontalPad:** all layouts bind `paddingLeft|paddingRight` → `spacing/200` (replaces legacy global `spacing/300` and small `spacing/050` horiz)
- **leadingOpticalCenter:** `showAction=false` must not collapse the leading slot — `leadingSlotKeeper` keeps width
- **trailingSemantics:** `firstTrailingAction`=search; `secondTrailingAction`=bell; Button text/md icon-only FIXED 48
- **noLegacyAction:** Use `leadingAction` only — remove/unexpose legacy `action`
- **painelHome:** `appearance=inverse|default` + `hierarchy=global` + `layout=small-centered`; greeting; Avatar + bell
- **inverseFill:** `appearance=inverse` root → `component/app-header/inverse/background` (EV→`inverse-3`; site-loovi\|app-cliente→`brand`)
- **leadingActionTheme:** `leadingAction` → `component/app-header/leading-action/background` + `leading-action/radius`
- **avatarTheme:** global × inverse Avatar → `component/app-header/avatar/background` + `avatar/icon-color`
- **globalTrailingIconStroke:** default → `text/primary`; inverse → `text/on-color`
- **vsSystemOrgHeader:** Do not use SystemHeader or OrganizationHeader for mobile app chrome
- **vsBottomSheetHeader:** Do not use AppHeader inside BottomSheet — use BottomSheetHeader

### Token rules

- `component/app-header/inverse/background` (`appearance=inverse` root)
- `component/app-header/leading-action/background` (`leadingAction` fill)
- `component/app-header/leading-action/radius` (`leadingAction` radius)
- `component/app-header/avatar/background` (global inverse Avatar)
- `component/app-header/avatar/icon-color` (global inverse Avatar icon stroke)
- `component/app-header/title/font-size|line-height|font-weight` (`small|small-centered` × default × specific)
- app-cliente: `text-transform: uppercase` in implementation (Figma `textCase` ORIGINAL)
- `color/background-surface/0` for default surface
- `text/primary` \| `text/on-color` for titles/greeting
- `text/secondary` \| `text/on-color-disabled` for supporting text
- `body/large/medium` for global greeting (characteristic — not TextHeader)
- `heading/h3/medium` via TextHeader `size=small` on `layout=small|small-centered`
- all layouts: `spacing/200` horiz pad
- global: `spacing/050` vert + `spacing/200` horiz; `spacing/150` leadingCluster gap
- small\|small-centered (specific|super-app): `spacing/100` vert + `spacing/200` horiz; `spacing/0` gap
- medium\|large: `spacing/200` horiz + `spacing/150` paddingBottom (paddingTop 0) + `spacing/100` root gap
- `color/border/2` for profileMenu stroke
- Local DS icons with `{icon}-path`: `menu-2-outline`, `bell-outline`, `arrow-left-outline`, `search-outline`, `plus-outline`, `user-outline`

### Icon rules

Use local DS outline icons only; do not use remote/external icon libraries inside AppHeader. Internal VECTOR layers use `{icon}-path` naming.

### Accessibility

Leading actions need accessible labels. Profile and trailing actions should preserve visible focus and keyboard navigation. Profile menu must behave as an accessible menu button. Icon-only search/bell need accessible names.

### Composition

- global: `leadingCluster` (Avatar exposed + greeting `body/large/medium`) + `trailingActions` (Button text/md)
- specific/super-app: `TextHeader` (`headingContent`, exposed)
- Button (`leadingAction` / `firstTrailingAction` / `secondTrailingAction`)
- Profile menu (exposed on super-app) + Avatar
- menu-2-outline / arrow-left-outline / search-outline / bell-outline / plus-outline / user-outline

---

## Autocomplete

**Node ID:** `3918:573`

AI-READY COMPONENT: Autocomplete is an editable single-select combobox used when users need to type a query, filter a known option set and confirm one valid option. It is not a Select trigger and it does not accept arbitrary free text as a final value. Variants: state=default|hover|focus|error|disabled; content=empty|query|selected; expanded=false|true; appearance=default|inverse (54 variants — state=disabled only publishes expanded=false). Anatomy: field (leadingIcon? + inputControl with resting/floating label, caret on focus, trailing clearAction/loadingIndicator/validationIcon + expandIcon) + supportingText. clearAction = local Button + x-outline; loadingIndicator = LoadingSpinner; error shows alert-circle-outline. ListActionDropdown is never nested — screens compose it floating below the field when expanded=true. appearance=default: field fill color/background-surface/0; floatingLabel cutout color/background-surface/0; default border color/border/1; label text/secondary (focus text/brand; error feedback/danger); placeholder text/placeholder; query/selected text/primary; icon strokes text/secondary (focus text/brand, disabled text/placeholder, error leading+validation feedback/danger). appearance=inverse: field fill transparent; floatingLabel cutout color/background-surface/inverse-3 (all inverse states including focus); default/disabled border color/border/2; label/value/query text/on-color (focus label text/brand; error label feedback/danger); placeholder and non-error supporting text/on-color-disabled; on state=disabled all field texts use text/placeholder-inverse; icon strokes text/on-color (focus text/brand, disabled text/on-color-disabled; error leading+validation feedback/danger, expand may stay text/on-color). Feedback borders unchanged on both appearances — hover color/border-feedback/primary, focus interactive/focus, error color/border-feedback/danger. Disabled: no field fill. Props: label, placeholder, query, selectedValue, supportingText, showSupportingText, showLeadingIcon, leadingIcon, showClearAction, loading. When loading=true prefer showClearAction=false. Do not use as InputSelect, free-text Input, SearchBar, multi-select or PaginationSelectInput. Accessibility: role=combobox + aria-autocomplete=list; external listbox/options; aria-invalid on error; aria-disabled when disabled. Token rule: local S2 kebab-case only. React mapping: Autocomplete(state, content, expanded, appearance, label, placeholder, query, selectedValue, supportingText, showSupportingText, showLeadingIcon?, leadingIcon?, showClearAction?, loading?). Compose ListActionDropdown externally. Code Connect is not configured.

### Variants

- **state:** default | hover | focus | error | disabled
- **content:** empty | query | selected
- **expanded:** false | true (`disabled` only publishes `expanded=false`)
- **appearance:** default | inverse

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| hover \| focus \| error \| disabled (disabled has no field fill) |
| `content` | empty \| query \| selected |
| `expanded` | false \| true — external ListActionDropdown; invalid with disabled (not published) |
| `appearance` | default \| inverse — inverse for dark/on-color surfaces |
| `label` | TEXT — field label |
| `placeholder` | TEXT — hint; visible on `focus` + `empty` |
| `query` | TEXT — typed filter (`content=query`) |
| `selectedValue` | TEXT — confirmed option (`content=selected`) |
| `supportingText` | TEXT — helper or error under field |
| `showSupportingText` | boolean |
| `showLeadingIcon` | boolean |
| `leadingIcon` | INSTANCE_SWAP — local DS outline |
| `showClearAction` | boolean — prefer false when loading |
| `loading` | boolean — LoadingSpinner in trailing status |

### Rules

- **appearanceInverse:** `appearance=inverse`: transparent field; floatingLabel cutout `inverse-3` including focus; `border/2`; on-color texts; disabled texts `text/placeholder-inverse`; focus label `text/brand`; error label `feedback/danger`; hover `color/border-feedback/primary` (not `interactive/hover`)
- **disabledNoFill:** `state=disabled` field has no background fill (transparent); stroke `color/border/2` — keep this
- **noDisabledExpanded:** Do not combine `state=disabled` with `expanded=true` (variants removed)
- **externalDropdown:** ListActionDropdown floats below field when `expanded=true`; never nested in the set
- **loadingOverClear:** `loading=true` takes precedence; `loadingIndicator` visible bound to `loading`
- **floatingLabelPlaceholder:** Placeholder shows on `state=focus` + `content=empty`; resting label when empty and not focused
- **vsInputSelectSearch:** Do not use as InputSelect, free-text Input, SearchBar, multi-select, or PaginationSelectInput

### Token rules

- default: `color/background-surface/0`; `color/border/1`; `text/primary|secondary|placeholder|brand`
- inverse: transparent field; cutout `color/background-surface/inverse-3`; `color/border/2`; `text/on-color|on-color-disabled`; disabled texts `text/placeholder-inverse`
- shared feedback: `color/border-feedback/primary|danger`, `interactive/focus`, `feedback/danger`
- no field fill on disabled
- `border/radius/200`
- `body/large/regular|body/small/regular`

### Accessibility

role=combobox with aria-autocomplete=list, aria-expanded, aria-controls, aria-activedescendant; external listbox/options; aria-invalid on error; aria-disabled when disabled; label associated; supporting via aria-describedby.

### Composition

- Button (clear)
- LoadingSpinner
- ListActionDropdown (external)
- local DS outline icons

---

## Avatar

**Node ID:** `3669:8605`

AI-READY COMPONENT: Avatar represents a user, customer, driver, team member, profile or account identity. Use content=image for photo identity, content=initials when the name is known but no photo exists, and content=placeholder when identity is unavailable. Default fill for `content=initials` and `content=placeholder` (all sizes/states): `color/background-surface/3`. `content=image` uses the photo fill (no surface/3 shell); image hover may use `color/elevation/inverse-3` overlay. Avatar is not interactive by default; interaction belongs to a wrapper such as AvatarButton or AvatarUpload.

### Variants

- **content:** image | initials | placeholder
- **size:** micro | xs | sm | md | lg | xl
- **state:** default | hover | focus | disabled | loading

### Props

| Prop | Tipo / valores |
|---|---|
| `content` | image \| initials \| placeholder |
| `size` | micro \| xs \| sm \| md \| lg \| xl |
| `state` | default \| hover \| focus \| disabled \| loading |

### Rules

- **defaultFill:** initials|placeholder → `color/background-surface/3` across all sizes
- **imageFill:** `content=image` uses photo fill; hover may use `color/elevation/inverse-3` overlay

### Token rules

- `color/background-surface/3` (default fill — initials|placeholder, all sizes)
- initials micro → `body/small/regular`
- initials xs → `body/large/regular`
- initials sm → `heading/h3/regular`
- initials md → `heading/h2/regular`
- initials lg → `heading/h1/regular`
- initials xl → `display/large/regular`
- local text styles only — no remote typography variables on initials

### Accessibility

Non-interactive Avatar should be decorative or described by surrounding content. Interactive wrappers must provide aria-label and visible focus.

---

## AvatarGroup

**Node ID:** `3056:4057`

AI-READY COMPONENT: AvatarGroup displays multiple related identities in a compact group. Use it for participants, members, users, customers or drivers. Do not use it for a single identity. The more-users-indicator is informational and must not be treated as a button.

### Variants

- **size:** micro | xs | sm | md | lg | xl

### Props

| Prop | Tipo / valores |
|---|---|
| `size` | micro \| xs \| sm \| md \| lg \| xl |

### Accessibility

Expose a group-level accessible label when the grouped identities are meaningful. The overflow indicator should not receive focus unless a real interaction is added by a wrapper.

---

## Badge

**Node ID:** `3086:5079`

AI-READY COMPONENT: Badge is a compact non-interactive indicator attached to another element. Use content=dot for existence of activity, content=count for exact quantity and content=overflow when the count exceeds the display limit. Do not use Badge as a button, tag, filter, chip, status label or CTA.

### Variants

- **size:** sm | lg
- **content:** dot | count | overflow

### Props

| Prop | Tipo / valores |
|---|---|
| `size` | sm \| lg |
| `content` | dot \| count \| overflow |
| `count` | visible number for count content |
| `overflowLabel` | visible overflow label such as 999+ |

### Accessibility

If the badge is the only indicator, provide an accessible label on the parent. If adjacent text explains it, the badge can be hidden from assistive technology.

---

## Alert

**Node ID:** `4406:91`

AI-READY COMPONENT: Alert is an in-flow persistent feedback card used to call attention to status that may require a follow-up action. Use for contextual warnings, successes, info, or danger notices inside pages/forms — not for transient non-blocking messages (use Toast) and not for modal interruption (use Modal). Variants: status=system|info|success|danger|warning. status=system has no statusIcon; other statuses use EV filled icons at 32px. Shell fills bottom→top: `color/elevation/inverse-3` (base) + `color/background-surface/brand` @ ~48% (overlay). Title `text/on-color` / description `text/on-color-disabled`. Action: Button outline/sm with `text/on-color`. React mapping: Alert(status, title, description, showDescription, showAction, actionLabel).

### Variants

- **status:** system | info | success | danger | warning

### Props

| Prop | Tipo / valores |
|---|---|
| `status` | system \| info \| success \| danger \| warning |
| `title` | TEXT — alert heading |
| `description` | TEXT — supporting copy |
| `showDescription` | boolean — default true |
| `showAction` | boolean — default true |
| `actionLabel` | React — nested action Button label (Figma: Button.label) |

### Rules

- **intentionalSparse:** status=system publishes no statusIcon
- **darkOverlay:** shell fills bottom→top — `color/elevation/inverse-3` (base, opacity 1) + `color/background-surface/brand` @ ~48% (overlay). Do not reverse the stack.
- **iconSize:** statusIcon FIXED 32×32 on info|success|danger|warning
- **iconFillParity:** prefer `feedback/{status}` on `{icon}-path`. success already OK; info|danger|warning still use `color/background-feedback-primary/*` on `Vector` — align when convenient
- **actionLabel:** React-side; in Figma set nested action Button label when showAction=true
- **vsToast:** Do not use as Toast — Alert is persistent in-flow; Toast is transient
- **vsBanner:** Do not use as Banner — Banner is full-width feedback-primary surface
- **vsModal:** Do not use as Modal / AlertDialog
- **usage:** Do not use as Toast, Banner, Modal, or inline field validation

### Token rules

- `color/elevation/inverse-3` (base) + `color/background-surface/brand` @ ~48% (overlay)
- `text/on-color` (title); `text/on-color-disabled` (description)
- `border/radius/400`
- `spacing/100` | `150` | `250`
- statusIcon 32: success → `feedback/success`; info|danger|warning → prefer `feedback/*`
- action outline stroke/label `text/on-color`

### Accessibility

role=status for system|info|success; role=alert for urgent warning|danger; action accessible name; decorative statusIcon aria-hidden when title conveys status.

### Composition

statusIcon 32 filled EV (omitted on system), content → text (title + description) + action (Button outline/sm)

---

## Banner

**Node ID:** `3098:2629`

AI-READY COMPONENT: Banner provides contextual inline feedback at page, section, card, form or flow level. Use status=success for positive confirmation, status=warning for attention or risk, status=info for neutral information and status=danger for destructive, critical or error feedback. Do not use Banner as toast, modal, blocking dialog, promotional hero, tag, chip or primary CTA.

### Variants

- **status:** success | warning | info | danger

### Props

| Prop | Tipo / valores |
|---|---|
| `status` | success \| warning \| info \| danger |
| `showIcon` | boolean |
| `message` | main feedback message |
| `showAction` | boolean |
| `action` | optional secondary action |

### Status map

| Status | Ãcone | Background token |
|---|---|---|
| success | `check-outline` | `color/background-feedback-primary/success` |
| warning | `alert-triangle-outline` | `color/background-feedback-primary/warning` |
| info | `info-circle-outline` | `feedback/info` |
| danger | `alert-circle-outline` | `color/background-feedback-primary/danger` |

### Feedback tokens

- **layer:** bg-primary
- **pattern:** color/background-feedback-primary/{status}
- **textOnFill:** text/primary

### Accessibility

Use role=status for success and info. Use role=alert only for urgent warning or danger messages. The optional action should remain secondary.

---

## BottomSheet

**Node ID:** `3181:8289`

AI-READY COMPONENT: BottomSheet is a temporary bottom-anchored surface for mobile or responsive experiences. Use it for contextual content that supports a task without navigating away. Do not use it as a centered modal, side drawer, toast, tooltip, card, full page or permanent layout container. Variant rule: `header=none` shows dragHandle + slot only; `header=sheet-header` nests local BottomSheetHeader (compact `headingContent` title, optional leading options/action, optional close) above sheetContent/slot. Compose guideline/checklist rows with BottomSheetCheckItem in slot / sheetContent (preferredValues) — not Checkbox, not ModalCheckItem. Do not nest AppHeader or ModalHeader inside BottomSheet.

### Variants

- **header:** none | sheet-header

### Props

| Prop | Tipo / valores |
|---|---|
| `slot` | SLOT — main content; preferredValues include BottomSheetCheckItem for guideline rows |
| `header` | none \| sheet-header |

### Rules

- **headerComposition:** `header=sheet-header` nests BottomSheetHeader — not AppHeader
- **vsAppHeader:** Do not nest AppHeader in BottomSheet
- **slotCheckItems:** Optional guideline stacks in slot / sheetContent compose BottomSheetCheckItem rows (not Checkbox, not ModalCheckItem)

### Composition

- BottomSheetHeader (when `header=sheet-header`)
- BottomSheetCheckItem (optional guideline rows in slot / sheetContent)
- dragHandle (`header=none`)
- slot / sheetContent

### Accessibility

Modal usage should block background interaction, trap focus, support Escape to close and restore focus to the trigger. Non-modal usage should use an appropriate region semantic when needed.

---

## BottomSheetHeader

**Node ID:** `4307:3760`

AI-READY COMPONENT: BottomSheetHeader is the compact header used only inside BottomSheet surfaces. No inverse appearance — sheets use default surface only (`appearance` fixed to `default`). Anatomy: `leadingActions` (optional `optionsAction` + `leadingAction`) + `headingContent` (FILL with title) + `trailingActions` (`closeAction` + `trailingSlotKeeper`). Height 48. Props: `title` (TEXT, default "Label"); `showLabel` (BOOLEAN, default true); `showOptionsAction` (BOOLEAN, default false — `dots-vertical-outline`); `showLeadingAction` (BOOLEAN, default false — `arrow-left-outline`); `showCloseAction` (BOOLEAN, default true — `x-outline`). `showLabel` toggles title inside `headingContent` — the FILL slot stays so close never recenters. Typography: `body/medium/medium` + `text/primary` on `color/background-surface/0`. Padding `spacing/050`; itemSpacing `spacing/0`. `leadingActions` hugs with min width 48 when empty. Icon preferredValues: options=`dots-vertical-outline`; leading=`arrow-left-outline`; close=`x-outline`. Internal icon paths use `{icon}-path`. Do not use as AppHeader or ModalHeader. React mapping: BottomSheetHeader(title, showLabel, showOptionsAction, showLeadingAction, showCloseAction, onOptions, onAction, onClose). Code Connect is not configured.

### Variants

- **appearance:** default only (residual single-value VARIANT axis; no inverse)

### Props

| Prop | Tipo / valores |
|---|---|
| `appearance` | `default` only — residual VARIANT axis; no inverse for BottomSheet |
| `title` | TEXT — sheet heading (default `Label`) |
| `showLabel` | boolean — toggles title visibility (default true) |
| `showOptionsAction` | boolean — toggles `optionsAction` `dots-vertical-outline` (default false) |
| `showLeadingAction` | boolean — toggles `leadingAction` `arrow-left-outline` (default false) |
| `showCloseAction` | boolean — toggles `closeAction` `x-outline` (default true) |

### Rules

- **parentOnly:** Use only inside BottomSheet (`header=sheet-header`)
- **noInverse:** Do not publish `appearance=inverse` — BottomSheet headers are default surface only; `appearance` remains a single-value VARIANT axis
- **composition:** `leadingActions` + `headingContent` (FILL, always in layout) + `trailingActions` (FIXED 48 + `trailingSlotKeeper`). `showLabel` toggles `title` inside `headingContent` — do not hide the FILL slot
- **closeEdge:** `closeAction` stays on the trailing edge. Root `primaryAxisAlignItems=MIN`; `headingContent` FILL keeps `trailingActions` right when `showLabel=false` or leading is empty
- **leadingActions:** Left-side optional controls — options (menu) and leading action; both default hidden. HUG with `minWidth` 48 when empty (no absolute leading keeper)
- **iconPreferred:** Nested Button Icon preferred swaps: options→`dots-vertical-outline`; leading→`arrow-left-outline`; close→`x-outline`. Paths renamed to `{icon}-path`
- **showLabel:** `showLabel=false` hides the title while keeping leading/trailing actions
- **density:** Fixed height 48
- **closeAction:** Button text/md/primary + `x-outline`; accessible label Fechar; ABSOLUTE in `trailingActions`
- **vsAppHeader:** Do not use AppHeader inside BottomSheet — use BottomSheetHeader
- **vsModalHeader:** Do not use as ModalHeader; Modal uses ModalHeader

### Token rules

- `color/background-surface/0` only (no inverse)
- `text/primary`
- `body/medium/medium`
- `spacing/050` horizontal pad
- `spacing/0` root itemSpacing
- nested Button tokens; `dots-vertical-outline`; `arrow-left-outline`; `x-outline`

### Composition

- Button
- dots-vertical-outline
- arrow-left-outline
- x-outline

### Accessibility

Sheet owns dialog/sheet semantics; title via aria-labelledby when `showLabel=true`; options/leading/close icon-only buttons need accessible names (Opções / Ação / Fechar).

---

## Button

**Node ID:** `3104:3723`

AI-READY COMPONENT: Button triggers an explicit user action. Use variant=solid for the strongest action, variant=outline for secondary emphasis and variant=text for low-emphasis actions. Use intent=primary, success, danger or secondary to communicate action meaning. intent=secondary maps to color/actions/secondary (lavender) for brand-accent CTAs such as Painel "Convidar"; the secondary matrix is intentionally sparse (solid/md key states). Icon-only actions use showLabel=false with showIcon=true (header search/bell on inverse surfaces). On variant=text with intent=primary and disabled=false, showIcon (leadingIcon) uses text/primary across states so the icon matches the label. Loading variants are spinner-only and must hide label and icons.

### Variants

- **variant:** solid | outline | text
- **size:** sm | md | lg
- **state:** default | hover | focus | pressed | selected | loading
- **intent:** primary | success | danger | secondary
- **disabled:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `showIcon` | boolean — toggles leadingIcon visibility |
| `label` | visible button label |
| `showTrailingIcon` | boolean |
| `showLabel` | boolean |
| `Icon` | local DS icon instance swap for leadingIcon |
| `loading` | boolean |
| `disabled` | boolean |

### Product theme (`product-theme`)

Modes: `escritorio-virtual` | `site-loovi` | `app-cliente`

| Token | Bind | escritorio-virtual | site-loovi | app-cliente |
|---|---|---|---|---|
| `component/button/container/background` | solid container fill | `color/actions/primary` | `color/background-feedback-primary/success` | `color/actions/primary` |
| `component/button/container/radius/lg` | radius size=md\|lg | `border/radius/200` | `border/radius/full` | `border/radius/full` |
| `component/button/container/radius/sm` | radius size=sm | `border/radius/150` | `border/radius/full` | `border/radius/full` |
| `component/button/label/color` | solid label | `text/on-color` | `text/primary` | `text/on-color` |
| `component/button/label/font-weight` | label weight | `font-weight/medium` | `font-weight/semi-bold` | `font-weight/medium` |
| `component/button/icon/color` | solid/outline icon | `text/on-color` | `text/primary` | `text/on-color` |

### Rules

- **leadingIconSizing:**
  - lg: 24px icon with 2px stroke
  - md: 20px icon with 1.67px stroke
  - sm: 16px icon with 1.33px stroke
- **textPrimaryIcon:** variant=text + intent=primary + disabled=false: leadingIcon (showIcon) uses text/primary across default|hover|focus|pressed|selected|loading
- **loading:** spinner-only, no label, no leading icon, no trailing icon, centered spinner
- **productTheme:** mode-aware via `product-theme`; bind solid container/label/icon/radius to `component/button/*` — do not hardcode product fills or pill radii

### Token rules

- `product-theme component/button/container/background`
- `product-theme component/button/container/radius/lg`
- `product-theme component/button/container/radius/sm`
- `component/button/icon/color` for solid/outline icon colors where bound
- `text/primary` for variant=text + intent=primary leadingIcon (enabled)
- `component/button/label/color`
- `component/button/label/font-weight`

### Feedback tokens

- **content:** feedback/{success|danger} for intent labels
- **bgSecondary:** color/background-feedback-secondary/success for subtle success emphasis
- **border:** color/border-feedback/{success|danger} for outline intents
- **interactiveSurface:** interactive/error-surface | interactive/success-surface for validation contexts

### Accessibility

Buttons must support keyboard activation, visible focus and disabled semantics. Loading actions should prevent duplicate activation and expose busy state in implementation.

---

## Checkbox

**Node ID:** `3193:5027`

AI-READY COMPONENT: Checkbox is a form selection control for binary, multi-select or partially selected choices. Use checked=mixed only when a parent item represents partial selection of child items. Do not use Checkbox as a button, radio, switch, chip, badge, navigation item or visual-only status indicator.

### Variants

- **state:** default | focus | disabled
- **checked:** false | true | mixed

### Props

| Prop | Tipo / valores |
|---|---|
| `label` | primary option text |
| `showLabel` | boolean |
| `description` | supporting text |
| `showDescription` | boolean |
| `showContent` | boolean |
| `state` | default \| focus \| disabled |
| `checked` | false \| true \| mixed |

### Icon map

- **checked=true** → `check-outline`
- **checked=mixed** → `minus-outline`

### Token rules

- `text/primary`
- `text/secondary`
- `text/placeholder`
- `color/actions/primary`
- `color/border-feedback/primary`
- `color/border/2`
- `interactive/focus`

### Feedback tokens

- **border:** color/border-feedback/primary for checked selection accent

### Accessibility

Map to input type=checkbox or role=checkbox with aria-checked. Use aria-checked=mixed for partial selection. Space toggles the value.


## ChipTag

**Node ID:** `3653:23220`

AI-READY COMPONENT: ChipTag is a compact non-interactive label used to display category, status, metadata or contextual classification. Use intent=info, system, success, warning or danger for semantic status tags, and intent=outline for neutral outlined tags. Use emphasis=strong (default) for saturated feedback-primary fills and emphasis=soft for low-contrast status pills on cards (Painel vehicle "Ativo" — fill uses color/background-feedback-secondary/{intent} where available). Soft matrix is intentionally sparse today for intent=success + state=default. Do not use ChipTag as a button, selectable filter, removable chip, navigation tab, checkbox, badge, alert or CTA. For interactive chips (including "Adicionar veÃ­culo"), use ChipClickable.

### Variants

- **size:** sm | md
- **intent:** info | system | success | warning | danger | outline
- **width:** hug | fill
- **state:** default | disabled
- **emphasis:** strong | soft

### Props

| Prop | Tipo / valores |
|---|---|
| `showAvatar` | boolean |
| `leadingIcon` | local DS icon swap |
| `showLeadingIcon` | boolean |
| `label` | visible chip label |
| `size` | sm \| md |
| `intent` | info \| system \| success \| warning \| danger \| outline |
| `width` | hug \| fill |
| `state` | default \| disabled |
| `emphasis` | strong \| soft |

### Rules

- **disabled:** disabled is state=disabled only; never intent=disabled. Disabled exemplars exist for intent=system (matches ChipClickable pattern).
- **nonInteractive:** ChipTag must not receive focus or onClick; use ChipClickable for interaction.
- **softStatus:** emphasis=soft + intent=success + showLeadingIcon for vehicle/policy active status on light cards; do not use Badge as a status label.

### Token rules

- `color/background-feedback-primary/{intent}` for emphasis=strong fills
- `color/background-feedback-secondary/{intent}` for emphasis=soft fills (success/warning/danger)
- `color/border/2` for outline stroke and disabled fill
- `text/primary` for label on saturated fills
- `text/secondary` for muted icon/label on outline and disabled
- `feedback/success` for soft leading status indicator when applicable
- `border/radius/full`
- `spacing/*`
- `border/width/012`
- `border/radius/0`

### Feedback tokens

- **layer:** bg-primary (strong) | bg-secondary (soft)
- **pattern:** color/background-feedback-primary/{intent} | color/background-feedback-secondary/{intent}
- **textOnFill:** text/primary
- **outlineBorder:** color/border/2
- **mutedContent:** text/secondary

### Accessibility

ChipTag is not interactive by default, should not receive focus and should not use onClick. If decorative, it may be aria-hidden. If it communicates important status or metadata, ensure the label is exposed to assistive technologies.

---
---

## ChipClickable

**Node ID:** `3653:23577`

AI-READY COMPONENT: ChipClickable is a compact interactive chip used for selectable filters, compact options, removable selections, or contextual actions with low visual emphasis. Usage rule: use ChipClickable when a compact item can be clicked, selected, or removed. Do not use it as a primary button, badge, static tag, checkbox, radio, menu item, alert, or navigation tab. Variant rule: size=sm|md; state=default|hover|pressed|selected|disabled (disabled intentional sparse); intent=info|system|success|warning|danger|outline|soft; width=hug|fill. Intent rule: feedback intents use feedback surfaces; outline is stroke-only on default; **intent=soft** is the soft actionable chip (Painel "Adicionar veÃ­culo"): default `color/background-surface/2` + `color/border/2`; hover/pressed/selected use `interactive/hover|pressed|selected`; exemplar: showLeadingIcon=true (circle-plus-outline/plus-outline), showAvatar=false, showDeleteAction=false — never ChipTag. Label TEXT prop wired on all published variants (including soft). Label typography: local `body/small/medium` (no remote typography). React mapping: ChipClickable(size, state, intent, width, label, showLeadingIcon, leadingIcon, showAvatar, showDeleteAction).

### Variants

- **size:** sm | md
- **state:** default | hover | pressed | selected | disabled
- **intent:** info | system | success | warning | danger | outline | soft
- **width:** hug | fill

### Props

| Prop | Tipo / valores |
|---|---|
| `showAvatar` | boolean |
| `showDeleteAction` | boolean |
| `label` | TEXT — visible chip label |
| `leadingIcon` | INSTANCE_SWAP — local DS icon |
| `showLeadingIcon` | boolean |
| `size` | sm \| md |
| `state` | default \| hover \| pressed \| selected \| disabled (sparse) |
| `intent` | info \| system \| success \| warning \| danger \| outline \| soft |
| `width` | hug \| fill |

### Rules

- **softIntent:** `intent=soft` default = `color/background-surface/2` + `color/border/2`; interaction = `interactive/hover|pressed|selected`
- **outlineVsSoft:** outline = stroke-only default; soft = surface/2 fill + border
- **painelAdicionarVeiculo:** use `intent=soft` (not ChipTag); leading plus; no avatar/delete
- **softSparse:** soft publishes 16 variants (same sparse as outline — no disabled)
- **labelProp:** TEXT prop `label` wired on all published variants including soft
- **labelTypography:** local `body/small/medium` — no remote typography binds

### Token rules

- feedback intents: `color/background-feedback-primary/{intent}` (danger may use `interactive/error-surface`)
- outline default: `color/border/2` stroke only
- soft default: `color/background-surface/2` + `color/border/2`
- soft/outline interaction: `interactive/hover` \| `pressed` \| `selected`
- `text/primary` on label; text style `body/small/medium`
- `border/radius/full`; gaps/pads `spacing/050|100|150`

### Accessibility

Use a button semantic for actions or a toggle button with aria-pressed for selectable chips. Removable chips need a delete action with an accessible name such as Remove {label}.

---

## ChipGroup

**Node ID:** `3437:3023`

AI-READY COMPONENT: ChipGroup is a layout composition that displays a set of local ChipClickable chips for input, assistive, filter or suggestion patterns. Use layout=single-row-scrollable for a horizontally scrollable row and layout=multi-row-wrap for wrapping rows. Composition: nest only local S2 ChipClickable instances — do not use remote Material chips, detached frames or custom chip visuals. Intentional ChipClickable mapping: all ChipGroup types use ChipClickable intent=outline, size=sm, width=hug; type=filter demos selected state (state=selected); input, assistive and suggestion demos state=default. Prefer showAvatar=false and showDeleteAction=false unless the specific pattern requires them. Do not use ChipGroup as a single ChipClickable, ChipTag, Button group, Tab list, checkbox group or radio group. Accessibility: provide an accessible group label in product UI; each chip must be keyboard reachable; use Enter/Space to activate or toggle; selected filter chips must expose selected/pressed state programmatically. Token rule: ChipGroup layout uses local DS spacing tokens for gaps; nested chips own ChipClickable tokens (including outline intent surfaces/borders). React mapping: ChipGroup(type, layout, children as ChipClickable[]).

### Variants

- **type:** input | assistive | filter | suggestion
- **layout:** single-row-scrollable | multi-row-wrap

### Props

| Prop | Tipo / valores |
|---|---|
| `type` | input \| assistive \| filter \| suggestion |
| `layout` | single-row-scrollable \| multi-row-wrap |

### Rules

- **composition:** local ChipClickable instances only (`chip01`–`chip09` demos)
- **chipMapping:** all types → ChipClickable `intent=outline`, `size=sm`, `width=hug`
- **filterSelected:** `type=filter` demos `state=selected`; other types `state=default`
- **defaults:** `showAvatar=false`, `showDeleteAction=false` unless pattern requires
- **vsSingle:** Do not use as a single chip — use ChipClickable or ChipTag

### Token rules

- ChipGroup gaps/padding: local `spacing/*` tokens
- nested ChipClickable owns outline intent surface/border tokens

### Accessibility

accessible group label; chips keyboard reachable; Enter/Space activate/toggle; selected filters expose selected state.

---

## LoadingSpinner

**Node ID:** `3062:745`

AI-READY COMPONENT: LoadingSpinner communicates an indeterminate loading state. Use it for asynchronous actions, sections, cards, pages, lists, forms or buttons when progress percentage is unknown. Do not use it as a button, link, navigation item or measurable progress indicator.

### Variants

- **size:** sm | md | lg

### Props

| Prop | Tipo / valores |
|---|---|
| `size` | sm \| md \| lg |

### Accessibility

Use role=status and aria-live=polite when the spinner is the only loading announcement. Use aria-hidden=true when visible loading text already exists.

---

## SectionHeader

**Node ID:** `4235:406`

AI-READY COMPONENT: SectionHeader — section title row that segments content groups on a screen, with an optional trailing action. Props: emphasis=primary|secondary; showAction=false|true; title (TEXT, default "Title"). Use emphasis=primary for main page sections (body/large/semi-bold + text/primary). Use emphasis=secondary for less prominent sections, nested groups, overlays, sheets, and secondary surfaces (body/medium/regular + text/secondary). Anatomy: title; when showAction=true, trailing action (local Button variant=text size=sm intent=primary, exposed; showLabel=false, showIcon=true, default icon arrow-narrow-right-outline). On emphasis=secondary, action icon stroke uses text/secondary to match the muted title. Use showAction=false when the section content fits the viewport (e.g. quick-access grid). Use showAction=true for overflow / see-more (e.g. offers carousel). Tokens: primary — text/primary + body/large/semi-bold; secondary — text/secondary + body/medium/regular; spacing/0 (pad/gap); root horizontal SPACE_BETWEEN when showAction=true. Product-theme: action chip binds component/section-header/action/background + radius. Do not use as AppHeader, OrganizationHeader, SystemHeader, or as a full Section with content slot — body content is composed separately below. Accessibility: title is the section heading (primary often higher heading level than secondary); action needs an accessible name (aria-label) when icon-only. React mapping: SectionHeader(emphasis, title, showAction, onActionPress). Code Connect is not configured.

### Variants

- **emphasis:** primary | secondary
- **showAction:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `emphasis` | primary \| secondary — primary: seções principais; secondary: overlays / grupos menos relevantes |
| `title` | TEXT — default `Title` |
| `showAction` | false \| true |
| `action` | Exposed Button text/sm/primary (icon-only) when `showAction=true`; secondary: ícone `text/secondary` |

### Token rules

- `emphasis=primary`: `text/primary` + `body/large/semi-bold`
- `emphasis=secondary`: `text/secondary` + `body/medium/regular`
- `emphasis=secondary` + action: icon stroke `text/secondary`
- `spacing/0` (pad/gap)
- Nested Button text/sm/primary tokens (action chrome)

### Accessibility

Title is the section heading (primary often higher heading level than secondary); icon-only action needs an accessible name (aria-label).

---

## SystemHeader

**Node ID:** `3143:8933`

AI-READY COMPONENT: SystemHeader is a web-only header for systems, dashboards, backoffices, admin panels, and internal product pages. Use appearance=default on light surfaces and appearance=inverse on dark/inverse surfaces. Use variant=default when the page needs title, primary action, slot, profile, notifications, and auxiliary actions. Use variant=simple for a compact header with fewer visible actions. SystemHeader should generally fill the container width in web layouts. Default height is 72px; simple height is 64px. Do not use SystemHeader as a marketing site header, hero, card header, table header, modal header, or mobile app header. Use AppHeader for app/top bar contexts. Internal structure: leadingContent contains headingContent, datePickerGroup, and primaryAction. slot is the optional custom control area. trailingContent contains profileMenu, secondaryAction, tertiaryAction, and notificationAction — trailingContent exists only on variant=default (intentional sparse: variant=simple has leadingContent + slot only). datePickerGroup composes local DatePickerSelect (format=month-year). Visibility is bound to showDatePicker. datePickerSelect instance is exposed so month/year values can be edited from the parent properties panel. slot replaces the previous showCustomSlot boolean naming. In React, map visible custom controls as slot or children. Actions: primaryAction visibility → showPrimaryAction; secondaryAction → showSecondaryAction; tertiaryAction → showTertiaryAction; notificationAction → showNotificationAction. secondary/tertiary/notification stay in trailingContent (variant=default only). Icons: local DS only. primaryAction is label-only by default (plus-outline available via nested Button showIcon); secondary/tertiary default plus-outline; notificationAction bell-outline. appearance=default: fill color/background-surface/0; stroke color/border/2; title text/primary; description text/secondary. appearance=inverse: fill color/background-surface/inverse-3; stroke color/border/1; title/userName/actions text/on-color; description text/on-color-disabled; DatePickerSelect unit texts/icons on-color. Exposed nested: headingContent (TextHeader → title, description, showDescription); profileMenu (userName, showUserName, Avatar); datePickerSelect (DatePickerSelect format/state + nested values). Accessibility: title maps to h1 when page title; notificationAction aria-label="NotificaÃ§Ãµes"; profileMenu menu semantics; datePickerGroup accessible label; inverse must keep AA contrast. Responsive: on narrower widths, collapse tertiary then secondary before notification/profile; title truncates rather than wraps. Token rule: local S2 kebab-case semantic only. React mapping: SystemHeader(appearance, variant, title, description, showDescription, slot, showPrimaryAction, showSecondaryAction, showTertiaryAction, showNotificationAction, showProfileMenu, showDatePicker, userName, showUserName). Code Connect is not configured.

### Variants

- **appearance:** default | inverse
- **variant:** default | simple

### Props

| Prop | Tipo / valores |
|---|---|
| `appearance` | default \| inverse — inverse for dark/on-color surfaces |
| `variant` | default \| simple — simple omits trailingContent (intentional sparse) |
| `showPrimaryAction` | boolean — toggles `primaryAction` visibility (wired) |
| `showSecondaryAction` | boolean — `variant=default` trailing only |
| `showTertiaryAction` | boolean — `variant=default` trailing only |
| `showNotificationAction` | boolean — `variant=default` trailing only |
| `showProfileMenu` | boolean — `variant=default` trailing only |
| `showDatePicker` | boolean — toggles `datePickerGroup` |
| `slot` | SLOT — optional compact custom control area (not page-level layout) |
| `title` | TEXT via exposed `headingContent` (TextHeader) |
| `description` | TEXT via exposed `headingContent` |
| `showDescription` | boolean via exposed `headingContent` |
| `userName` | TEXT via exposed `profileMenu` (`variant=default`) |
| `showUserName` | boolean via exposed `profileMenu` (`variant=default`) |

### Rules

- **webSystemsOnly:** Web/system header for dashboards/admin — not marketing, modal, table, or mobile AppHeader
- **simpleSparseTrailing:** `variant=simple` has `leadingContent` + `slot` only — no `trailingContent`; trailing `show*` props apply to `variant=default`
- **primaryActionWired:** `showPrimaryAction` binds `primaryAction.visible` on all variants
- **datePickerSelectExposed:** `datePickerSelect` exposed; `format=month-year`; `showDatePicker` toggles `datePickerGroup`
- **slotCompact:** `slot` is compact controls only — not page-level layout; replaces `showCustomSlot` naming
- **iconsLocalOnly:** Local DS icons only; primary label-only by default; secondary/tertiary `plus-outline`; notification `bell-outline`

### Token rules

- default: `color/background-surface/0`; `color/border/2`; `text/primary|secondary`
- inverse: `color/background-surface/inverse-3`; `color/border/1`; `text/on-color|on-color-disabled`
- DatePickerSelect inherits block tokens; inverse unit text `text/on-color`
- heights: default 72px; simple 64px
- local S2 kebab-case semantic only

### Accessibility

title maps to h1 when page title; notificationAction aria-label NotificaÃ§Ãµes; profileMenu menu semantics; datePickerGroup accessible label; inverse must keep AA contrast; actions need accessible names and visible focus.

### Composition

- TextHeader (`headingContent`, exposed)
- DatePickerSelect (`datePickerSelect`, exposed; `format=month-year`)
- Button (`primaryAction` / `secondaryAction` / `tertiaryAction` / `notificationAction`)
- Profile menu (exposed) + Avatar
- plus-outline / bell-outline

---

## OrganizationHeader

**Node ID:** `3644:2`

AI-READY COMPONENT: OrganizationHeader is a documentation and library organization header for Design System pages, component catalogs, foundation pages, governance pages, and internal DS artifacts. Use it to identify the owning project or DS, the page or component title, optional maturity/type metadata, optional supporting description, and an optional informational ChipTag. Do not use OrganizationHeader as an application top bar, navigation header, dashboard header, marketing hero, card header, modal header, table header, or mobile app header. Use AppHeader for app navigation and SystemHeader for web systems, dashboards, backoffices, and admin products. Props: project controls the source or owning DS name; title controls the main heading; type controls optional secondary title metadata; description controls supporting guidance; showProject, showType, showDescription, and showLabel control visibility. Composition: headingGroup contains project and titleRow; titleRow contains title and type; descriptionSlot wraps description so supporting copy fills the content width and wraps as the header resizes (root height hugs); labelTag is the local ChipTag nested instance and remains exposed for its label and intent properties. Icons inside labelTag must use the local DS icon library only (e.g. circle-check-outline), not remote/external libraries. Token rule: use existing local DS tokens only — color/background-surface/0, color/border/1, text/link, text/primary, text/secondary, spacing/0|200|600|1200, border/radius/0|800, border/width/0|012, and existing typography styles. Accessibility: title should map to the page h1 when it identifies the documented artifact. Project should render as a link only when it has a real destination; otherwise expose it as metadata, not as a fake link. Type, description, and ChipTag are informational and must not receive focus. Keep heading hierarchy outside the component consistent with the documentation page. Responsive rule: the component may resize horizontally; descriptionSlot/description should fill and wrap; root height should hug visible content. React mapping: OrganizationHeader(project, title, type, description, showProject, showType, showDescription, showLabel, label). label maps to optional ChipTag props such as text, intent, leadingIcon and showLeadingIcon; labelTag is only the internal Figma layer name.

### Props

| Prop | Tipo / valores |
|---|---|
| `project` | owning DS / project name |
| `title` | main documentation heading |
| `type` | optional secondary title metadata (e.g. maturity) |
| `description` | supporting guidance text |
| `showProject` | boolean — default true |
| `showType` | boolean — default false |
| `showDescription` | boolean — default true |
| `showLabel` | boolean — default false; toggles ChipTag `labelTag` |

### Rules

- **docsOnly:** Figma/library documentation header — not product app chrome
- **vsAppHeader:** Do not use as application navigation header — use AppHeader
- **vsSystemHeader:** Do not use as dashboard/admin header — use SystemHeader
- **composition:** headingGroup + descriptionSlot(description) + labelTag (ChipTag exposed)
- **descriptionSlot:** FILL width + wrap; visibility bound to showDescription
- **iconsLocalOnly:** ChipTag leadingIcon must be local DS (`circle-check-outline`)

### Token rules

- `color/background-surface/0`, `color/border/1`
- `text/link | primary | secondary`
- `spacing/0 | 200 | 600 | 1200`
- `border/radius/0 | 800`, `border/width/0 | 012`
- typography: `body/large/*`, `display/large/*`

### Icon rules

Use local DS outline icons only inside `labelTag`; do not use remote/external icon libraries.

### Accessibility

title maps to page h1 when identifying the artifact; project is a link only with a real destination; type/description/ChipTag informational (no focus).

---

## CommentItem

**Node ID:** `3653:340`

AI-READY COMPONENT: CommentItem is an internal Figma-only annotation used to add contextual comments, notes, questions, alignment points, usability-test notes, developer specs, checks and design decisions inside the design system file. Do not use CommentItem as product UI, app chrome, Toast, Banner, Tooltip, Card or any user-facing component. Do not map to React, Code Connect or production code. Variants: placement=right|left|top|bottom controls callout arrow side; category selects the annotation type. Intentional composition split: category=generic uses header (leadingIcon + title) plus description — title, showIcon and leadingIcon props apply only here; all other categories use categoryTag (local DS categoryIcon + categoryLabel) plus description, without title. Props: description (all categories); title, showIcon, leadingIcon (generic only). Category icons must remain local DS outline icons (eye, test-pipe, code, heart-handshake, adjustments, help-circle, bulb, circle-check, message-circle). Token rule: use existing local DS kebab-case variables only — color/background-surface/0|2|3, color/border/1, text/primary|secondary, spacing/0|050|100|150, border/radius/100, border/width/012, color/elevation/pressed (effect). Accessibility: Figma-only organizer with no runtime a11y role; product headings/notes must be implemented separately in product UI. React mapping: none — Figma organizer only.

### Variants

- **placement:** right | left | top | bottom
- **category:** generic | psc | usability-test | dev-specs | alignment | adjustment | open-question | note-idea | check

### Props

| Prop | Tipo / valores |
|---|---|
| `placement` | right \| left \| top \| bottom |
| `category` | generic \| psc \| usability-test \| dev-specs \| alignment \| adjustment \| open-question \| note-idea \| check |
| `description` | annotation body — all categories |
| `title` | short title — generic only |
| `showIcon` | boolean — generic only |
| `leadingIcon` | INSTANCE_SWAP local DS icon — generic only |

### Rules

- **figmaOnly:** Figma annotation organizer — no React/Code Connect/product UI
- **compositionIntentional:** generic = header(leadingIcon+title)+description; other categories = categoryTag+description (no title)
- **propsScope:** title/showIcon/leadingIcon apply only to category=generic
- **iconsLocalOnly:** categoryIcon and leadingIcon must be local DS outline icons

### Category icon map

- **generic:** message-circle-outline (via leadingIcon)
- **psc:** eye-outline
- **usability-test:** test-pipe-outline
- **dev-specs:** code-outline
- **alignment:** heart-handshake-outline
- **adjustment:** adjustments-outline
- **open-question:** help-circle-outline
- **note-idea:** bulb-outline
- **check:** circle-check-outline

### Token rules

- `color/background-surface/0 | 2 | 3`, `color/border/1`
- `text/primary | secondary`
- `spacing/0 | 050 | 100 | 150`, `border/radius/100`, `border/width/012`
- `color/elevation/pressed` (effect)

### Accessibility

Figma-only organizer — no runtime a11y role; implement product notes separately in product UI.

---

## DividerHorizontal

**Node ID:** `3298:1409`

AI-READY COMPONENT: DividerHorizontal is a non-interactive horizontal separator used to visually separate sections, groups or content blocks. Use variant=full-width for edge-to-edge separation, variant=inset when the divider should align with content padding, variant=middle-inset for compact nested layouts and variant=with-subhead when the separator needs a small section label. Do not use DividerHorizontal as a button, navigation item, progress indicator, generic border replacement or layout container.

### Variants

- **variant:** full-width | inset | middle-inset | with-subhead

### Props

| Prop | Tipo / valores |
|---|---|
| `variant` | full-width \| inset \| middle-inset \| with-subhead |
| `label` | optional section label for with-subhead |

### Rules

- **nonInteractive:** DividerHorizontal does not receive focus and does not have onClick.
- **label:** label is used only with variant=with-subhead; contextual text, not an interactive control.

### Token rules

- `color/border/2` for dividerLine stroke
- `text/on-color-disabled` for with-subhead label
- `spacing/250` for inset and middle-inset padding
- `spacing/050` for with-subhead gap

### Accessibility

If purely visual, hide from assistive technology. If it separates meaningful regions, expose separator semantics. When variant=with-subhead is used, the label should be contextual text, not an interactive control.

---

## DividerVertical

**Node ID:** `3298:1419`

AI-READY COMPONENT: DividerVertical is a non-interactive vertical separator used to visually separate adjacent content, columns, actions or grouped controls. Use variant=full-width for edge-to-edge separation, variant=inset when the divider should align with container padding and variant=middle-inset for compact nested layouts. Do not use DividerVertical as a border, progress indicator, decorative line, button, navigation item or layout container.

### Variants

- **variant:** full-width | inset | middle-inset

### Props

| Prop | Tipo / valores |
|---|---|
| `variant` | full-width \| inset \| middle-inset |

### Rules

- **nonInteractive:** DividerVertical must not receive focus or onClick.
- **noSubhead:** Unlike DividerHorizontal, DividerVertical has no with-subhead variant.

### Token rules

- `color/border/2` for dividerLine stroke
- `border/width/012` for stroke weight
- `spacing/200` for inset and middle-inset vertical padding
- `spacing/0` for full-width padding

### Accessibility

If purely visual, hide with aria-hidden=true. If it separates meaningful regions, expose role=separator with aria-orientation=vertical.

---

## FileUploader

**Node ID:** `3581:4454`

AI-READY COMPONENT: FileUploader is the full file-upload field composition used to label a file input, show helper guidance, trigger selection, optionally present a drag-and-drop surface, and list selected files. Use variant=default for a Button-triggered picker and variant=drag-and-drop when the FileUploaderDropzoneItem dropzone is the primary capture surface. Use size=lg|md|sm to control nested FileUploaderItem density and the nested Button size (solid primary maps 1:1). Use state=default for the interactive field, state=disabled to block selection/drop/remove, and state=skeleton as a non-interactive loading placeholder made of bones only (labelSkeleton, descriptionSkeleton, actionSkeleton) — no nested Button, FileUploaderDropzoneItem, or FileUploaderList instances inside skeleton. Props: label and description control the field header texts; showFiles toggles the FileUploaderList — intentional: showFiles is only wired on state=default; disabled and skeleton hard-hide or omit the file list. Composition (non-skeleton): header (label + description) + local Button uploadAction + local FileUploaderDropzoneItem uploadDropzone + local FileUploaderList fileList. Do not use FileUploader as FileUploaderDropzoneItem alone, FileUploaderItem, FileUploaderList, UploadPhotos, Button, Card, TextInput or ProgressBar. Status of individual files belongs to FileUploaderItem. Accessibility: implement with a native input type=file; uploadAction / dropzone must open the picker; Enter/Space activate; associate label and description with the input; disabled prevents selecting, dropping and removing; skeleton is non-interactive. Token rule: use existing DS kebab-case variables — spacing/100|200, border/radius/200, border/width/012, interactive/disabled-surface (skeleton root), color/background-surface/2 (skeleton bones), text/primary|secondary on header, plus nested Button/FileUploaderDropzoneItem/FileUploaderList/FileUploaderItem tokens. React mapping: FileUploader(variant, size, state, label, description, showFiles, files, onSelectFiles).

### Variants

- **variant:** default | drag-and-drop
- **size:** lg | md | sm
- **state:** default | disabled | skeleton

### Props

| Prop | Tipo / valores |
|---|---|
| `variant` | default \| drag-and-drop |
| `size` | lg \| md \| sm |
| `state` | default \| disabled \| skeleton |
| `label` | field label text |
| `description` | helper / limits / formats text |
| `showFiles` | boolean — default true; wired only on state=default (intentional) |

### Rules

- **composition:** non-skeleton: header + uploadAction + uploadDropzone + fileList; skeleton: bones only
- **vsDropzone:** Do not use as dropzone alone — use FileUploaderDropzoneItem
- **vsItem:** Do not use as a single file row — use FileUploaderItem
- **vsList:** Do not use as file list stack alone — use FileUploaderList
- **vsUploadPhotos:** Do not use for photo lifecycle task items — use UploadPhotos
- **showFilesIntentional:** showFiles wired only on state=default; disabled hard-hides fileList; skeleton omits components
- **buttonMatrix:** uploadAction = solid/primary; size maps 1:1; showIcon=true with upload-outline
- **skeletonBonesOnly:** no nested Button/FileUploaderDropzoneItem/FileUploaderList instances in state=skeleton

### Variant map

- **default:** uploadAction visible; uploadDropzone hidden
- **drag-and-drop:** uploadDropzone visible; uploadAction hidden

### State map

- **default:** interactive; showFiles controls fileList
- **disabled:** Button/FileUploaderDropzoneItem disabled; fileList hard-hidden (intentional)
- **skeleton:** non-interactive bones only — labelSkeleton + descriptionSkeleton + actionSkeleton; no nested components

### Token rules

- `spacing/100 | 200`, `border/radius/200`, `border/width/012`
- `interactive/disabled-surface` (skeleton root)
- `color/background-surface/2` (skeleton bones)
- `text/primary | secondary` (header)
- nested Button, FileUploaderDropzoneItem, FileUploaderList, FileUploaderItem own their tokens

### Accessibility

native input type=file; uploadAction/dropzone open picker; Enter/Space; associate label/description; disabled blocks select/drop/remove; skeleton non-interactive.

---

## FileUploaderDropzoneItem

**Node ID:** `3581:5628`

AI-READY COMPONENT: FileUploaderDropzoneItem is a drag-and-drop file upload dropzone block for selecting one or more files. Use it when users can drag files onto a surface or activate the surface to open the native file picker. Do not use it as a Button, Card, TextInput, ProgressBar, uploaded-file row/list item, or the full File uploader composition (label + description + file items). Variants: state=default|drag-hover|focus|disabled. disabled is a state value — there is no separate disabled boolean prop. Props: helperText (TEXT) controls the visible instruction. Composition: dropzone frame with helperText. No nested Button or file-item instances; pair with file-item components outside this block when listing uploaded files. Accessibility: map the enabled dropzone to a button-like or label/input pattern with keyboard activation via Enter/Space, visible focus, accessible name/description, and a hidden file input. During drag-over use state=drag-hover. state=disabled must not be focusable or interactive and should expose aria-disabled=true when rendered as a button-like control. Associate helperText with the upload input/dropzone. Token rule: use existing DS kebab-case variables only — color/background-surface/0, interactive/hover|focus|disabled-surface, color/border/1|2, color/border-feedback/primary, text/secondary|placeholder, spacing/0|200|300|800, border/radius/200, border/width/012|025. Dashed outline uses hardcoded dashPattern [4,3] on default|disabled (no local dash token). React mapping: FileUploaderDropzoneItem(state, helperText, onFilesSelected).

### Variants

- **state:** default | drag-hover | focus | disabled

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| drag-hover \| focus \| disabled |
| `helperText` | visible dropzone instruction text |

### Rules

- **composition:** dropzone + helperText only — no nested Button or file-item
- **disabledIsState:** disabled is a state value, not a separate boolean prop
- **strokeModel:** stroke on root; fill on dropzone; dashPattern [4,3] only on default|disabled
- **usage:** Do not use as Button, Card, TextInput, ProgressBar, or uploaded-file row

### State map

| State | Fill | Stroke | Width | Text |
|---|---|---|---|---|
| default | `color/background-surface/0` | `color/border/1` | `border/width/012` | `text/secondary` |
| drag-hover | `interactive/hover` | `color/border-feedback/primary` | `border/width/025` | `text/secondary` |
| focus | `color/background-surface/0` | `interactive/focus` | `border/width/025` | `text/secondary` |
| disabled | `interactive/disabled-surface` | `color/border/2` | `border/width/012` | `text/placeholder` |

### Token rules

- `color/background-surface/0`, `interactive/hover` | `focus` | `disabled-surface`
- `color/border/1` | `2`, `color/border-feedback/primary`, `text/secondary` | `placeholder`
- `spacing/0` | `200` | `300` | `800`, `border/radius/200`, `border/width/012` | `025`
- `dashPattern [4,3]` hardcoded leftover on default|disabled (no local dash token)

### Accessibility

button-like or label/input with Enter/Space; visible focus; hidden file input; drag-hover on drag-over; disabled not focusable (aria-disabled); associate helperText with input/dropzone.

---

## FileUploaderItem

**Node ID:** `3581:5641`

AI-READY COMPONENT: FileUploaderItem is the file row used inside a file uploader to represent an uploaded file, a loading file, a successful upload, focus state, and validation error states. Use when showing one file inside an upload list or upload confirmation area. Do not use as the drag-and-drop dropzone — use FileUploaderDropzoneItem for that. Variants: size=sm|md|lg controls vertical density and row height. state=uploaded|loading|success|focus|danger-short|danger-long. Use danger-short for one-line validation feedback and danger-long when a secondary explanation is needed. Props: fileName (visible file name), shortDescription (short validation message on danger states), longDescription (optional secondary validation detail on danger-long). Composition: uses local LoadingSpinner for loading; local DS icons for removeAction (x-outline), statusIcon on success (circle-check-filled) and danger (alert-circle-filled). Do not use imported icons or external library components. removeAction is a DS icon hit-target, not a Button instance. Accessibility: the file name must be announced by screen readers. loading should expose progress/status text in implementation (preferably aria-live=polite). success may announce completion with aria-live=polite. danger-short and danger-long should expose validation feedback with role=alert or aria-live when the error appears. removeAction must have an accessible label such as Remove file {fileName}. Decorative status icons should be aria-hidden=true when text already communicates the state. focus represents visible keyboard focus on the trailingAction/remove control. Token rule: use existing DS kebab-case variables (color/background-surface/0|1, color/border-feedback/danger, color/border/2, interactive/focus, feedback/danger|success, text/primary|secondary, spacing/*, border/radius/*, border/width/*). On danger states, errorMessage uses feedback/danger; on danger-long, errorDescription uses text/secondary. React mapping: FileUploaderItem(size, state, fileName, shortDescription, longDescription, onRemove).

### Variants

- **size:** sm | md | lg
- **state:** uploaded | loading | success | focus | danger-short | danger-long

### Props

| Prop | Tipo / valores |
|---|---|
| `size` | sm \| md \| lg — vertical density |
| `state` | uploaded \| loading \| success \| focus \| danger-short \| danger-long |
| `fileName` | visible file name |
| `shortDescription` | short validation message (danger states) |
| `longDescription` | optional secondary validation detail (danger-long) |

### Rules

- **composition:** local loadingSpinner, statusIcon, removeAction (x-outline icon hit-target)
- **vsDropzone:** Do not use as dropzone — use FileUploaderDropzoneItem
- **dangerText:** errorMessage = feedback/danger; danger-long errorDescription = text/secondary
- **focusTarget:** focus stroke on trailingAction/remove control
- **usage:** One file row in an upload list — not a Button, Card, or ProgressBar

### Token rules

- `color/background-surface/0` | `1`, `color/border-feedback/danger`, `color/border/2`
- `interactive/focus`, `feedback/danger` | `success`, `text/primary` | `secondary`
- `spacing/*`, `border/radius/*`, `border/width/*`

### Accessibility

announce fileName; loading/success aria-live=polite; danger role=alert or aria-live; removeAction accessible label; decorative status icons aria-hidden when text conveys state.

---

## FileUploaderList

**Node ID:** `3581:3887`

AI-READY COMPONENT: FileUploaderList is a vertical stack of FileUploaderItem rows used to preview or compose a list of uploaded files. Use it as a demo/composition wrapper for one or more FileUploaderItem instances. Do not use it as FileUploaderDropzoneItem (dropzone), a single FileUploaderItem, Button, Card, or ProgressBar. Composition: fileItem01–fileItem07 are local FileUploaderItem instances. fileItem01 is always present; showFileItem02–showFileItem07 toggle additional rows (defaults: 02–03 true, 04–07 false). In product code, prefer mapping an array of files to N× FileUploaderItem rather than hard-coding seven slots. This component documents spacing and stacking for the upload list pattern. Accessibility: expose the list as a list or group with an accessible name; each FileUploaderItem remains responsible for file name, status, and remove action semantics. Token rule: use existing DS kebab-case variables (spacing/100 for item gap). Nested FileUploaderItem uses its own DS tokens. React mapping: FileUploaderList(children as FileUploaderItem[]) or FileUploaderList(files.map(...)). Figma props: showFileItem02–showFileItem07.

### Props

| Prop | Tipo / valores |
|---|---|
| `showFileItem02` | boolean — default true |
| `showFileItem03` | boolean — default true |
| `showFileItem04` | boolean — default false |
| `showFileItem05` | boolean — default false |
| `showFileItem06` | boolean — default false |
| `showFileItem07` | boolean — default false |

### Rules

- **composition:** fileItem01–fileItem07 = local FileUploaderItem; fileItem01 always on
- **vsDropzone:** Do not use as dropzone — use FileUploaderDropzoneItem
- **vsItem:** Do not use as a single file row — use FileUploaderItem
- **productMapping:** Prefer N× FileUploaderItem from data; this set documents list stacking
- **deprecatedLegacy:** `_DEPRECATED FileUploaderItem legacy` (`3581:3748`) must not be used

### Token rules

- `spacing/100` for list item gap
- Nested FileUploaderItem owns its own DS tokens

### Accessibility

list/group with accessible name; each FileUploaderItem owns file name, status, and remove semantics.

---

## UploadPhotos

**Node ID:** `3581:7597`

AI-READY COMPONENT: UploadPhotos is a single photo or visual-document upload task item used to communicate a required capture and its lifecycle status. Use status=pending when no photo has been submitted, status=in-review after submission while validation is pending, status=approved after validation succeeds, and status=rejected when the photo must be replaced. status is a business lifecycle axis, not an interaction-state axis; hover, focus, pressed and disabled behavior belong to the nested Button action. Compose local DS camera icon, Button and ChipTag only. Do not use UploadPhotos as FileUploaderDropzoneItem/dropzone, FileUploaderItem, FileUploaderList, generic Card, gallery tile, image preview, Banner, Toast or the full uploader composition. Props: label controls the required photo name; description and showDescription control optional supporting guidance. Status controls the trailing affordance structurally: pending uses Button text/sm/primary with visible label and trailing chevron; in-review uses ChipTag system (no leading icon); approved uses ChipTag success; rejected uses ChipTag danger plus Button text/sm/primary with visible label and trailing chevron. Surface tokens are intentional: pending and rejected use color/background-surface/2; in-review and approved use color/background-surface/1. Token rule: use existing DS kebab-case variables — color/background-surface/1|2, text/primary|secondary, spacing/0|050|100|150|200|800, border/radius/300, font-family/base, font-weight/medium|regular, body/medium|small and caption/medium typography tokens, plus nested Button/ChipTag tokens. Accessibility: expose label and status to assistive technologies; pending and rejected actions use visible labels (Adicionar foto / Refazer foto) and must remain keyboard-accessible; in-review and approved are informational and must not receive focus unless a real action is added. React mapping: UploadPhotos(status, label, description, showDescription, onSelectPhoto, onRetakePhoto).

### Variants

- **status:** pending | in-review | approved | rejected

### Props

| Prop | Tipo / valores |
|---|---|
| `status` | pending \| in-review \| approved \| rejected |
| `label` | required photo / task name |
| `description` | optional supporting guidance text |
| `showDescription` | boolean — default false |

### Rules

- **composition:** local camera-outline + Button + ChipTag only
- **statusIsLifecycle:** status is business lifecycle, not hover/focus/pressed/disabled
- **vsDropzone:** Do not use as dropzone — use FileUploaderDropzoneItem
- **vsItem:** Do not use as uploaded-file row — use FileUploaderItem
- **vsList:** Do not use as file list stack — use FileUploaderList
- **surfaceIntentional:** pending|rejected → surface/2; in-review|approved → surface/1

### Status map

- **pending:** Button text/sm/primary — label + trailing chevron (Adicionar foto); surface/2
- **in-review:** ChipTag system — no leading icon; surface/1
- **approved:** ChipTag success; surface/1
- **rejected:** ChipTag danger + Button text/sm/primary — label + trailing chevron (Refazer foto); surface/2

### Token rules

- `color/background-surface/1 | 2` (intentional by status)
- `text/primary | secondary`
- `spacing/0 | 050 | 100 | 150 | 200 | 800`, `border/radius/300`
- `body/medium/medium` (label), `body/small/regular` (description), `caption/medium/medium` (ChipTag)
- nested Button and ChipTag own their own DS tokens

### Accessibility

expose label and status; pending/rejected actions use visible labels and stay keyboard-accessible; in-review/approved are informational (no focus unless an action is added).

---

## ImageItem

**Node ID:** `3671:2329`

AI-READY COMPONENT: ImageItem is a DS image container used to reserve a fixed aspect-ratio surface and optionally show orientation and photo-text overlays. Use `imageSurface` as the only layer for applying or replacing image fills — keep it absolute/floating, clipped, tokenized, and scaleMode FILL (crop) so the image is not distorted. Use `showOrientationItem` to toggle `orientationOverlay` (ImageOrientationItem), which must stay absolute/floating, rotation 0Â°, and centered — including when `verticalResize=true`. Use `showPhotoTextItem` to toggle `photoTextOverlay` (PhotoTextItem), which must stay absolute/floating, rotation 0Â°, and STRETCH/STRETCH so it fills the entire photo surface. `aspectRatio` controls 1-1 | 4-3 | 3-2 | 16-9 | 2-1. `orientation` controls portrait | landscape. `verticalResize=false` locks width and hugs height via aspect-ratio keepers; `verticalResize=true` locks height and hugs width (same keeper technique, rotated). `photoTextOverlay` is exposed for `label`/`supportingText`/`showSupportingText` edits. `orientationOverlay` remains informational/decorative. Do not use ImageItem as a radio, checkbox, button, tab, avatar, or gallery tile. Token rule: use existing DS kebab-case variables only — `color/background-surface/1` for root and imageSurface placeholder, plus nested ImageOrientationItem and PhotoTextItem tokens. Accessibility: treat as an image or figure; provide accessible name/alt from product content when a real image is applied; orientationOverlay is decorative/informational; photoTextOverlay label/supportingText are content and must remain readable. React mapping: ImageItem(aspectRatio, orientation, verticalResize, showOrientationItem, showPhotoTextItem, src, alt). Code Connect is not configured.

### Variants

- **aspectRatio:** 1-1 | 4-3 | 3-2 | 16-9 | 2-1
- **orientation:** portrait | landscape
- **verticalResize:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `aspectRatio` | 1-1 \| 4-3 \| 3-2 \| 16-9 \| 2-1 |
| `orientation` | portrait \| landscape |
| `verticalResize` | false \| true — false locks width/hugs height; true locks height/hugs width |
| `showOrientationItem` | boolean — toggles orientationOverlay (ImageOrientationItem) |
| `showPhotoTextItem` | boolean — toggles photoTextOverlay (PhotoTextItem); default false; absolute STRETCH/STRETCH fill |
| `photoTextOverlay` | Exposed nested PhotoTextItem (`label`, `supportingText`, `showSupportingText`) |

### Rules

- **imageSurface:** only layer for image fill replacement; absolute, clipped, STRETCH, scaleMode FILL
- **orientationOverlay:** ImageOrientationItem; absolute; rotation 0Â°; centered even when verticalResize=true
- **photoTextOverlay:** PhotoTextItem; absolute; rotation 0Â°; STRETCH/STRETCH fills entire photo; exposed
- **showPhotoTextItem:** BOOLEAN default false — wires photoTextOverlay.visible
- **verticalResizeParity:** restored Aspect ratio keeper behavior: false=FIXED×HUG; true=HUG×FIXED
- **vsControls:** Do not use as radio, checkbox, button, tab, avatar, or gallery tile
- **composition:** aspectRatioKeeper tree + imageSurface + photoTextOverlay + orientationOverlay

### Token rules

- `color/background-surface/1` for root and imageSurface placeholder
- nested ImageOrientationItem owns its own DS tokens
- nested PhotoTextItem owns `text/on-color`, `spacing/200|050`, `interactive/overlay` scrim

### Accessibility

treat as image/figure; provide accessible name/alt when a real image is applied; orientationOverlay is decorative/informational; photoTextOverlay label/supportingText are content and must remain readable.

### Composition

- `aspectRatioKeeper`
- `imageSurface`
- `photoTextOverlay` (PhotoTextItem; exposed)
- `orientationOverlay` (ImageOrientationItem)

---

## PhotoTextItem

**Node ID:** `4149:479`

AI-READY INTERNAL COMPONENT: PhotoTextItem — full-bleed text scrim overlay used inside ImageItem (and photo compositions). Props: `showSupportingText=true|false`; `label` (TEXT); `supportingText` (TEXT). Anatomy: `content` (bottom-aligned column) with `label` and optional `supportingText` over a bottom scrim. Layout: when nested in ImageItem, instance is absolute STRETCH/STRETCH so content fills the entire photo surface; keep rotation 0Â°. Tokens: `text/on-color` on texts; content padding `spacing/200`; gap `spacing/050`; scrim uses `interactive/overlay` alpha ramp (bottom-weighted). Typography: `body/medium/medium` (label), `body/small/regular` (supportingText). Do not use as ImageOrientationItem, ChipTag, Banner, or a standalone card. Accessibility: overlay text is content — ensure contrast on photo; prefer concise labels. React mapping: PhotoTextItem(showSupportingText, label, supportingText).

### Variants

- **showSupportingText:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `showSupportingText` | false \| true — toggles supportingText row |
| `label` | TEXT — primary overlay label; `body/medium/medium` + `text/on-color` |
| `supportingText` | TEXT — secondary line when `showSupportingText=true`; `body/small/regular` + `text/on-color` |

### Rules

- **internalOverlay:** Compose inside ImageItem as `photoTextOverlay` — not a standalone card
- **fullBleed:** Parent instance must be absolute STRETCH/STRETCH to fill the photo surface
- **scrim:** Bottom-weighted `interactive/overlay` alpha ramp on content
- **typography:** `body/medium/medium` (label) + `body/small/regular` (supportingText); no remote M3/Roboto
- **vsOrientation:** Not ImageOrientationItem — text scrim vs centered orientation badge

### Token rules

- `text/on-color` (label + supportingText)
- `spacing/200` (content padding)
- `spacing/050` (content gap)
- `interactive/overlay` (scrim alpha ramp)
- `body/medium/medium`; `body/small/regular`

### Accessibility

Overlay text is content — ensure contrast on photo; prefer concise labels.

### Composition

- `content` (`label` + optional `supportingText`)
- ImageItem.`photoTextOverlay` (parent)

---

## Input

**Node ID:** `3873:334`

AI-READY COMPONENT: Input is the Design System 2.0 single-line outlined text field. Visual identity: outlined container (height 56, corner radius via product-theme `component/input/field/radius`), floating label cutout on the border for content=value|placeholder, and resting in-field label for content=label — remapped from Material Text field anatomy to local S2 tokens. Variants: state=default|hover|focus|error|disabled; content=value|placeholder|label; leadingIcon=true|false; trailingIcon=true|false; appearance=default|inverse (120 variants). appearance=default: field fill color/background-surface/0; default border color/border/1; label text/secondary (focus text/brand); placeholder text/placeholder; value text/primary; leading/trailing icon strokes text/secondary (focus text/brand, disabled text/placeholder, error feedback/danger). appearance=inverse (for inverse/dark surfaces): field fill transparent; floatingLabel cutout color/background-surface/inverse-3; default/disabled border color/border/2; label text/on-color (focus text/brand); placeholder and non-error supporting text/on-color-disabled; value text/on-color; on state=disabled all field texts (value/label/placeholder/resting/supporting) use text/placeholder-inverse; leadingIcon and trailingIcon strokes text/on-color (focus text/brand, disabled text/on-color-disabled, error feedback/danger). Feedback colors are unchanged on both appearances — hover color/border-feedback/primary, focus interactive/focus, error color/border-feedback/danger + feedback/danger on label/supporting/trailingIconError. Error a11y: state=error always shows trailingIconError (alert-circle-outline) regardless of trailingIcon. Props: label, value, placeholder, supportingText, showSupportingText, leading, trailing. Do not use as Textarea, InputPassword, InputNumber, InputSelect, SearchBar or Autocomplete. Prefer explicit labels. Accessibility: associate label; aria-invalid on error; aria-describedby for supporting/error; aria-disabled when disabled; visible focus via interactive/focus. Token rule: local S2 kebab-case + product-theme `component/input/field/radius` (EV→`border/radius/200`; site-loovi|app-cliente→`border/radius/full`). React mapping: Input(state, content, leadingIcon, trailingIcon, appearance, label, value, placeholder, supportingText, showSupportingText, leading?, trailing?). Code Connect is not configured.

### Variants

- **state:** default | hover | focus | error | disabled
- **content:** value | placeholder | label
- **leadingIcon:** true | false
- **trailingIcon:** true | false
- **appearance:** default | inverse

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| hover \| focus \| error \| disabled |
| `content` | value \| placeholder \| label |
| `leadingIcon` | true \| false (variant axis) |
| `trailingIcon` | true \| false (variant axis) |
| `appearance` | default \| inverse — inverse for dark/on-color surfaces |
| `label` | TEXT — floating or resting field label |
| `value` | TEXT — input text (`content=value`) |
| `placeholder` | TEXT — placeholder text (`content=placeholder`) |
| `supportingText` | TEXT — helper or error message |
| `showSupportingText` | boolean |
| `leading` | INSTANCE_SWAP — local DS outline icon (default `search-outline`) |
| `trailing` | INSTANCE_SWAP — local DS outline icon (`x-outline`; `alert-circle-outline` on error demos) |

### Product theme (`product-theme`)

Modes: `escritorio-virtual` | `site-loovi` | `app-cliente`

| Token | Bind | escritorio-virtual | site-loovi | app-cliente |
|---|---|---|---|---|
| `component/input/field/radius` | outlined field corner radius | `border/radius/200` | `border/radius/full` | `border/radius/full` |

### Rules

- **materialMatrix:** state × content × leadingIcon × trailingIcon × appearance = 120 outlined variants
- **appearanceInverse:** `appearance=inverse`: transparent field; floatingLabel cutout `inverse-3` on all inverse states including focus; `border/2`; on-color texts; disabled texts `text/placeholder-inverse`; icon disabled `on-color-disabled`; focus label `text/brand`
- **outlinedFloatingLabel:** Outlined field h=56, corner radius via product-theme `component/input/field/radius`, floating label cutout
- **productTheme:** field radius binds `component/input/field/radius` — EV→200; site-loovi|app-cliente→full
- **focusCaret:** state=focus is active/pressed typing state; content=value|placeholder show text+caret; content=label raises floating label and shows caret only (empty focused field)
- **errorTrailingA11y:** state=error always shows trailingIconError (alert-circle-outline) regardless of trailingIcon
- **contentModes:** value=input+float label; placeholder=placeholder+float label; label=resting empty label only
- **errorPattern:** error uses danger border/label; trailingIconError + optional showSupportingText
- **hoverBorder:** state=hover field stroke uses `color/border-feedback/primary`
- **vsSearchSelect:** Do not use as Textarea, InputSelect, InputNumber, InputPassword, Input Search, Select, Checkbox or PaginationSelectInput
- **labelRequired:** Prefer explicit label — do not rely on placeholder alone

### Token rules

- default: `color/background-surface/0`; `color/border/1`; `text/primary|secondary|placeholder|brand`
- inverse: transparent field; `color/border/2`; cutout `color/background-surface/inverse-3`; `text/on-color|on-color-disabled`; disabled texts `text/placeholder-inverse`
- shared feedback: `color/border-feedback/primary|danger`, `interactive/focus`, `feedback/danger`
- `product-theme component/input/field/radius` (EV→200; site-loovi|app-cliente→full)
- `spacing/050|100|200|300|700`; `border/width/012|025`
- `body/large/regular` value/placeholder/resting; `body/small/regular` floating label/supporting

### Accessibility

Associate label; aria-invalid on error; aria-describedby for supporting/error; aria-disabled when disabled; focus via interactive/focus.

---

## InputTextArea

**Node ID:** `4052:21848`

AI-READY COMPONENT: InputTextArea is the Design System 2.0 multiline outlined text field — same visual identity as Input (outlined container, floating label cutout; corner radius via product-theme `component/input-textarea/field/radius`) with a taller field (~160), character count, and resize affordance. Use for long text (comments, descriptions, messages). Do not use as single-line Input, InputSelect, InputPassword, InputNumber, or rich-text editor. Variants use an intentional sparse matrix (42 published / 120 theoretical): state × content × leadingIcon × trailingIcon × appearance. state: default | hover | focus | error | disabled. content: value | placeholder | label. leadingIcon/trailingIcon: false | true — true only on content=value samples for default|focus|error × default|inverse. appearance: default | inverse. Anatomy: `field` (leadingIcon? + content + trailingIcon? + countRow + floatingLabel) + `supporting` + `minHeight` (InputTextAreaMinHeight, absolute, exposed; nests InputTextAreaResizeHandle). `countRow` is absolute bottom-right inside field (manual positioning, constraints MAX/MAX) — not auto-layout. `minHeight` is absolute on the field's trailing edge (manual positioning). Props: label, value, placeholder, supportingText, showSupportingText, countText, showCount, leading, trailing (INSTANCE_SWAP). Resize visibility via exposed nested `minHeight` `showResizeHandle`. Token rule: local S2 kebab-case + product-theme `component/input-textarea/field/radius` (EV→`border/radius/200`; site-loovi|app-cliente→`border/radius/500`) — focus and error field strokes use `border/width/025` (2px). React mapping: InputTextArea(state, content, leadingIcon, trailingIcon, appearance, label, value, placeholder, supportingText, showSupportingText, countText, showCount, showResizeHandle?, leading?, trailing?). Code Connect is not configured.

### Variants

- **state:** default | hover | focus | error | disabled
- **content:** value | placeholder | label
- **leadingIcon:** false | true (sparse)
- **trailingIcon:** false | true (sparse)
- **appearance:** default | inverse

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| hover \| focus \| error \| disabled |
| `content` | value \| placeholder \| label |
| `leadingIcon` | false \| true — sparse samples only |
| `trailingIcon` | false \| true — sparse samples only |
| `appearance` | default \| inverse |
| `label` | TEXT |
| `value` | TEXT |
| `placeholder` | TEXT |
| `supportingText` | TEXT |
| `showSupportingText` | BOOLEAN — wired on all states including error |
| `countText` | TEXT — e.g. `0/100` |
| `showCount` | BOOLEAN — toggles absolute `countRow` |
| `leading` / `trailing` | INSTANCE_SWAP — local DS outline |
| `showResizeHandle` | via exposed nested `minHeight` |

### Product theme (`product-theme`)

Modes: `escritorio-virtual` | `site-loovi` | `app-cliente`

| Token | Bind | escritorio-virtual | site-loovi | app-cliente |
|---|---|---|---|---|
| `component/input-textarea/field/radius` | outlined multiline field corner radius | `border/radius/200` | `border/radius/500` | `border/radius/500` |

### Rules

- **sparseMatrix:** Intentional sparse 42/120 — icon=true only on content=value × default|focus|error × default|inverse
- **absoluteCountRow:** `countRow` is ABSOLUTE bottom-right inside field (manual MAX/MAX) — intentional
- **absoluteMinHeight:** `minHeight` (InputTextAreaMinHeight) is ABSOLUTE on trailing edge — intentional; exposed
- **productTheme:** field radius binds `component/input-textarea/field/radius` — EV→200; site-loovi|app-cliente→500 (not full)
- **vsSingleLine:** Not single-line Input, InputSelect, InputPassword, InputNumber, or rich-text
- **errorStroke:** `state=focus` and `state=error` use `border/width/025` (2px); other states `border/width/012`

### Token rules

- default: `color/background-surface/0`; `color/border/1`
- inverse: transparent field; `color/border/2`; cutout `color/background-surface/inverse-3`
- hover `color/border-feedback/primary`; focus `interactive/focus`; error `color/border-feedback/danger`
- `spacing/150` (root paddingTop); `spacing/200|300` (field padding)
- `product-theme component/input-textarea/field/radius` (EV→200; site-loovi|app-cliente→500)
- `border/width/012` (default/hover/disabled); `border/width/025` (focus/error, 2px)
- `body/large/regular` (value/placeholder); `caption/large/regular` (label/count/supporting)

### Accessibility

textarea role; label association; aria-invalid + aria-describedby on error; aria-disabled when disabled; announce count when relevant.

### Composition

- InputTextAreaMinHeight (`minHeight`, exposed) + InputTextAreaResizeHandle
- local DS outline icons (leading/trailing)
- floatingLabel / countRow / supporting

---

## InputNumber

**Node ID:** `3935:684`

AI-READY COMPONENT: InputNumber is the Design System 2.0 single-line outlined numeric/phone text field — same visual pattern as Input (height 56, border/radius/200, floating label for content=value|placeholder, resting label for content=label), with an optional in-field SelectCountry trigger for phone/DDI entry. Variants: state=default|hover|focus|error|disabled; content=value|placeholder|label; leadingIcon=true|false; trailingIcon=true|false; appearance=default|inverse (120 variants). showSelectCountry (BOOLEAN, default false) toggles selectCountryBlock after leadingIcon: SelectCountry size=sm + DividerVertical. Nested SelectCountry stays expanded=false; uses state=disabled only when InputNumber is disabled; otherwise SelectCountry state=default (field owns hover/focus/error strokes). On appearance=inverse, SelectCountry expandIcon uses text/on-color (focus text/brand, disabled text/on-color-disabled) and DividerVertical uses color/border/2. appearance=default: field fill color/background-surface/0; default border color/border/1; label text/secondary (focus text/brand); placeholder text/placeholder; value text/primary; leading/trailing icon strokes text/secondary (focus text/brand, disabled text/placeholder, error feedback/danger). appearance=inverse: field fill transparent; floatingLabel cutout color/background-surface/inverse-3; default/disabled border color/border/2; label text/on-color (focus text/brand); value text/on-color; placeholder and non-error supporting text/on-color-disabled; on state=disabled all field texts use text/placeholder-inverse; leadingIcon and trailingIcon strokes text/on-color (focus text/brand, disabled text/on-color-disabled, error feedback/danger). Feedback borders unchanged — hover color/border-feedback/primary, focus interactive/focus, error color/border-feedback/danger. Country menu is never nested — compose externally. Props: label, value, placeholder, supportingText, showSupportingText, leading, trailing, showSelectCountry. Do not use as generic Input, InputPassword, InputSelect, Autocomplete, SelectCountry standalone, stepper, or SearchBar. Accessibility: labeled input; aria-invalid on error; aria-disabled when disabled; when showSelectCountry=true country trigger is a separate named control. Token rule: local S2 kebab-case only. React mapping: InputNumber(state, content, leadingIcon, trailingIcon, appearance, label, value, placeholder, supportingText, showSupportingText, leading?, trailing?, showSelectCountry, countryFlag?). Code Connect is not configured.

### Variants

- **state:** default | hover | focus | error | disabled
- **content:** value | placeholder | label
- **leadingIcon:** true | false
- **trailingIcon:** true | false
- **appearance:** default | inverse

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| hover \| focus \| error \| disabled |
| `content` | value \| placeholder \| label |
| `leadingIcon` | true \| false (variant axis) |
| `trailingIcon` | true \| false (variant axis) |
| `appearance` | default \| inverse — inverse for dark/on-color surfaces |
| `label` | TEXT — floating or resting field label (phone demo: NÃºmero de telefone) |
| `value` | TEXT — input text (phone demo: + 55) |
| `placeholder` | TEXT — placeholder text |
| `supportingText` | TEXT — helper or error message |
| `showSupportingText` | boolean |
| `leading` | INSTANCE_SWAP — local DS outline icon |
| `trailing` | INSTANCE_SWAP — local DS outline icon |
| `showSelectCountry` | boolean — toggles SelectCountry sm + DividerVertical in field (default false) |

### Rules

- **inputMatrix:** state × content × leadingIcon × trailingIcon × appearance = 120 variants; `showSelectCountry` is BOOLEAN not an axis
- **appearanceInverse:** `appearance=inverse`: transparent field; floatingLabel cutout `inverse-3` on all inverse states including focus; `border/2`; on-color texts; disabled texts `text/placeholder-inverse`; icon disabled `on-color-disabled`; focus label `text/brand`; SelectCountry expandIcon on-color + DividerVertical `border/2`
- **selectCountryBlock:** `selectCountryBlock` = SelectCountry size=sm + DividerVertical after leadingIcon
- **floatingLabelAlign:** `floatingLabel` is absolute on `field` (left-aligned with selectCountryBlock / content start), not on the value text — stays with country when `showSelectCountry=true`
- **nestedSelectState:** Nested SelectCountry `expanded=false`; disabled only when InputNumber disabled; else default
- **externalCountryMenu:** Country list floats externally — never nested in InputNumber
- **vsInputSelectPhone:** Do not use as Input, InputSelect, InputPassword, Autocomplete, SelectCountry standalone, stepper, or SearchBar

### Token rules

- default: `color/background-surface/0`; `color/border/1`; `text/primary|secondary|placeholder|brand`
- inverse: transparent field; `color/border/2`; cutout `color/background-surface/inverse-3`; `text/on-color|on-color-disabled`; disabled texts `text/placeholder-inverse`
- shared feedback: `color/border-feedback/primary|danger`, `interactive/focus`, `feedback/danger`
- SelectCountry + DividerVertical nested DS tokens
- no field fill on disabled

### Accessibility

Labeled input; aria-invalid on error; aria-disabled when disabled; country trigger separately named when `showSelectCountry=true`.

### Composition

- SelectCountry
- DividerVertical
- local DS outline icons

---

## InputPassword

**Node ID:** `3950:1701`

AI-READY COMPONENT: InputPassword is the Design System 2.0 outlined password field — same visual identity as Input (height 56, border/radius/200, floating label for content=value|placeholder, resting label for content=label). Variants: state=default|hover|focus|error|disabled; content=value|placeholder|label; leadingIcon=true|false; visibility=hidden|visible; appearance=default|inverse (120 variants). appearance=default uses the standard Input surface tokens (field fill color/background-surface/0, default border color/border/1, label text/secondary, placeholder text/placeholder, value text/primary). appearance=inverse is for inverse/dark surfaces: field fill transparent; floatingLabel cutout color/background-surface/inverse-3 (all inverse states including focus); default/disabled border color/border/2; label (labelText/restingLabel) text/on-color (focus text/brand); placeholder text/on-color-disabled; value text/on-color; on state=disabled all field texts use text/placeholder-inverse. Feedback colors are unchanged on both appearances — hover color/border-feedback/primary, focus interactive/focus, error color/border-feedback/danger + feedback/danger on label/supporting. visibilityAction is always present: local Button variant=text size=sm intent=primary icon-only (showLabel=false). Use eye-closed-outline when visibility=hidden and eye-outline when visibility=visible. When visibility=hidden and content=value, mask the value glyphs (â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢). Nested Button stays at state=default while the field owns hover/focus/error strokes; when InputPassword state=disabled, visibilityAction uses Button disabled=true. state=error always shows trailingIconError (alert-circle-outline) beside visibilityAction. Props: label (default Senha), value, placeholder (default Digite sua senha), supportingText, showSupportingText, leading (INSTANCE_SWAP preferred lock/password/key). Do not use as Input, InputNumber, InputSelect, SearchBar or Autocomplete. Accessibility: password field with labeled show/hide control; aria-invalid on error; aria-describedby for supporting/error; aria-disabled when disabled. Token rule: local S2 kebab-case only. React mapping: InputPassword(state, content, leadingIcon, visibility, appearance, label, value, placeholder, supportingText, showSupportingText, leading?, onVisibilityChange). Code Connect is not configured.

### Variants

- **state:** default | hover | focus | error | disabled
- **content:** value | placeholder | label
- **leadingIcon:** true | false
- **visibility:** hidden | visible
- **appearance:** default | inverse

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| hover \| focus \| error \| disabled |
| `content` | value \| placeholder \| label |
| `leadingIcon` | true \| false (variant axis) |
| `visibility` | hidden \| visible — password reveal axis |
| `appearance` | default \| inverse — inverse for dark/on-color surfaces |
| `label` | TEXT — default Senha |
| `value` | TEXT — masked â€¢â€¢â€¢â€¢ when hidden; plaintext when visible |
| `placeholder` | TEXT — default Digite sua senha |
| `supportingText` | TEXT — helper or error message |
| `showSupportingText` | boolean |
| `leading` | INSTANCE_SWAP — local DS outline (default lock-outline) |

### Rules

- **appearanceInverse:** `appearance=inverse`: transparent field; floatingLabel cutout `inverse-3` on all inverse states including focus; `border/2` default|disabled; `text/on-color` (focus label `text/brand`); disabled texts `text/placeholder-inverse`; icons disabled `on-color-disabled`; feedback strokes unchanged
- **visibilityAxis:** `visibility` replaces generic trailing clear; `visibilityAction` always on
- **eyeIcons:** hidden → `eye-closed-outline` + Mostrar senha; visible → `eye-outline` + Ocultar senha
- **maskValue:** `content=value` + `visibility=hidden` shows masked glyphs
- **buttonStateDefault:** Nested Button stays default; `disabled=true` only when field disabled
- **errorTrailingA11y:** `state=error` shows `trailingIconError` beside visibilityAction
- **disabledNoFill:** `appearance=default` disabled has no field fill; inverse field always transparent
- **vsInputNumberSelect:** Do not use as Input, InputNumber, InputSelect, SearchBar or Autocomplete

### Token rules

- default: `color/background-surface/0`, `color/border/1`, `text/primary|secondary|placeholder|brand`
- inverse: transparent field; floatingLabel cutout `color/background-surface/inverse-3` (including focus); `color/border/2`; `text/on-color|on-color-disabled`; disabled field texts `text/placeholder-inverse`; icons disabled `on-color-disabled`
- shared feedback: `color/border-feedback/primary|danger`, `interactive/focus`, `feedback/danger`
- Button nested DS tokens
- no `Color/Content/Ghost`

### Accessibility

Password field; show/hide button named Mostrar senha / Ocultar senha; aria-invalid on error; aria-describedby; aria-disabled when disabled.

### Composition

- Button (visibilityAction)
- eye-closed-outline / eye-outline
- lock-outline (leading default)
- alert-circle-outline (error)

---

## VerificationCodeInput

**Node ID:** `4029:835`

AI-READY COMPONENT: VerificationCodeInput is the Design System 2.0 verification-code field for OTP, 2FA, and PIN entry (SMS, email, authenticator). Do not use as Input, InputPassword, InputNumber, or InputSelect. Variants: state (5). state: default | hover | focus | error | disabled. No appearance/inverse axis (intentional). Fixed length: 5 digit slots. Anatomy: `labelRow` (label TEXT) + `codeRow` with five exposed VerificationCodeInputItem instances (`codeCell1`â€¦`codeCell5`) + `supportingRow` (supportingText) on state=error only. State propagation: hover/error/disabled apply the matching block state to all cells; focus keeps codeCell1–4 at default and sets codeCell5 to focus (active slot demo). Props: `label` (TEXT), `showLabel` (BOOLEAN), `supportingText` (TEXT), `showSupportingText` (BOOLEAN — targets supportingRow on error). Digit values are edited via exposed nested `codeCell1`â€¦`codeCell5` `digit` props (React: `digit1`â€¦`digit5`). Token rule: root gap `spacing/100`; codeRow gap `spacing/150`; label `body/medium/regular` with `text/secondary` (disabled `text/placeholder`); supporting `caption/large/regular` with `feedback/danger`; cells inherit VerificationCodeInputItem tokens including focus ring `color/elevation/Focus`. Accessibility: group of single-character inputs; label associates to the group; aria-invalid + aria-describedby on error; aria-disabled when disabled; manage focus advance per slot in product code. React mapping: VerificationCodeInput(state, label, showLabel, supportingText, showSupportingText, digit1â€¦digit5). Code Connect is not configured.

### Variants

- **state:** default | hover | focus | error | disabled

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| hover \| focus \| error \| disabled |
| `label` | TEXT — field label (default Digite o cÃ³digo) |
| `showLabel` | BOOLEAN — toggles `labelRow` |
| `supportingText` | TEXT — error helper (default CÃ³digo invÃ¡lidoâ€¦) |
| `showSupportingText` | BOOLEAN — toggles `supportingRow` on state=error |
| `digit1`â€¦`digit5` | React/product — map to exposed nested `codeCell1`â€¦`codeCell5` `digit` |

### Rules

- **otpFieldOnly:** OTP/2FA/PIN field — not Input, InputPassword, InputNumber, or InputSelect
- **fixedLength5:** Fixed 5 digit slots (intentional)
- **noInverse:** No appearance/inverse axis (intentional)
- **focusLastSlot:** `state=focus` demo: `codeCell5=focus`; `codeCell1–4=default`
- **statePropagation:** hover/error/disabled propagate matching block state to all cells
- **supportingErrorOnly:** `supportingRow` exists only on `state=error`
- **exposedCells:** `codeCell1`â€¦`codeCell5` exposed for digit editing — orphan parent `digit1`â€¦`5` removed

### Token rules

- root `itemSpacing` `spacing/100`
- `codeRow` `itemSpacing` `spacing/150`
- label: `body/medium/regular`; `text/secondary` (disabled `text/placeholder`)
- supporting: `caption/large/regular`; `feedback/danger`
- inherits VerificationCodeInputItem tokens (incl. `color/elevation/Focus` ring)

### Accessibility

Group of single-character inputs; label associates to the group; aria-invalid + aria-describedby on error; aria-disabled when disabled; product code advances focus per slot.

### Composition

- VerificationCodeInputItem (`codeCell1`â€¦`codeCell5`, exposed)
- `labelRow` / `codeRow` / `supportingRow` (error)

---

## VerificationCodeInputItem

**Node ID:** `4028:773`

AI-READY COMPONENT: VerificationCodeInputItem is the Design System 2.0 single-digit cell used inside VerificationCodeInput for OTP, 2FA, and PIN entry. It is not a free-text Input — compose only as a digit slot in the verification code field. Variants: state (5). state: default | hover | focus | error | disabled. No appearance/inverse axis (intentional). Anatomy: fixed 56×48 frame with centered `digit` TEXT. Props: `digit` (TEXT) — displayed character (typically 0–9; canvas default "1"). Visual rules: fill `color/background-surface/0`; default and disabled borders `color/border/1`; hover border `color/border-feedback/primary`; focus border `interactive/focus` plus DROP_SHADOW ring (`color/elevation/Focus`, spread `spacing/050`); error border `color/border-feedback/danger`; digit `text/primary` (disabled `text/placeholder`). Geometry tokens: `border/radius/300`, padding `spacing/050` vertical and `spacing/100` horizontal, stroke `border/width/012`. Typography: `body/large/regular` on digit. The parent VerificationCodeInput selects the block state per slot. Accessibility: each block maps to a single-character input or spinbutton segment; announce errors on the group; disabled slots use aria-disabled. React mapping: VerificationCodeInputItem(state, digit). Code Connect is not configured.

### Variants

- **state:** default | hover | focus | error | disabled

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| hover \| focus \| error \| disabled |
| `digit` | TEXT — displayed digit character (typically 0–9; canvas default `1`) |

### Rules

- **otpCellOnly:** Compose inside VerificationCodeInput — not a free-text Input
- **noInverse:** No appearance/inverse axis (intentional)
- **focusRing:** `state=focus`: `interactive/focus` stroke + DROP_SHADOW ring (`color/elevation/Focus`, spread `spacing/050`)
- **disabledDigit:** `state=disabled` digit uses `text/placeholder`
- **geometryTokens:** `border/radius/300`; padding `spacing/050|100`; stroke `border/width/012`

### Token rules

- `color/background-surface/0`
- `color/border/1` (default|disabled)
- `color/border-feedback/primary` (hover)
- `interactive/focus` (focus stroke)
- `color/elevation/Focus` (focus ring effect color)
- `color/border-feedback/danger` (error)
- `text/primary` | `text/placeholder` (disabled digit)
- `border/radius/300`; `spacing/050|100`; `border/width/012`; `spacing/0` (ring offset/radius)
- `body/large/regular`

### Accessibility

Single-character input/spinbutton segment; announce errors on the group; aria-disabled when disabled.

### Composition

- VerificationCodeInput (parent field)
- `digit` TEXT (prop)

---

## SliderLeftRail

**Node ID:** `4073:2214`

AI-READY COMPONENT: SliderLeftRail is the Design System 2.0 left/start rail segment used inside Slider (and related Slider track compositions). It is not a standalone control — compose only as the start rail of a Slider track; do not use as SliderRightRail, Slider handle, ProgressBar, or a free-standing track. Variants: active (2). active: false | true. No appearance/inverse axis (intentional). Anatomy: `railStartSpacer` + `endCapSlot` + `endCap`. Visual rules: both `active=false` and `active=true` use fill `color/actions/primary` on the rail root and `endCap` — the only visual difference is endCap size (`active=false`: 14×14; `active=true`: 20×20). The endCap intentionally overflows the 2px rail height (circle-overflow pattern) so the track tip stays continuous when composed in SliderRail. Geometry tokens: `border/radius/full` on rail and endCap; itemSpacing/gap `spacing/250`; rail height `spacing/025`. Accessibility: decorative track segment; interaction and value semantics belong to the parent Slider. React mapping: SliderLeftRail(active). Code Connect is not configured.

### Variants

- **active:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `active` | false \| true |

### Rules

- **sliderRailOnly:** Compose inside Slider track — not a standalone control
- **sameFillBothActive:** Both `active=false` and `active=true` use `color/actions/primary`; difference is endCap size only (14×14 vs 20×20)
- **endCapOverflow:** `endCap` intentionally overflows the 2px rail (circle-overflow) for continuous track tip in SliderRail
- **noInverse:** No appearance/inverse axis (intentional)
- **geometryTokens:** `border/radius/full`; gap `spacing/250`; height `spacing/025`

### Token rules

- `color/actions/primary` (rail + endCap, both active values)
- `border/radius/full`
- `spacing/250` (itemSpacing/gap)
- `spacing/025` (rail height)

### Accessibility

Decorative track segment; value/interaction semantics belong to parent Slider.

### Composition

- SliderRail / SliderItem / Slider (parent compositions)
- `railStartSpacer` + `endCapSlot` + `endCap`
- SliderRightRail (sibling residual track)

---

## SliderRightRail

**Node ID:** `4073:2224`

AI-READY COMPONENT: SliderRightRail is the Design System 2.0 right/end residual rail segment used inside Slider (and related Slider track compositions). It is not a standalone control — compose only as the unfilled/residual end of a Slider track; do not use as SliderLeftRail, Slider handle, ProgressBar, or a free-standing track. Single published component (no variant matrix): residual track has no active axis. Anatomy: `railLeadSpacer` + `railTrailSpacer`. Visual rules: fill `color/border/2` on the rail root for on-canvas contrast against the filled left rail (`color/actions/primary`). Geometry tokens: `border/radius/full`; itemSpacing/gap `spacing/250`; rail height `spacing/025` (FIXED, parity with SliderLeftRail). No appearance/inverse axis (intentional). Accessibility: decorative track segment; interaction and value semantics belong to the parent Slider. React mapping: SliderRightRail(). Code Connect is not configured.

### Variants

_(none — single residual component)_

### Props

_(none)_

### Rules

- **sliderRailOnly:** Compose inside Slider track — not a standalone control
- **singleResidual:** Single component — no active axis (residual/unfilled track)
- **fillContrast:** `color/border/2` vs SliderLeftRail `color/actions/primary`
- **noInverse:** No appearance/inverse axis (intentional)
- **geometryTokens:** `border/radius/full`; gap `spacing/250`; height `spacing/025` FIXED

### Token rules

- `color/border/2`
- `border/radius/full`
- `spacing/250` (itemSpacing/gap)
- `spacing/025` (rail height)

### Accessibility

Decorative track segment; value/interaction semantics belong to parent Slider.

### Composition

- SliderRail / SliderItem / Slider (parent compositions)
- `railLeadSpacer` + `railTrailSpacer`
- SliderLeftRail (sibling filled track)

---

## SliderRail

**Node ID:** `4073:2228`

AI-READY COMPONENT: SliderRail is the Design System 2.0 composed Slider track used inside Slider / SliderItem compositions. It is not a standalone control — compose only as the track of a Slider; do not use as SliderLeftRail or SliderRightRail alone, Slider handle, ProgressBar, or a free-standing bar. Single published component (no variant matrix on the shell). Anatomy: SliderRightRail (residual) + SliderLeftRail (filled, exposed). Child order is Right then Left (intentional — packs with `primaryAxisAlignItems=MAX` so the filled segment and endCap sit correctly on the track). Parent shell fill is empty — track color comes from child rails (Left: `color/actions/primary`; Right: `color/border/2`). Shell tokens: `border/radius/full`. Shell vertical sizing is HUG (children own height `spacing/025`). No appearance/inverse axis (intentional). Accessibility: decorative track; value/interaction semantics belong to the parent Slider. React mapping: SliderRail(leftRailActive?). Code Connect is not configured.

### Variants

_(none — single composed track)_

### Props

| Prop | Tipo / valores |
|---|---|
| `leftRail` | Exposed nested SliderLeftRail (`active` VARIANT editable from parent) |

### Rules

- **composeOnly:** Compose inside Slider / SliderItem — not a standalone control
- **childOrder:** SliderRightRail then SliderLeftRail (intentional packing with `primaryAxisAlignItems=MAX`)
- **emptyShellFill:** Parent shell fill empty — colors from child rails
- **shellHug:** Shell `layoutSizingVertical` HUG — children own `spacing/025` height
- **exposedLeft:** SliderLeftRail is exposed for `active` editing
- **noInverse:** No appearance/inverse axis (intentional)

### Token rules

- `border/radius/full` (shell)
- inherits SliderLeftRail + SliderRightRail tokens

### Accessibility

Decorative track; value/interaction semantics belong to parent Slider.

### Composition

- SliderRightRail
- SliderLeftRail (exposed)
- SliderItem / Slider (parents)

---

## SliderItem

**Node ID:** `4073:2232`

AI-READY COMPONENT: SliderItem is the Design System 2.0 track cell used inside Slider compositions. It combines an optional middle tick mark with a nested SliderRail (SliderRightRail + SliderLeftRail). It is not a standalone control — compose only as a Slider track cell; do not use as SliderRail alone, Slider handle, ProgressBar, or a free-standing bar. Variants: active (2). active: false | true — maps to nested SliderLeftRail.active (endCap 14 when false, 20 when true). Anatomy: `middleIndicatorOverflow` → `middleIndicator` + SliderRail (exposed). Visual rules: middleIndicator fill `color/border/2` size `spacing/025`×`spacing/025`; rail colors from child rails. Shell fill empty; vertical sizing HUG. `middleIndicatorOverflow` may keep a 1px bottom pad for optical tick alignment (intentional). No appearance/inverse axis (intentional). Accessibility: decorative track cell; value/interaction semantics belong to the parent Slider. React mapping: SliderItem(active). Code Connect is not configured.

### Variants

- **active:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `active` | false \| true — maps to nested SliderLeftRail.active |
| `sliderRail` | Exposed nested SliderRail |

### Rules

- **composeOnly:** Compose inside Slider — not a standalone control
- **activeMapsLeftRail:** `active=false` → LeftRail `active=false` (endCap 14); `active=true` → LeftRail `active=true` (endCap 20)
- **exposedRail:** SliderRail is exposed for nested editing
- **middleTick:** `middleIndicator` `color/border/2`; size `spacing/025`; overflow may use 1px bottom pad
- **shellHug:** Shell `layoutSizingVertical` HUG
- **noInverse:** No appearance/inverse axis (intentional)

### Token rules

- `color/border/2` (middleIndicator)
- `spacing/025` (middleIndicator width/height)
- inherits SliderRail / SliderLeftRail / SliderRightRail tokens

### Accessibility

Decorative track cell; value/interaction semantics belong to parent Slider.

### Composition

- `middleIndicatorOverflow` / `middleIndicator`
- SliderRail (exposed)
- Slider / SliderSkeletonItem (parents)

---

## SliderSkeletonItem

**Node ID:** `4092:4005`

AI-READY COMPONENT: SliderSkeletonItem is the Design System 2.0 loading placeholder for Slider. It is not interactive and must not be used as the live Slider, SliderItem, SliderRail, or a ProgressBar. Single published component (no variant matrix). Anatomy: `labelBone` + `sliderRow` (`minValueBone` + SliderItem + `maxValueBone`). Visual rules: all bone fills use `color/border/2`; nested SliderItem rails/endCap are overridden to `color/border/2` so no active primary appears in skeleton. Geometry tokens: root and sliderRow gap `spacing/100`; sliderRow vertical padding `spacing/200`; bone corners `border/radius/100`. Shell fill empty; vertical sizing HUG. Nested SliderItem is exposed for rare overrides (keep `active=false` in skeleton demos). No appearance/inverse axis (intentional). Accessibility: decorative loading placeholder; announce loading on the parent Slider when used. React mapping: SliderSkeletonItem(). Code Connect is not configured.

### Variants

_(none — single skeleton component)_

### Props

| Prop | Tipo / valores |
|---|---|
| `sliderItem` | Exposed nested SliderItem (keep `active=false` in skeleton demos) |

### Rules

- **skeletonOnly:** Loading placeholder — not the live Slider / SliderItem
- **bonesBorder2:** All bones + nested rail/endCap overrides use `color/border/2` (no active primary)
- **geometryTokens:** gap `spacing/100`; sliderRow paddingY `spacing/200`; bone radius `border/radius/100`
- **exposedItem:** SliderItem exposed; keep `active=false` for skeleton demos
- **shellHug:** Shell `layoutSizingVertical` HUG
- **noInverse:** No appearance/inverse axis (intentional)

### Token rules

- `color/border/2` (bones + nested rail overrides)
- `spacing/100` (root + sliderRow gap)
- `spacing/200` (sliderRow paddingTop/Bottom)
- `border/radius/100` (bones)
- inherits SliderItem tokens where not overridden

### Accessibility

Decorative loading placeholder; announce loading on the parent Slider when used.

### Composition

- `labelBone`
- `sliderRow` (`minValueBone` + SliderItem + `maxValueBone`)
- Slider `Status=Skeleton` (parent)

---

## SliderBaseItem

**Node ID:** `3950:7416`

AI-READY INTERNAL COMPONENT: SliderBaseItem — internal labeled slider row used to compose the top-level Slider. Props: `label` (TEXT); `minValue` (TEXT); `maxValue` (TEXT). Composition: `label` + `sliderRow` (`railRow` with `minValue`, SliderItem, `maxValue` + Input). Expose SliderItem and Input for nested overrides (`active`, `value`, Input state). Tokens: `text/secondary` (label), `text/primary` (minValue/maxValue); track via SliderItem (`color/actions/primary` + `color/border/2`). Gaps: `spacing/100` (root, railRow), `spacing/200` (sliderRow). Input uses local S2 Input (state mapped by parent Slider; `content=value`; no icons; `appearance=default`).

### Variants

_(none — single internal component)_

### Props

| Prop | Tipo / valores |
|---|---|
| `label` | TEXT — field label above the track |
| `minValue` | TEXT — min label at rail start |
| `maxValue` | TEXT — max label at rail end |
| `sliderItem` | Exposed nested SliderItem (`active`) |
| `input` | Exposed nested Input (`value` + state overrides from parent Slider) |

### Rules

- **internalOnly:** Compose inside Slider — not a standalone page control
- **exposeNested:** SliderItem and Input are exposed for parent overrides
- **inputContentValue:** Input `content=value` (numeric value field)
- **gaps:** root + railRow `spacing/100`; sliderRow `spacing/200`
- **noInverse:** No appearance/inverse axis (intentional)

### Token rules

- `text/secondary` (label)
- `text/primary` (minValue/maxValue)
- `spacing/100` (root + railRow gap)
- `spacing/200` (sliderRow gap)
- inherits SliderItem + Input tokens

### Accessibility

Label provides accessible name context; value semantics belong to parent Slider + Input.

### Composition

- `label`
- `sliderRow` (`railRow`: `minValue` + SliderItem + `maxValue` + Input)
- Slider (parent)

---

## Slider

**Node ID:** `3950:7327`

AI-READY COMPONENT: Slider — adjustable value control with horizontal track, min/max labels, and numeric Input. Props: `status=enabled|hover|focus|active|error|warning|disabled|read-only|skeleton`; `errorText`; `warningText`. Nested (exposed): SliderBaseItem (`label`, `minValue`, `maxValue`; nested SliderItem + Input) on live statuses; SliderSkeletonItem on `status=skeleton` (BaseItem kept hidden as structural keeper). Composition: SliderBaseItem = label + railRow (minValue, SliderItem, maxValue) + Input; skeleton swaps to SliderSkeletonItem. Input state maps to status: enabled→default; hover→hover; focus/active→focus; error→error; warning→default + warningText; disabled→disabled; read-only→default (Input has no read-only state — intentional; non-editable semantics belong to product/runtime). Feedback text uses `body/small/regular` + `feedback/danger|warning` fills; `status=error|warning` gap `spacing/100`. Tokens via children: `color/actions/primary`, `color/border/2`, `text/primary`, `text/secondary`, `spacing/100|200`. No appearance/inverse (intentional). Accessibility: provide accessible name from label; announce value changes; associate errorText/warningText with the control. React mapping: Slider(status, errorText, warningText, â€¦exposed nested). Code Connect is not configured.

### Variants

- **status:** enabled | hover | focus | active | error | warning | disabled | read-only | skeleton

### Props

| Prop | Tipo / valores |
|---|---|
| `status` | enabled \| hover \| focus \| active \| error \| warning \| disabled \| read-only \| skeleton |
| `errorText` | TEXT — shown under track when `status=error`; `body/small/regular` + `feedback/danger` |
| `warningText` | TEXT — shown under track when `status=warning`; `body/small/regular` + `feedback/warning` |
| `sliderBaseItem` | Exposed nested SliderBaseItem (`label`, `minValue`, `maxValue`; nested SliderItem + Input) on live statuses |
| `sliderSkeletonItem` | Exposed nested SliderSkeletonItem on `status=skeleton` |

### Rules

- **statusMatrix:** Published 9/9 status variants
- **inputMapping:** enabled→default; hover→hover; focus/active→focus; error→error; warning/read-only→default; disabled→disabled
- **readOnlyIntentional:** `read-only` uses Input default — Input has no read-only state; runtime owns non-editable behavior
- **feedbackTypography:** errorText/warningText use `body/small/regular` (not Carbon Utility styles)
- **feedbackGap:** `status=error|warning` itemSpacing bound to `spacing/100`
- **exposedNested:** SliderBaseItem exposed on live statuses; SliderSkeletonItem (+ hidden BaseItem keeper) on skeleton
- **skeletonSwap:** `status=skeleton` hides BaseItem and shows SliderSkeletonItem
- **noInverse:** No appearance/inverse axis (intentional)

### Token rules

- `body/small/regular` (errorText/warningText)
- `feedback/danger` (errorText fill)
- `feedback/warning` (warningText fill)
- `spacing/100` (error/warning gap)
- inherits SliderBaseItem / SliderSkeletonItem / SliderItem / Input tokens

### Accessibility

Provide accessible name from label; announce value changes; associate errorText/warningText with the control.

### Composition

- SliderBaseItem (live statuses; exposed)
- `errorText` / `warningText` (`status=error|warning`)
- SliderSkeletonItem (`status=skeleton`; exposed)

---

## CardHorizontal

**Node ID:** `4170:4506`

AI-READY COMPONENT: CardHorizontal — horizontal Card layout with media/text or custom slot content. Props: `style=outlined|elevated|filled`; `layout=media-and-text|slot`; `headerText`; `subheadText`; `slot` (SLOT). Composition: absolute `background` (CardOutlinedItem|CardElevatedItem|CardFilledItem, exposed) + content. `layout=media-and-text`: body (Avatar exposed + text header/subhead) + media (`mediaImage` placeholder). `layout=slot`: slot fills content (`stretchChildOnInsert=true`). Demo shell FIXED 360×80 (mobile exemplar). Tokens: `spacing/200` (body padding + body gap + slot horizontal padding); `spacing/100` (slot vertical padding); `spacing/050` (text gap); `border/radius/300`; `text/primary` + `text/secondary`; `heading/h3/regular` + `body/medium/regular`; media placeholder `color/background-surface/2` with IMAGE scaleMode FILL. No `slotSwap` (removed — use `slot`). No appearance/inverse (intentional). React mapping: CardHorizontal(style, layout, headerText, subheadText, slot, â€¦exposed background/Avatar). Code Connect is not configured.

### Variants

- **style:** outlined | elevated | filled
- **layout:** media-and-text | slot

### Props

| Prop | Tipo / valores |
|---|---|
| `style` | outlined \| elevated \| filled — maps background to Card*Item |
| `layout` | media-and-text \| slot |
| `headerText` | TEXT — primary title; `heading/h3/regular` + `text/primary` |
| `subheadText` | TEXT — secondary line; `body/medium/regular` + `text/secondary` |
| `slot` | SLOT — custom content when `layout=slot`; `stretchChildOnInsert=true` |
| `background` | Exposed nested Card*Item (`state` / `showFocusIndicator`) |
| `avatar` | Exposed nested Avatar on `layout=media-and-text` |

### Rules

- **matrix:** Published 6/6 — style × layout
- **backgroundMap:** outlined→CardOutlinedItem; elevated→CardElevatedItem; filled→CardFilledItem (exposed)
- **noSlotSwap:** `slotSwap` removed — use `slot` only
- **mediaFill:** `mediaImage` IMAGE scaleMode FILL over `color/background-surface/2`
- **demoSize:** FIXED 360×80 mobile exemplar
- **spacing:** body padding + body gap `spacing/200`; slot pad vertical `spacing/100` + horizontal `spacing/200`; text gap `spacing/050`; radius `border/radius/300`
- **noInverse:** No appearance/inverse (intentional)

### Token rules

- `spacing/200` (body padding + body gap + slot horizontal padding)
- `spacing/100` (slot vertical padding)
- `spacing/050` (text gap)
- `border/radius/300`
- `text/primary`; `text/secondary`
- `heading/h3/regular`; `body/medium/regular`
- `color/background-surface/2` (media placeholder)
- inherits CardOutlinedItem | CardElevatedItem | CardFilledItem tokens

### Accessibility

Provide accessible name from `headerText`; media may need alt from product; Avatar exposed for initials/image.

### Composition

- `background` (Card*Item; exposed; absolute SCALE)
- `content` → `body` (Avatar + text) + `media` | `slot`

---

## CardStacked

**Node ID:** `4170:4433`

AI-READY COMPONENT: CardStacked — vertical stacked Card with media, header, body text, and actions (or custom slot). Props: `style=outlined|elevated|filled`; `layout=media-and-text|slot`; `headerText`; `subheadText`; `titleText`; `subtitleText`; `supportingText`; `showSecondaryAction` (BOOLEAN, default true); `slot` (SLOT). Composition: absolute `background` (CardOutlinedItem|CardElevatedItem|CardFilledItem, exposed) + content. `layout=media-and-text`: `headerRow` (Avatar exposed + text header/subhead + `menuAction` Button text exposed) + `media` (`mediaImage`) + `body` (`headline` title/subtitle + `supportingText` + `actions`: secondary outline + primary solid, both exposed). `layout=slot`: `content` → `slot` (demo `slotContent`; ImageItem preferredValues). Demo shell FIXED 360×480 (mobile exemplar). Tokens: `spacing/200` (body padding + slot horizontal); `spacing/100` (slot vertical + actions gap); `spacing/150|050` (headerRow); `spacing/400` (body gap); `spacing/050` (text/headline gaps); `border/radius/300` bound on root/content/slot; media IMAGE scaleMode FILL over `color/background-surface/2` (demo FIXED ~360×188). No `slotSwap`. No appearance/inverse (intentional). React mapping: CardStacked(style, layout, headerText, subheadText, titleText, subtitleText, supportingText, showSecondaryAction, slot, â€¦exposed). Code Connect is not configured.

### Variants

- **style:** outlined | elevated | filled
- **layout:** media-and-text | slot

### Props

| Prop | Tipo / valores |
|---|---|
| `style` | outlined \| elevated \| filled — maps background to Card*Item |
| `layout` | media-and-text \| slot |
| `headerText` | TEXT — header title; `heading/h3/regular` + `text/primary` |
| `subheadText` | TEXT — header secondary; `body/medium/regular` + `text/secondary` |
| `titleText` | TEXT — body title; `heading/h3/regular` + `text/primary` |
| `subtitleText` | TEXT — body subtitle; `body/medium/regular` + `text/secondary` |
| `supportingText` | TEXT — body supporting; `body/medium/regular` + `text/secondary` |
| `showSecondaryAction` | boolean — default true; toggles secondaryAction |
| `slot` | SLOT — custom content when `layout=slot`; preferredValues includes ImageItem |
| `background` | Exposed nested Card*Item |
| `avatar` | Exposed nested Avatar |
| `menuAction` | Exposed nested Button (text icon-only) |
| `primaryAction` | Exposed nested Button (solid sm) |
| `secondaryAction` | Exposed nested Button (outline sm) |

### Rules

- **matrix:** Published 6/6 — style × layout
- **backgroundMap:** outlined→CardOutlinedItem; elevated→CardElevatedItem; filled→CardFilledItem (exposed)
- **slotStructure:** All slot variants use `content` → `slot` + absolute background
- **noSlotSwap:** No `slotSwap` — use `slot` only
- **mediaFill:** `mediaImage` IMAGE scaleMode FILL over `color/background-surface/2`; demo FIXED ~360×188
- **demoSize:** FIXED 360×480 mobile exemplar
- **spacing:** body pad `spacing/200`; body gap `spacing/400`; slot pad vertical `spacing/100` + horizontal `spacing/200`; headerRow `spacing/150|050|200`; text/headline gaps `spacing/050`; actions gap `spacing/100`; radius `border/radius/300` (bound); slotContent demo `border/radius/200`
- **layerNaming:** `leading`, `text`, `headline`, `subtitle`, `actions`
- **noInverse:** No appearance/inverse (intentional)

### Token rules

- `spacing/200` (body padding + slot horizontal padding)
- `spacing/100` (slot vertical padding + actions gap)
- `spacing/150`; `spacing/050` (headerRow pads)
- `spacing/400` (body gap)
- `spacing/050` (text/headline gaps)
- `border/radius/300` (root/content/slot — bound)
- `border/radius/200` (slotContent demo)
- `text/primary`; `text/secondary`
- `heading/h3/regular`; `body/medium/regular`
- `color/background-surface/2` (media placeholder)
- `mediaImage` IMAGE scaleMode FILL
- inherits CardOutlinedItem | CardElevatedItem | CardFilledItem tokens

### Accessibility

Accessible name from `headerText`/`titleText`; media may need alt from product; Avatar and action Buttons exposed.

### Composition

- `background` (Card*Item; exposed; absolute SCALE)
- `content` → `headerRow` + `media` + `body` | `slot`
- `headerRow` → `leading` (Avatar + text) + `menuAction`
- `body` → `headline` (title + subtitle) + `supportingText` + `actions`

---

## DashboardCardPrimary

**Node ID:** `4181:493`

AI-READY COMPONENT: DashboardCardPrimary — primary dashboard metric card on a dark inverse surface with donut chart accent, primary value, and two secondary metrics. Props: `type=web|mobile`; `title`; `primaryValue`; `label1`; `label2`; `description1`; `description2`; `showInfo` (BOOLEAN, default true — web-only; mobile has no info slot, intentional sparse). Anatomy web: `titleRow` + `content` (chart donut + `primaryValue` + `metrics` `metricItem1|2`) + `info`. Anatomy mobile: `mainCol` (`chartWrap` with donut + `leadingIcon` + `primaryValue` + `title`) + `content` (`metricItem1|2`). Chart: `chartTrack` (`inverse-1` web / `inverse-0` mobile) + `chartAccent` (`color/actions/secondary`). Tokens: `color/background-surface/inverse-4`; `border/radius/400`; web pad `spacing/200` vert + `spacing/400` horiz + gap `spacing/100`; mobile pad/gap `spacing/200`; typography `body/medium/semi-bold` (web title), `body/small/semi-bold` (mobile title), `heading/h1/semi-bold` (primaryValue), `body/small/regular` (labels), `heading/h2/semi-bold` (descriptions); `text/on-color` + `text/on-color-disabled`. Demo sizes: web ~257×192; mobile ~175×153. No growth axis (unlike DashboardCardSecondary). No hover/focus/disabled (intentional). React mapping: DashboardCardPrimary(type, title, primaryValue, label1, label2, description1, description2, showInfo). Code Connect is not configured.

### Variants

- **type:** web | mobile

### Props

| Prop | Tipo / valores |
|---|---|
| `type` | web \| mobile |
| `title` | TEXT — `body/medium/semi-bold` (web) \| `body/small/semi-bold` (mobile); `text/on-color-disabled` |
| `primaryValue` | TEXT — `heading/h1/semi-bold` + `text/on-color` |
| `label1` / `label2` | TEXT — `body/small/regular` + `text/on-color-disabled` |
| `description1` / `description2` | TEXT — `heading/h2/semi-bold` + `text/on-color` |
| `showInfo` | boolean — default true; web-only (intentional sparse) |

### Rules

- **matrix:** Published 2/2 — type
- **darkInverse:** Dark shell via `color/background-surface/inverse-4` (not appearance/inverse axis)
- **chartAccent:** `chartTrack` inverse-1 (web) / inverse-0 (mobile); `chartAccent` `color/actions/secondary`
- **iconsLocal:** web `info` stroke `text/on-color-disabled`; mobile `leadingIcon` stroke `text/on-color`
- **showInfoSparse:** `showInfo` web-only — mobile has no info slot (intentional)
- **noGrowthAxis:** No growth axis (unlike DashboardCardSecondary)
- **noInteractiveStates:** No hover/focus/disabled (intentional — static metric)
- **demoSizes:** web ~257×192 HUG; mobile ~175×153

### Token rules

- `color/background-surface/inverse-4`
- `color/background-surface/inverse-0` \| `inverse-1` (chartTrack)
- `color/actions/secondary` (chartAccent)
- `text/on-color` \| `text/on-color-disabled`
- `border/radius/400`
- `spacing/400` \| `300` \| `200` \| `100` \| `050` \| `025` \| `0`
- `body/medium/semi-bold`; `body/small/semi-bold`; `body/small/regular`; `heading/h1/semi-bold`; `heading/h2/semi-bold`

### Accessibility

Accessible name from `title` + `primaryValue`; secondary metrics need labels; do not rely on chart color alone; info is supplementary.

### Composition

- web: `titleRow` + `content` (chart + primaryValue + metrics) + `info`
- mobile: `mainCol` (chartWrap + primaryValue + title) + `content` (metricItem1\|2)
- chart → `chartTrack` + `chartAccent` (+ `leadingIcon` on mobile)

---

## DashboardCardSecondary

**Node ID:** `4181:528`

AI-READY COMPONENT: DashboardCardSecondary — secondary dashboard metric card with optional leading icon, primary value, and growth indicator. Props: `type=web|mobile`; `growth=up|down`; `icon` (INSTANCE_SWAP, web); `showIcon` (BOOLEAN, web-only — intentional sparse; mobile has no icon slot); `title`; `value`; `showInfo`; `showDescription`; `percentage`; `percentageDescription`. Anatomy: `card` (`titleRow`/`title` + `valuesRow`) + `info`. `valuesRow` contains `value` + `percentual` (`percentage` + `growthIcon` + `percentageDescription`). `growth=up` uses `circle-arrow-up-right-filled` + `color/actions/success`; `growth=down` uses `circle-arrow-down-right-filled` + `color/actions/danger`. Tokens: web pad `spacing/300` + `surface/0`; mobile pad `spacing/150` + `surface/1`; `border/radius/400`; card gap `spacing/100` (web) / `spacing/050` (mobile); titleRow gap `spacing/050`; valuesRow gap `spacing/025` (web); percentual/percentageRow gap `spacing/050`; web icon chip: wrapper fill `text/brand` + size `spacing/400` + `radius/full`, path stroke `text/on-color`; info stroke `text/placeholder`; `text/primary` + `text/secondary`; `caption/large/regular` + `display/large/bold` + `body/small/regular`. Demo sizes: web FIXED ~210×192; mobile FIXED width ~116 × HUG. No appearance/inverse and no hover/focus/disabled card states (intentional — static metric). React mapping: DashboardCardSecondary(type, growth, icon, showIcon, title, value, showInfo, showDescription, percentage, percentageDescription). Code Connect is not configured.

### Variants

- **type:** web | mobile
- **growth:** up | down

### Props

| Prop | Tipo / valores |
|---|---|
| `type` | web \| mobile |
| `growth` | up \| down — maps growth icon + success\|danger |
| `icon` | INSTANCE_SWAP — local outline (web; default `file-description-outline`) |
| `showIcon` | boolean — default true; web-only (intentional sparse) |
| `title` | TEXT — metric title; `text/primary` |
| `value` | TEXT — primary value; `text/primary` |
| `showInfo` | boolean — default true; toggles info |
| `showDescription` | boolean — default true; toggles percentageDescription |
| `percentage` | TEXT — growth percentage |
| `percentageDescription` | TEXT — growth supporting copy |

### Rules

- **matrix:** Published 4/4 — type × growth
- **growthMap:** up→`circle-arrow-up-right-filled` + `color/actions/success`; down→`circle-arrow-down-right-filled` + `color/actions/danger`
- **showIconSparse:** `showIcon` applies on web only — mobile has no leading icon slot (intentional)
- **surfaces:** web `color/background-surface/0`; mobile `color/background-surface/1`
- **noInverse:** No appearance/inverse axis (intentional)
- **noInteractiveStates:** No hover/focus/disabled card states (intentional — static metric)

### Token rules

- `color/background-surface/0` (web); `color/background-surface/1` (mobile)
- `color/actions/success` \| `color/actions/danger` (growth)
- `text/primary` \| `text/secondary` \| `text/brand` \| `text/on-color` \| `text/placeholder`
- `border/radius/400` \| `border/radius/full` (icon chip)
- `spacing/300` \| `150` \| `100` \| `050` \| `025` \| `400`
- `caption/large/regular`; `display/large/bold`; `body/small/regular`

### Accessibility

Accessible name from `title` + `value`; convey growth direction in text (not color alone); info is supplementary.

### Composition

- `card` → `titleRow` + `valuesRow`
- `valuesRow` → `value` + `percentual` (`percentage` + `growthIcon` + `percentageDescription`)
- `info` (`showInfo`)

---

## CardElevatedItem

**Node ID:** `4170:4564`

AI-READY INTERNAL COMPONENT: CardElevatedItem — elevated Card surface building block (state shell). Props: `state=enabled|hover|focus|pressed|dragged`; `showFocusIndicator` (BOOLEAN, default true). Anatomy: `stateLayer` (+ `focusIndicator` on focus). Tokens: `color/background-surface/1`; `border/radius/300`; no outline; hover stateLayer `interactive/hover`; pressed root `interactive/pressed` over surface; dragged stateLayer `interactive/selected`; pad/gap `spacing/100`; focus ring `color/actions/primary`; elevation resting `/2`, hover `/6`, dragged `/5`. No disabled / no inverse (intentional). React mapping: CardElevatedItem(state, showFocusIndicator). Code Connect is not configured.

### Variants

- **state:** enabled | hover | focus | pressed | dragged

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | enabled \| hover \| focus \| pressed \| dragged |
| `showFocusIndicator` | boolean — default true; toggles focusIndicator on `state=focus` |

### Rules

- **surfaceOnly:** State shell — content composed by parent Card
- **noOutline:** No outline stroke — elevated surface uses shadow
- **interactionFills:** hover stateLayer `interactive/hover`; pressed root `interactive/pressed`; dragged stateLayer `interactive/selected`
- **elevation:** resting `color/elevation/2`; hover `/6`; dragged `/5`
- **spacing:** stateLayer padding/gap `spacing/100`
- **naming:** Renamed from Material `.Building Blocks/Card states/Elevated`

### Token rules

- `color/background-surface/1`
- `border/radius/300`
- `interactive/hover | pressed | selected`
- `color/actions/primary` (focusIndicator)
- `color/elevation/2|5|6`
- `spacing/100`

### Composition

- `stateLayer` + `focusIndicator` (`state=focus`)
- Card parents (Stacked / Horizontal)

---

## CardFilledItem

**Node ID:** `4170:4576`

AI-READY INTERNAL COMPONENT: CardFilledItem — filled Card surface building block (state shell). Props: `state=enabled|hover|focus|pressed|dragged`; `showFocusIndicator` (BOOLEAN, default true). Anatomy: `stateLayer` (+ `focusIndicator` on focus). Tokens: `color/background-surface/2`; `border/radius/300`; no outline; hover stateLayer `interactive/hover`; pressed root `interactive/pressed` over surface; dragged stateLayer `interactive/selected`; pad/gap `spacing/100`; focus ring `color/actions/primary`; elevation none on enabled/focus/pressed; hover `/6`; dragged `/5`. No disabled / no inverse (intentional). React mapping: CardFilledItem(state, showFocusIndicator). Code Connect is not configured.

### Variants

- **state:** enabled | hover | focus | pressed | dragged

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | enabled \| hover \| focus \| pressed \| dragged |
| `showFocusIndicator` | boolean — default true; toggles focusIndicator on `state=focus` |

### Rules

- **surfaceOnly:** State shell — content composed by parent Card
- **noOutline:** No outline stroke — filled surface uses fill contrast
- **interactionFills:** hover stateLayer `interactive/hover`; pressed root `interactive/pressed`; dragged stateLayer `interactive/selected`
- **elevation:** none on enabled/focus/pressed; hover `color/elevation/6`; dragged `/5`
- **spacing:** stateLayer padding/gap `spacing/100`
- **naming:** Renamed from Material `.Building Blocks/Card states/Filled`

### Token rules

- `color/background-surface/2`
- `border/radius/300`
- `interactive/hover | pressed | selected`
- `color/actions/primary` (focusIndicator)
- `color/elevation/5|6`
- `spacing/100`

### Composition

- `stateLayer` + `focusIndicator` (`state=focus`)
- Card parents (Stacked / Horizontal)

---

## CardOutlinedItem

**Node ID:** `4170:4552`

AI-READY INTERNAL COMPONENT: CardOutlinedItem — outlined Card surface building block (state shell). Props: `state=enabled|hover|focus|pressed|dragged`; `showFocusIndicator` (BOOLEAN, default true — meaningful on `state=focus`). Anatomy: `stateLayer` (+ `focusIndicator` on focus, outside stroke). Content is composed by parent Card over this surface. Tokens: `color/background-surface/0` (root fill); `color/border/2` (1px outline all states); `border/radius/300`; Interaction fills: hover uses stateLayer `interactive/hover`; pressed uses root fill `interactive/pressed` over `surface/0` (stateLayer empty); dragged uses stateLayer `interactive/selected`; enabled/focus stateLayer empty; stateLayer padding/gap `spacing/100`; focusIndicator: outside stroke `color/actions/primary` (toggled by `showFocusIndicator`); elevation: DROP_SHADOW `color/elevation/6` on hover; `color/elevation/5` on dragged. No disabled state on this surface item (intentional — disabled belongs to parent Card/actions). No appearance/inverse variant (intentional). Do not use as Card, Elevated/Filled surface, Button, or a content layout. React mapping: CardOutlinedItem(state, showFocusIndicator). Code Connect is not configured.

### Variants

- **state:** enabled | hover | focus | pressed | dragged

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | enabled \| hover \| focus \| pressed \| dragged |
| `showFocusIndicator` | boolean — default true; toggles focusIndicator on `state=focus` |

### Rules

- **surfaceOnly:** Outlined state shell — content composed by parent Card
- **outlineAllStates:** `color/border/2` 1px outline on all states including focus
- **stateLayerFills:** enabled/focus empty; hover `interactive/hover` on stateLayer; pressed `interactive/pressed` on root (stateLayer empty); dragged `interactive/selected` on stateLayer
- **pressedFill:** pressed = root `color/background-surface/0` + `interactive/pressed`; stateLayer empty (manual sync)
- **focusRing:** focusIndicator outside stroke `color/actions/primary`; `showFocusIndicator` default true
- **elevation:** hover DROP_SHADOW `color/elevation/6`; dragged `color/elevation/5`
- **spacing:** stateLayer padding/gap `spacing/100`
- **noDisabled:** No disabled on this surface — belongs to parent Card/actions
- **noInverse:** No appearance/inverse (intentional)

### Token rules

- `color/background-surface/0`
- `color/border/2`
- `border/radius/300`
- `interactive/hover` (stateLayer)
- `interactive/pressed` (root, pressed state)
- `interactive/selected` (stateLayer, dragged)
- `color/actions/primary` (focusIndicator)
- `color/elevation/6` (hover shadow)
- `color/elevation/5` (dragged shadow)
- `spacing/100` (stateLayer padding/gap)

### Accessibility

Focus ring via `showFocusIndicator` on `state=focus`; disabled semantics belong to parent Card.

### Composition

- `stateLayer`
- `focusIndicator` (`state=focus`)
- Card / Stacked card / Horizontal card (parents)

---

## Carousel

**Node ID:** `4152:849`

AI-READY COMPONENT: Carousel — horizontal content carousel shell with nested pagination dots. Props: `slot` (SLOT — content slides); `showPaginationItem` (BOOLEAN, default true) toggles CarouselPaginationItem visibility. Anatomy: `slot` (horizontal, gap `spacing/100`, clips content) + CarouselPaginationItem (exposed; itemCount × itemView sparse). Demo shell width is FIXED 360 (mobile exemplar); slot hugs slide height. Slides belong in slot — default demo uses four slide frames; prefer ImageItem (preferredValues) or product cards for real content. Interaction model in design: dots + horizontal swipe/peek of adjacent slides — no prev/next chevron controls on this shell (intentional). Use CarouselPaginationItem for dots only. No status axis and no appearance/inverse variant (intentional). Tokens: `spacing/0` (shell gap); `spacing/100` (slot gap between slides); nested pagination tokens from CarouselPaginationItem. Accessibility: announce current page via pagination props; provide accessible names for slide content in slot; hide pagination from AT when `showPaginationItem=false` if slides are the only context. React mapping: Carousel(slot/children, showPaginationItem, itemCount, itemView). Code Connect is not configured.

### Variants

_(none — single shell component)_

### Props

| Prop | Tipo / valores |
|---|---|
| `slot` | SLOT — content slides; preferredValues includes ImageItem; `stretchChildOnInsert=true` |
| `showPaginationItem` | boolean — default true; toggles nested CarouselPaginationItem visibility |
| `carouselPaginationItem` | Exposed nested CarouselPaginationItem (`itemCount` × `itemView`) |

### Rules

- **paginationNested:** CarouselPaginationItem is the dots control — not a slide; exposed for parent edits
- **showPaginationItem:** BOOLEAN default true — wires CarouselPaginationItem.visible
- **slidesInSlot:** Slide content belongs in slot; demo ships 4 slide frames; prefer ImageItem via preferredValues
- **noChevrons:** No prev/next chevron controls — dots + swipe/peek only (intentional)
- **demoWidth:** Shell FIXED 360 is a mobile exemplar; slot hugs slide height
- **stretchOnInsert:** slot `stretchChildOnInsert=true`
- **noInverse:** No appearance/inverse on this shell (intentional)

### Token rules

- `spacing/0` (shell itemSpacing)
- `spacing/100` (slot gap between slides)
- inherits CarouselPaginationItem tokens for nested dots

### Accessibility

Announce current page via pagination props; provide accessible names for slide content in slot; hide pagination from AT when `showPaginationItem=false` if slides are the only context.

### Composition

- `slot` (slides; demo `slide1`–`slide4`)
- CarouselPaginationItem (exposed; toggled by `showPaginationItem`)

---

## CarouselPaginationItem

**Node ID:** `4152:495`

AI-READY INTERNAL COMPONENT: CarouselPaginationItem — pagination dots used inside Carousel (not a slide/card). Props: `itemCount=2|3|4|5`; `itemView=1|2|3|4|5` (sparse matrix: itemView must be â‰¤ itemCount; 14 published variants). Anatomy: `dots` row of solid ellipse nodes (`dot1â€¦dotN`). Active index = `itemView` uses `color/actions/primary`; inactive dots use `color/border/2`. Geometry tokens: dot size `spacing/100`; dots gap `spacing/100`; root vertical padding `spacing/100`; other paddings/gaps `spacing/0`. Compose only inside Carousel (exposed as nested pagination). Do not use as Carousel slide, ProgressBar, StepProgressIndicator, or Tabs. No appearance/inverse axis (intentional). Accessibility: decorative pagination indicator — announce page X of Y on the parent Carousel; dots themselves are not focus targets in design. React mapping: CarouselPaginationItem(itemCount, itemView). Code Connect is not configured.

### Variants

- **itemCount:** 2 | 3 | 4 | 5
- **itemView:** 1 | 2 | 3 | 4 | 5

### Props

| Prop | Tipo / valores |
|---|---|
| `itemCount` | 2 \| 3 \| 4 \| 5 — number of dots |
| `itemView` | 1 \| 2 \| 3 \| 4 \| 5 — active index; must be â‰¤ itemCount (sparse 14) |

### Rules

- **sparseMatrix:** Published 14/20 — itemView must be â‰¤ itemCount
- **activeDot:** Active index = itemView → `color/actions/primary`; others `color/border/2`
- **composeOnly:** Compose inside Carousel — not a slide, ProgressBar, StepProgress, or Tabs
- **geometryTokens:** dot size `spacing/100`; dots gap `spacing/100`; root padY `spacing/100`; other gaps/pads `spacing/0`
- **localTokensOnly:** Local kebab `spacing/*` only — no remote `Spacing/*` Title Case
- **noInverse:** No appearance/inverse axis (intentional)
- **naming:** Renamed from CarouselItem — pagination dots, not carousel slides

### Token rules

- `color/actions/primary` (active dot)
- `color/border/2` (inactive dots)
- `spacing/100` (dot width/height + dots itemSpacing + root paddingTop/Bottom)
- `spacing/0` (remaining paddings/gaps)

### Accessibility

Decorative pagination indicator — announce page X of Y on the parent Carousel; dots are not focus targets in design.

### Composition

- `dots` (`dot1â€¦dotN`)
- Carousel (parent; exposed)

---

## Calendar

**Node ID:** `3982:5542`

AI-READY COMPONENT: Calendar is the Design System 2.0 date-selection panel used with InputDatePicker (compose the panel externally — never nest Calendar inside the field). It renders the month grid, optional period navigation, month/year unit strip, local actions, and (on complete/web) preset select lists. Variants use an intentional sparse matrix (8 published): mode × picker × platform. mode: simple | month | month-year | complete | time. picker: default | month | year (meaningful mainly with mode=month-year). platform: mobile | web (complete publishes both; other modes publish mobile demos). Anatomy by mode: simple = `monthTitle` TEXT + weekday headers + CalendarDay grid + local actions; month = selectionRow with CalendarPeriodNav (`periodNav`, exposed) + grid + actions; month-year = selectionRow with DatePickerSelect (`datePickerSelect`, exposed) + optional month/year ListActionDropdownItem lists when picker=month|year; complete/web = Select presets column (`showSelectItems`) + CalendarPeriodNav + grid + feedback + actions; complete/mobile = intentional dual-month range (two `periodNav` + two grids) + feedback range summary + actions; time = DatePickerSelect (month-year) + `timePicker` columns built from ListActionDropdownItem rows (placeholder hour/minute lists — not a dedicated TimePicker atom). Props: `monthTitle` (TEXT) — month heading on mode=simple; `showSelectItems` (BOOLEAN) — toggles preset list column on mode=complete + platform=web only. Nested `periodNav` and `datePickerSelect` (incl. nested month/year) are exposed. Local actions `clearAction` / `cancelAction` / `confirmAction` are NOT exposed. Demo grids include representative CalendarDay kinds/states (today, hover, focus, selected, range-*, disabled). Do not use Calendar as InputDatePicker, CalendarDay alone, DatePickerSelect alone, or a remote day-cell library. Token rule: local S2 kebab-case only. React mapping: Calendar(mode, picker, platform, monthTitle, showSelectItems, â€¦exposed nested props). Code Connect is not configured.

### Variants

- **mode:** simple | month | month-year | complete | time
- **picker:** default | month | year
- **platform:** mobile | web

### Props

| Prop | Tipo / valores |
|---|---|
| `mode` | simple \| month \| month-year \| complete \| time |
| `picker` | default \| month \| year — meaningful mainly with mode=month-year |
| `platform` | mobile \| web — complete publishes both; other modes publish mobile demos |
| `monthTitle` | TEXT — month heading on mode=simple (e.g. Setembro de 2025); `body/medium/medium` |
| `showSelectItems` | BOOLEAN — show auxiliary select/preset list column (mode=complete, platform=web; wired to Select frame) |
| `periodNav` | Exposed nested CalendarPeriodNav (`periodLabel` etc.) on mode=month\|complete |
| `datePickerSelect` | Exposed nested DatePickerSelect on mode=month-year\|time |

### Rules

- **externalPanel:** Compose Calendar externally with InputDatePicker — never nest inside the field
- **sparseMatrix:** Intentional sparse 8/30 published variants (mode × picker × platform)
- **showSelectItemsScope:** `showSelectItems` only applies to mode=complete + platform=web
- **exposedNested:** Only `periodNav` and `datePickerSelect` (incl. nested month/year) are exposed — local actions are not
- **localActions:** `clearAction` / `cancelAction` / `confirmAction` — not exposed; demo enabled
- **completeMobileDual:** complete/mobile is an intentional dual-month range layout
- **timePlaceholder:** time mode hour/minute columns use ListActionDropdownItem placeholders — not a TimePicker atom
- **demoStates:** simple/month demos include today, hover, focus, selected, range-*, disabled CalendarDay cells
- **localDividersOnly:** Use local DividerVertical / DividerHorizontal — no remote Vertical/Horizontal
- **vsFieldOrCell:** Not InputDatePicker, not standalone CalendarDay, not DatePickerSelect alone

### Token rules

- `color/background-surface/0|2`
- `text/primary`
- `color/border/2`
- `spacing/*`; `border/radius/*`
- `font-family/base`; `font/size/*`; `font/line-height/*`; `letter-spacing/default`
- `body/medium/medium` (`monthTitle`); `body/large/*` (CalendarDay cells)
- `color/elevation/5` (drop shadow)
- local DividerVertical / DividerHorizontal (middle-inset)

### Accessibility

role=dialog or complementary for the panel; CalendarDay gridcell semantics in the grid; announce selection changes.

### Composition

- CalendarDay (month grid cells)
- CalendarPeriodNav (`periodNav`, exposed)
- DatePickerSelect (`datePickerSelect`, exposed)
- Button (`clearAction` / `cancelAction` / `confirmAction` — not exposed)
- ListActionDropdownItem (presets / month-year / time placeholder lists)
- DividerVertical / DividerHorizontal
- InputDatePicker (external trigger)

---

## CalendarDay

**Node ID:** `3950:12809`

AI-READY COMPONENT: CalendarDay is the Design System 2.0 day cell used inside Calendar month grids (InputDatePicker panel composition). Hit target 48×48 with a 40×40 pill container and state-layer. Variants: kind × state (30). kind: default | today | range-start | range-middle | range-end | outside. state: default | hover | focus | selected | disabled. Visual rules: today shows border ring (`color/border/1`) when not selected/disabled; selected and range-start/range-end use `color/actions/primary` fill with `text/on-color`; range-* kinds use `color/background-surface/2` track (cleared on disabled); outside uses muted placeholder text; focus uses `interactive/focus` stroke; hover uses `interactive/hover` (`interactive/pressed` when already selected / range ends). Props: `day` (TEXT) — day-of-month number. Compose inside Calendar grid — do not use as standalone date field (use InputDatePicker). Accessibility: role=gridcell; aria-selected when selected; aria-current=date for today; aria-disabled when disabled; outside days are adjacent-month. Token rule: local S2 kebab-case only. React mapping: CalendarDay(kind, state, day). Code Connect is not configured.

### Variants

- **kind:** default | today | range-start | range-middle | range-end | outside
- **state:** default | hover | focus | selected | disabled

### Props

| Prop | Tipo / valores |
|---|---|
| `kind` | default \| today \| range-start \| range-middle \| range-end \| outside |
| `state` | default \| hover \| focus \| selected \| disabled |
| `day` | TEXT — day-of-month number shown in the cell |

### Rules

- **gridCellOnly:** Compose inside Calendar month grid — not a standalone date field (use InputDatePicker)
- **hitTarget:** 48×48 hit target with 40×40 pill container + state-layer
- **todayRing:** `kind=today` shows `color/border/1` ring when not selected/disabled; focus replaces with `interactive/focus`
- **rangeTrack:** `range-*` kinds use `color/background-surface/2` root track; cleared on `state=disabled`
- **selectedPrimary:** selected and range-start/end use `color/actions/primary` + `text/on-color`
- **hoverPressed:** hover uses `interactive/hover`; when already selected (incl. range ends) hover uses `interactive/pressed`
- **vsListItem:** Analogous to ListActionDropdownItem for calendar grids — not a menu row

### Token rules

- `spacing/0|050`
- `border/radius/full`
- `color/actions/primary`
- `color/background-surface/2` (range track)
- `color/border/1` (today ring)
- `interactive/hover|pressed|focus`
- `text/primary|on-color|placeholder`
- `body/large/*` typography tokens

### Accessibility

role=gridcell; aria-selected when selected; aria-current=date for today; aria-disabled when disabled; outside days are adjacent-month.

### Composition

- Calendar (parent month panel)
- InputDatePicker (external trigger)

---

## CalendarPeriodNav

**Node ID:** `3995:5664`

AI-READY COMPONENT: CalendarPeriodNav is the Design System 2.0 mobile period navigator for Calendar / date-picker surfaces. It changes the visible period in the viewer (month/year step and optional month-year picker entry). Prefer on Display=Mobile calendar headers and date bottom sheets — not for list/table Pagination. Variants: appearance × previousDisabled × nextDisabled (8). appearance: default | inverse. previousDisabled/nextDisabled: false | true (boundary of navigable range). Anatomy: previousAction (Button text/sm icon-only chevron-left-outline) + periodAction (FRAME with periodLabel TEXT + expandIcon chevron-down-outline) + nextAction (Button text/sm icon-only chevron-right-outline). periodAction opens month/year selection when the product supports Calendar Select=Month|Year — implement as a button in product code (aria-haspopup) even though the Figma layer is a FRAME, not a nested Button instance. previous/next step the visible period. appearance=default: transparent root; actions/label text/primary; disabled chevrons text/placeholder. appearance=inverse: root fill color/background-surface/inverse-3; actions/label text/on-color; disabled chevrons text/on-color-disabled. Props: periodLabel (TEXT) — visible period, e.g. "Abril 2025". Nested Button labels carry accessible names (PerÃ­odo anterior / PrÃ³ximo perÃ­odo). Do not use as Pagination, PaginationItem, PaginationSelectInput, or InputDatePicker field. Compose with Calendar + CalendarDay grid. Accessibility: toolbar/group; icon-only buttons need accessible names; periodAction maps to a button that may set aria-haspopup; announce period changes with aria-live when stepped. Token rule: local S2 kebab-case only. React mapping: CalendarPeriodNav(appearance, previousDisabled, nextDisabled, periodLabel). Code Connect is not configured.

### Variants

- **appearance:** default | inverse
- **previousDisabled:** false | true
- **nextDisabled:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `appearance` | default \| inverse — inverse for dark/on-color calendar surfaces |
| `previousDisabled` | false \| true — boundary of navigable range (VARIANT axis) |
| `nextDisabled` | false \| true — boundary of navigable range (VARIANT axis) |
| `periodLabel` | TEXT — visible period string (e.g. Abril 2025) |

### Rules

- **mobilePeriodNav:** Prefer Display=Mobile calendar headers and date bottom sheets — not list/table Pagination
- **periodActionFrame:** `periodAction` is a FRAME (`periodLabel` + `expandIcon`), not a nested Button — map to button in product with `aria-haspopup`
- **prevNextButtons:** `previousAction`/`nextAction` are local Button text/sm icon-only with accessible labels
- **appearanceInverse:** `appearance=inverse`: root `color/background-surface/inverse-3`; on-color texts; disabled `text/on-color-disabled`
- **vsPagination:** Do not use as Pagination, PaginationItem, PaginationSelectInput, or InputDatePicker field

### Token rules

- default: transparent root; `text/primary`; disabled `text/placeholder`
- inverse: `color/background-surface/inverse-3`; `text/on-color`; disabled `text/on-color-disabled`
- `spacing/100|200|250|500`; nested Button component tokens
- `body/medium/*` periodLabel; Button `body/small/*`

### Accessibility

toolbar/group; icon-only buttons need accessible names; periodAction maps to button with optional aria-haspopup; announce period changes with aria-live when stepped.

### Composition

- Button (previousAction / nextAction)
- chevron-left-outline / chevron-down-outline / chevron-right-outline
- Calendar + CalendarDay (parent surface)

---

## DatePickerSelectItem

**Node ID:** `3982:5083`

AI-READY COMPONENT: DatePickerSelectItem is the Design System 2.0 compact select trigger used as a building block inside DatePicker surfaces to pick a date unit — day, month or year. It is the trigger only; the options menu/list is never nested — compose ListActionDropdown (or equivalent) externally when expanded=true. Variants: unit × state × expanded (21). unit: day | month | year. state: default | hover | focus | disabled. expanded: false | true. Intentional sparse: state=disabled only publishes expanded=false. Anatomy: value (TEXT) + trailingIcon. expanded=false → chevron-down-outline; expanded=true → chevron-up-outline + interactive/focus stroke. hover → interactive/hover fill. focus (closed) → interactive/focus stroke. disabled → text/placeholder on value and icon, no focus stroke. Props: value (TEXT) — shared across all variants in the set (canvas default "21"); override per instance for unit demos (day "21", month "Abril", year "2025"). Min widths differ by unit (day compact, month wider). Compose three blocks in a row for day+month+year pickers. Do not use as InputDatePicker field, InputSelect, SelectCountry, CalendarDay or CalendarPeriodNav. Accessibility: combobox/button trigger; aria-expanded mirrors expanded; accessible name should include unit (day/month/year) plus value; disabled via aria-disabled. Token rule: local S2 kebab-case semantic only. React mapping: DatePickerSelectItem(unit, state, expanded, value). Code Connect is not configured.

### Variants

- **unit:** day | month | year
- **state:** default | hover | focus | disabled
- **expanded:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `unit` | day \| month \| year — date unit this trigger selects |
| `state` | default \| hover \| focus \| disabled |
| `expanded` | false \| true — open/closed; intentional sparse: disabled only with `expanded=false` |
| `value` | TEXT — visible selected unit value (shared across set; canvas default `21`; set per instance for month/year demos) |

### Rules

- **triggerOnly:** Trigger only — compose ListActionDropdown (or equivalent) externally when `expanded=true`; never nest the menu
- **intentionalSparseDisabled:** `state=disabled` publishes `expanded=false` only (no disabled+expanded=true)
- **sharedValueProp:** `value` TEXT is one shared component property — canvas demos show default `21`; override on instances for Abril/2025
- **vsOtherPickers:** Do not use as InputDatePicker field, InputSelect, SelectCountry, CalendarDay or CalendarPeriodNav
- **rowComposition:** Compose three blocks in a row for day+month+year pickers

### Token rules

- hover: `interactive/hover` fill
- focus / expanded: `interactive/focus` stroke
- disabled: `text/placeholder` on value and icon
- local S2 kebab-case semantic only; local `chevron-down-outline` / `chevron-up-outline`

### Accessibility

combobox/button trigger; aria-expanded mirrors expanded; accessible name should include unit (day/month/year) plus value; disabled via aria-disabled.

### Composition

- chevron-down-outline / chevron-up-outline
- ListActionDropdown (external menu)
- DatePicker / Calendar surfaces (parent)

---

## DatePickerSelect

**Node ID:** `4004:2227`

AI-READY COMPONENT: DatePickerSelect is the Design System 2.0 composed date-unit selector. It arranges one or more DatePickerSelectItem triggers to choose day, month and/or year. It is not the full calendar panel and not InputDatePicker — use it as the compact unit strip inside DatePicker / mobile period flows. Variants: format × state (16). format: day-month-year | day-month | month-year | year. state: default | hover | focus | disabled — applied to all nested DatePickerSelectItem instances (expanded stays false on the composed strip; open a single block externally when needed). Anatomy: horizontal auto-layout of nested DatePickerSelectItem (named day / month / year). Gap spacing/100 (8). Nested day/month/year instances are exposed so each block value (TEXT) is editable from the parent properties panel. Demo defaults: day "21", month "Abril", year "2025". Options menus are never nested here — compose ListActionDropdown (or equivalent) per block when that unit is expanded. Do not use as InputDatePicker, Calendar, CalendarDay, CalendarPeriodNav or InputSelect. Accessibility: group/toolbar of unit comboboxes; each nested block keeps its own accessible name (unit + value); disabled propagates to all units. Token rule: inherits DatePickerSelectItem semantic tokens. Figma props: format, state, plus exposed nested DatePickerSelectItem value (and other nested props — keep nested unit/state/expanded aligned with the parent variant in product). React mapping: DatePickerSelect(format, state, dayValue?, monthValue?, yearValue?) where *Value maps to the exposed nested block value. Code Connect is not configured.

### Variants

- **format:** day-month-year | day-month | month-year | year
- **state:** default | hover | focus | disabled

### Props

| Prop | Tipo / valores |
|---|---|
| `format` | day-month-year \| day-month \| month-year \| year — which unit blocks are composed |
| `state` | default \| hover \| focus \| disabled — applied to all nested blocks |
| `dayValue` | React/product — maps to exposed nested `day` DatePickerSelectItem `value` (demo `21`) |
| `monthValue` | React/product — maps to exposed nested `month` DatePickerSelectItem `value` (demo `Abril`) |
| `yearValue` | React/product — maps to exposed nested `year` DatePickerSelectItem `value` (demo `2025`) |

### Rules

- **composedStrip:** Composed DatePickerSelectItem strip — not InputDatePicker field, Calendar panel, or InputSelect
- **nestedExposed:** `day`/`month`/`year` instances exposed; edit `value` from parent panel; keep nested `unit`/`state`/`expanded` aligned with parent variant
- **noNestedMenu:** Options menus never nested — compose ListActionDropdown externally per expanded unit
- **expandedFalseOnStrip:** Strip demos keep nested `expanded=false`; open a single block externally when needed
- **gapSpacing100:** Horizontal gap bound to `spacing/100`

### Token rules

- inherits DatePickerSelectItem semantic tokens
- root gap: `spacing/100`
- local S2 kebab-case only

### Accessibility

group/toolbar of unit comboboxes; each nested block keeps its own accessible name (unit + value); disabled propagates to all units.

### Composition

- DatePickerSelectItem (day / month / year)
- ListActionDropdown (external menu per unit)
- DatePicker / mobile period surfaces (parent)

---

## InputDatePicker

**Node ID:** `3985:1386`

AI-READY COMPONENT: InputDatePicker is the Design System 2.0 outlined date-field trigger — same visual identity as Input (height 56, border/radius/200, floating label for content=value|placeholder, resting label for content=label). Variants: state=default|hover|focus|error|disabled; content=value|placeholder|label; leadingIcon=true|false; appearance=default|inverse (60 variants). Trailing calendar-outline is always present; on state=error also shows trailingIconError (alert-circle-outline). Calendar panel (month grid) is NOT nested — compose the Calendar component externally below/anchored to the field when open. appearance=default: field fill color/background-surface/0; default border color/border/1; label text/secondary (focus text/brand); placeholder text/placeholder; value text/primary; leading/trailing icon strokes text/secondary (focus text/brand, disabled text/placeholder, error alert feedback/danger with calendar text/primary). appearance=inverse: field fill transparent; floatingLabel cutout color/background-surface/inverse-3 (all inverse states including focus); default/disabled border color/border/2; label text/on-color (focus text/brand); placeholder and non-error supporting text/on-color-disabled; value text/on-color; on state=disabled all field texts use text/placeholder-inverse; icons text/on-color (focus text/brand, disabled text/on-color-disabled, error alert feedback/danger with calendar text/on-color). Disabled (appearance=default): no field fill; stroke color/border/1. Feedback borders unchanged — hover color/border-feedback/primary, focus interactive/focus, error color/border-feedback/danger. Props: label, value, placeholder, supportingText, showSupportingText, leading, trailing (INSTANCE_SWAP, default calendar-outline). Do not use as generic Input, InputSelect, Autocomplete, or standalone Calendar panel. Accessibility: associate label; aria-invalid on error; aria-haspopup=dialog when calendar opens; aria-disabled when disabled; visible focus via interactive/focus. Token rule: local S2 kebab-case only. React mapping: InputDatePicker(state, content, leadingIcon, appearance, label, value, placeholder, supportingText, showSupportingText, leading?, trailing?). Code Connect is not configured.

### Variants

- **state:** default | hover | focus | error | disabled
- **content:** value | placeholder | label
- **leadingIcon:** true | false
- **appearance:** default | inverse

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| hover \| focus \| error \| disabled |
| `content` | value \| placeholder \| label |
| `leadingIcon` | true \| false (variant axis) |
| `appearance` | default \| inverse — inverse for dark/on-color surfaces |
| `label` | TEXT — floating or resting field label (demo: Data) |
| `value` | TEXT — selected date (`content=value`) |
| `placeholder` | TEXT — placeholder text (`content=placeholder`) |
| `supportingText` | TEXT — helper or error message |
| `showSupportingText` | boolean |
| `leading` | INSTANCE_SWAP — local DS outline leading icon |
| `trailing` | INSTANCE_SWAP — always-visible calendar (default `calendar-outline`); `alert-circle-outline` on error demos |

### Rules

- **dateTriggerOnly:** Date-field trigger only — calendar panel is composed externally, never nested
- **appearanceInverse:** `appearance=inverse`: transparent field; floatingLabel cutout `inverse-3` including focus; `border/2`; on-color texts; disabled texts `text/placeholder-inverse`; icon disabled `on-color-disabled`; focus label `text/brand`
- **calendarTrailingAlways:** No `trailingIcon` variant axis — `calendar-outline` always present
- **errorTrailingA11y:** `state=error` always shows `trailingIconError` (alert-circle-outline) beside the calendar icon
- **disabledNoFill:** `appearance=default` disabled: no field fill; stroke `color/border/1`
- **hoverBorder:** state=hover field stroke uses `color/border-feedback/primary`
- **vsInputCalendar:** Do not use as generic Input, InputSelect, Autocomplete, or standalone Calendar panel

### Token rules

- default: `color/background-surface/0`; `color/border/1`; `text/primary|secondary|placeholder|brand`
- inverse: transparent field; cutout `color/background-surface/inverse-3`; `color/border/2`; `text/on-color|on-color-disabled`; disabled texts `text/placeholder-inverse`
- shared feedback: `color/border-feedback/primary|danger`, `interactive/focus`, `feedback/danger`
- no field fill on disabled (`appearance=default`)
- `spacing/050|100|200|300|700`; `border/radius/200`; `border/width/012|025`
- `body/large/regular` value/placeholder/resting; `body/small/regular` floating label/supporting

### Accessibility

Associate label; aria-invalid on error; aria-haspopup=dialog when calendar opens; aria-disabled when disabled; focus via interactive/focus.

### Composition

- Calendar (external panel)
- calendar-outline / alert-circle-outline
- local DS outline icons

---

## InputSelect

**Node ID:** `3898:2755`

AI-READY COMPONENT: InputSelect is the Design System 2.0 outlined select field (floating-label). It is a select trigger — not a free-text Input. Visual identity: outlined container (height 56, border/radius/200), floating label cutout for content=value|placeholder, resting in-field label for content=label. Variants: state=default|hover|focus|error|disabled; content=value|placeholder|label; leadingIcon=true|false; appearance=default|inverse (60 variants). Trailing chevron is always present: chevron-down-outline by default; chevron-up-outline on state=focus. appearance=default: field fill color/background-surface/0; default border color/border/1; label text/secondary (focus text/brand); placeholder text/placeholder; value text/primary; leading/trailing icon strokes text/secondary (focus text/brand, disabled text/placeholder, error leading+trailingIconError feedback/danger with chevron text/primary). appearance=inverse: field fill transparent; floatingLabel cutout color/background-surface/inverse-3; default/disabled border color/border/2; label text/on-color (focus text/brand); placeholder and non-error supporting text/on-color-disabled; value text/on-color; on state=disabled all field texts use text/placeholder-inverse; leadingIcon strokes text/on-color (focus text/brand, disabled text/on-color-disabled, error feedback/danger); trailing chevron text/on-color (focus text/brand, disabled text/on-color-disabled; on error chevron stays text/on-color while trailingIconError uses feedback/danger). Feedback borders unchanged — hover color/border-feedback/primary, focus interactive/focus, error color/border-feedback/danger. Open menu is NOT embedded: screens compose floating ListActionDropdown under the field. Props: label, value, placeholder, supportingText, showSupportingText, leading, trailing. Do not use as Input, InputPassword, InputNumber, PaginationSelectInput, SearchBar or Autocomplete. Accessibility: combobox; aria-expanded/aria-controls when menu open; aria-invalid on error; aria-disabled when disabled. Token rule: local S2 kebab-case only. React mapping: InputSelect(state, content, leadingIcon, appearance, label, value, placeholder, supportingText, showSupportingText, leading?, trailing?). Code Connect is not configured.

### Variants

- **state:** default | hover | focus | error | disabled
- **content:** value | placeholder | label
- **leadingIcon:** true | false
- **appearance:** default | inverse

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| hover \| focus \| error \| disabled |
| `content` | value \| placeholder \| label |
| `leadingIcon` | true \| false (variant axis) |
| `appearance` | default \| inverse — inverse for dark/on-color surfaces |
| `label` | TEXT — floating or resting field label |
| `value` | TEXT — selected option text (`content=value`) |
| `placeholder` | TEXT — placeholder text (`content=placeholder`) |
| `supportingText` | TEXT — helper or error message |
| `showSupportingText` | boolean |
| `leading` | INSTANCE_SWAP — local DS outline icon (default `search-outline`) |
| `trailing` | INSTANCE_SWAP — always-visible chevron (default `chevron-down-outline`; `chevron-up-outline` on `state=focus`); `alert-circle-outline` appears additionally on error |

### Rules

- **selectTriggerOnly:** Select field trigger only — not free-text Input; no caret/typing chrome
- **appearanceInverse:** `appearance=inverse`: transparent field; floatingLabel cutout `inverse-3` on all inverse states including focus; `border/2`; on-color texts; disabled texts `text/placeholder-inverse`; icon disabled `on-color-disabled`; focus label `text/brand`
- **floatingLabel:** Outlined field h=56, radius/200, floating label cutout (same anatomy family as Input)
- **chevronAlways:** No `trailingIcon` variant axis — chevron always present on all variants
- **focusChevronUp:** `state=focus` uses `chevron-up-outline`; all other states use `chevron-down-outline`
- **hoverBorder:** state=hover field stroke uses `color/border-feedback/primary`
- **errorTrailingA11y:** state=error always shows trailingIconError (alert-circle-outline) beside the always-on chevron
- **floatingListActionDropdown:** Do not embed ListActionDropdown in variants — compose floating ListActionDropdown on click in screens/prototypes
- **noExpandedAxis:** No expanded variant axis — open state lives on the screen with floating menu
- **vsInputPagination:** Do not use as Input, PaginationSelectInput, SearchBar, or Textarea

### Token rules

- default: `color/background-surface/0`; `color/border/1`; `text/primary|secondary|placeholder|brand`
- inverse: transparent field; `color/border/2`; cutout `color/background-surface/inverse-3`; `text/on-color|on-color-disabled`; disabled texts `text/placeholder-inverse`
- shared feedback: `color/border-feedback/primary|danger`, `interactive/focus`, `feedback/danger`
- `spacing/050|100|200|300|700`; `border/radius/200`; `border/width/012|025`
- `body/large/regular` value/placeholder/resting; `body/small/regular` floating label/supporting

### Accessibility

Combobox; aria-expanded/aria-controls when floating ListActionDropdown is open; aria-invalid on error; aria-disabled when disabled; focus via interactive/focus.

### Composition

- Floating ListActionDropdown (screen-level, on click — not nested in set)
- ListActionDropdownItem
- local DS outline icons

---

## SearchBar

**Node ID:** `3881:6002`

AI-READY COMPONENT: SearchBar is a compact search entry surface used to display a search hint or current query and launch a SearchView. Use it in application headers, content pages, lists and result-oriented layouts — not as SearchViewFullscreen, SearchViewModal, Input, or Select. Variants: state=default|hover|focus|pressed|disabled; content=placeholder|value (10 variants). Anatomy: pill stateLayer (border/radius/full) with leadingAction (Button text + overlay icon), searchTrigger (placeholder or query), and trailingActions (search / clear Buttons + optional Avatar). Nested Button actions stay at state=default (visual feedback comes from SearchBar stateLayer). Focus uses interactive/focus stroke on stateLayer. Props: showLeadingAction, showFirstTrailingAction, showSecondTrailingAction, showProfileAction, placeholder, query, profileAvatar, leadingIcon, firstTrailingIcon, secondTrailingIcon. Token rule: local S2 kebab-case only — color/background-surface/0, interactive/hover|pressed|disabled-surface|focus, text/primary|secondary|placeholder, border/radius/full, body/large/regular|body/medium/medium. Prefer local DS outline icons. Accessibility: role=search or search landmark; actions as named buttons; decorative overlay icons aria-hidden when the control has an accessible name. React mapping: SearchBar(state, content, placeholder, query, showLeadingAction?, showFirstTrailingAction?, showSecondTrailingAction?, showProfileAction?, leadingIcon?, firstTrailingIcon?, secondTrailingIcon?, profileAvatar?). Code Connect is not configured.

### Variants

- **state:** default | hover | focus | pressed | disabled
- **content:** placeholder | value

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| hover \| focus \| pressed \| disabled (variant axis; nested Buttons stay default) |
| `content` | placeholder \| value (variant axis) |
| `placeholder` | TEXT — hint text (`content=placeholder`) |
| `query` | TEXT — current search text (`content=value`) |
| `showLeadingAction` | boolean — leading text Button (e.g. menu) |
| `showFirstTrailingAction` | boolean — first trailing text Button (e.g. search) |
| `showSecondTrailingAction` | boolean — second trailing text Button (e.g. clear) |
| `showProfileAction` | boolean — trailing Avatar |
| `leadingIcon` | INSTANCE_SWAP — overlay icon on leading Button (local DS outline) |
| `firstTrailingIcon` | INSTANCE_SWAP — overlay icon on first trailing Button (local DS outline) |
| `secondTrailingIcon` | INSTANCE_SWAP — overlay icon on second trailing Button (local DS outline) |
| `profileAvatar` | INSTANCE_SWAP — Avatar for profile action (default initials xs) |

### Rules

- **pillSurface:** stateLayer uses `border/radius/full`; fills `interactive/hover|pressed|disabled-surface` or `color/background-surface/0`
- **focusStroke:** `state=focus` uses `interactive/focus` stroke on stateLayer (weight 2)
- **buttonStateDefault:** Nested `actionSurface` Buttons stay `state=default` / `disabled=false` on all SearchBar variants; feedback is on `stateLayer`
- **overlayIcons:** Action icons are overlays on text Buttons (intentional composition)
- **opensSearchView:** SearchBar is an entry control — compose SearchViewFullscreen or SearchViewModal on activate
- **vsSearchViewsInput:** Do not use as SearchViewFullscreen, SearchViewModal, Input, or Select

### Token rules

- `color/background-surface/0`
- `interactive/hover|pressed|disabled-surface|focus`
- `text/primary|secondary|placeholder`
- `border/radius/full`
- `body/large/regular|body/medium/medium`
- Button + Avatar nested DS tokens

### Accessibility

role=search or search landmark; actions as named buttons; decorative overlay icons aria-hidden when the control has an accessible name.

### Composition

- Button (text)
- Avatar
- local DS outline icons

---

## SearchViewFullscreen

**Node ID:** `3883:16492`

AI-READY COMPONENT: SearchViewFullscreen is the Design System 2.0 full-screen search surface (Material Search view full-screen remapped to S2). Variants: content=value|placeholder; showResults=true|false. Anatomy: header h=56 (back + query/placeholder field + clear) on background/surface/0; DividerHorizontal full-width; results stack of ListItem (2-line + monogram). Props: query (TEXT), placeholder (TEXT), showBack (BOOLEAN), showClear (BOOLEAN), backIcon (INSTANCE_SWAP default arrow-narrow-left-outline), clearIcon (INSTANCE_SWAP default x-outline), items (SLOT preferredValues→ListItem). Clear is shown when content=value. Focus caret uses interactive/focus on value variants. Do not use as SearchBar, Input, Select, or Modal. Prefer ListItem from the local DS in results. Accessibility: search landmark or role=search; back/clear as buttons with accessible names; results as list; decorative icons aria-hidden when labels exist. Token rule: local S2 kebab-case only — color/background-surface/0, text/primary|secondary|placeholder, interactive/focus, body/large/regular, DividerHorizontal and ListItem own nested tokens. React mapping: SearchViewFullscreen(content, showResults, query, placeholder, showBack, showClear, backIcon?, clearIcon?, items?). Code Connect is not configured.

### Variants

- **content:** value | placeholder
- **showResults:** true | false

### Props

| Prop | Tipo / valores |
|---|---|
| `content` | value \| placeholder (variant axis) |
| `showResults` | true \| false (variant axis) |
| `query` | TEXT — typed search text (`content=value`) |
| `placeholder` | TEXT — hint text (`content=placeholder`) |
| `showBack` | boolean |
| `showClear` | boolean |
| `backIcon` | INSTANCE_SWAP — local DS outline (default `arrow-narrow-left-outline`) |
| `clearIcon` | INSTANCE_SWAP — local DS outline (default `x-outline`) |
| `items` | SLOT — preferredValues `ListItem`; default 5 ListItems in results |

### Rules

- **materialRemap:** Remapped from Material Search view full-screen to local S2 tokens/icons/typography
- **header56:** Header height 56 on `background/surface/0`
- **clearOnValue:** showClear / clear icon visible when `content=value`
- **resultsListItem:** Results compose ListItem 2-line + monogram; DividerHorizontal full-width above
- **vsSearchBarInput:** Do not use as SearchBar, SearchViewModal, Input, Select, or Modal

### Token rules

- `color/background-surface/0`
- `text/primary|secondary|placeholder`
- `interactive/focus` for caret
- `body/large/regular`
- DividerHorizontal + ListItem nested DS tokens

### Accessibility

role=search or search landmark; back/clear as named buttons; results as list; decorative icons aria-hidden when labels exist.

### Composition

- DividerHorizontal
- ListItem
- local DS outline icons

---

## SearchViewModal

**Node ID:** `3887:507`

AI-READY COMPONENT: SearchViewModal is the Design System 2.0 modal search surface (Material Search view modal remapped to S2). Variants: content=value|placeholder; showResults=true|false. Anatomy: rounded card (border/radius/800) with header h=56 (back + query/placeholder field + clear) on color/background-surface/0; DividerHorizontal full-width; results stack of ListItem (2-line + monogram). Props: query (TEXT), placeholder (TEXT), showBack (BOOLEAN), showClear (BOOLEAN), backIcon (INSTANCE_SWAP default arrow-narrow-left-outline), clearIcon (INSTANCE_SWAP default x-outline), items (SLOT preferredValues→ListItem). Clear is shown when content=value. Focus caret uses interactive/focus on value variants. Do not use as SearchViewFullscreen, SearchBar, Input, Select, or generic Modal. Prefer ListItem from the local DS in results. Accessibility: search landmark or role=search; back/clear as buttons with accessible names; results as list; decorative icons aria-hidden when labels exist. Token rule: local S2 kebab-case only — color/background-surface/0, text/primary|placeholder, interactive/focus, border/radius/800, body/large/regular, DividerHorizontal and ListItem own nested tokens. React mapping: SearchViewModal(content, showResults, query, placeholder, showBack, showClear, backIcon?, clearIcon?, items?). Code Connect is not configured.

### Variants

- **content:** value | placeholder
- **showResults:** true | false

### Props

| Prop | Tipo / valores |
|---|---|
| `content` | value \| placeholder (variant axis) |
| `showResults` | true \| false (variant axis) |
| `query` | TEXT — typed search text (`content=value`) |
| `placeholder` | TEXT — hint text (`content=placeholder`) |
| `showBack` | boolean |
| `showClear` | boolean |
| `backIcon` | INSTANCE_SWAP — local DS outline (default `arrow-narrow-left-outline`) |
| `clearIcon` | INSTANCE_SWAP — local DS outline (default `x-outline`) |
| `items` | SLOT — preferredValues `ListItem`; default 5 ListItems in results |

### Rules

- **materialRemap:** Remapped from Material Search view modal to local S2 tokens/icons/typography
- **modalRadius:** Root card uses `border/radius/800` (32) — nearest S2 token to Material 28
- **header56:** Header height 56 on `color/background-surface/0`
- **clearOnValue:** showClear / clear icon visible when `content=value`
- **resultsListItem:** Results compose ListItem 2-line + monogram; DividerHorizontal full-width above
- **vsFullscreenSearchBar:** Do not use as SearchViewFullscreen, SearchBar, Input, Select, or generic Modal

### Token rules

- `color/background-surface/0`
- `text/primary|placeholder`
- `interactive/focus` for caret
- `border/radius/800`
- `body/large/regular`
- DividerHorizontal + ListItem nested DS tokens

### Accessibility

role=search or search landmark; back/clear as named buttons; results as list; decorative icons aria-hidden when labels exist.

### Composition

- DividerHorizontal
- ListItem
- local DS outline icons

---

## Breadcrumb

**Node ID:** `3681:4674`

AI-READY COMPONENT: Breadcrumb is a navigation pattern that communicates the current page position within a hierarchy. Use size=md for standard density and size=sm for compact layouts. Props: showIcon toggles leadingIcon; icon swaps the local DS outline icon, with home-outline as the default. Composition: leadingIcon + items. The default items composition uses four local BreadcrumbItem instances named item01, overflowItem, item02 and currentItem. overflowItem uses BreadcrumbItem type=overflow state=default to collapse intermediate hierarchy; currentItem uses state=current and must hide its trailing slash. Do not restore hidden fixed item slots or remote breadcrumb/menu kits. Do not remove the slash layer owned by BreadcrumbItem on non-current items and do not add underline states. Layout must remain single-line and hug content; for narrower containers, collapse intermediate items into overflow rather than wrapping arbitrarily. Token rule: use existing DS kebab-case variables only — spacing/100 for md gaps, spacing/050 for sm gaps, plus nested BreadcrumbItem tokens. Icons must come from the local DS icon library; 16px outline icons use proportional stroke around 1.33px. Accessibility: map Breadcrumb to nav with aria-label=Breadcrumb and an ordered list; link items map to anchors; currentItem maps to aria-current=page; overflowItem maps to a button and uses aria-expanded when its local ListActionDropdown is open; slash and decorative leadingIcon are aria-hidden; skeleton items are non-interactive. React mapping: Breadcrumb(size, showIcon, icon, children as BreadcrumbItem[]). Code Connect is not configured.

### Variants

- **size:** md | sm

### Props

| Prop | Tipo / valores |
|---|---|
| `size` | md \| sm |
| `showIcon` | boolean — toggles leadingIcon (default true) |
| `icon` | INSTANCE_SWAP — local DS outline icon (default home-outline) |

### Rules

- **composeBreadcrumbItem:** Compose with local BreadcrumbItem only — item01, overflowItem, item02, currentItem
- **hideCurrentSlash:** currentItem must hide trailing slash
- **noUnderline:** Never use underline for interaction states
- **singleLineHug:** Keep single-line hug layout; use overflow to collapse intermediate crumbs
- **localIcon16:** leadingIcon uses local 16px outline icons with proportional stroke (~1.33px)
- **vsRemote:** Do not use remote breadcrumb/menu kits

### Token rules

- `spacing/100` for md gaps
- `spacing/050` for sm gaps
- nested BreadcrumbItem tokens

### Accessibility

nav aria-label=Breadcrumb + ordered list; links as anchors; current → aria-current=page; overflow → button with aria-expanded when open; slash and leadingIcon aria-hidden; skeleton non-interactive.

### Composition

BreadcrumbItem, home-outline

---
## BreadcrumbItem

**Node ID:** `3681:3667`

AI-READY COMPONENT: BreadcrumbItem is the internal item used to compose the Breadcrumb navigation pattern. Use size=sm|md for density, type=link for navigable crumbs and type=overflow for the collapsed menu trigger, and state=default|hover|focus|pressed|current|skeleton|open for interaction and loading. Props: label controls the visible crumb text on type=link. Composition: always keep the leading decorative slash layer named slash with visible text "/ "; linkItem (type=link) or overflowButton (type=overflow); state=open on type=overflow nests a local ListActionDropdown as an absolute overlay under the trigger (root hugs the trigger row only). Open demo width follows the menu content hug — do not force a fixed 240px panel in the component set demo. Do not remove the slash. Do not use underline for any visual state — hover/pressed use interactive fills and text color; focus uses an outside stroke with interactive/focus on linkItem/overflowButton (no separate focusRing layer on BreadcrumbItem); open uses interactive/selected on the overflow trigger. Intentional sparse matrix: no link+open; no overflow+current; no overflow+skeleton. Do not use remote menu kits — nest local ListActionDropdown + ListActionDropdownItem only. Do not use BreadcrumbItem as a standalone Button, Tab, Chip, Menu or page title. Token rule: use existing DS kebab-case variables only — text/primary|secondary|brand, interactive/hover|pressed|selected|focus, color/background-surface/0, plus nested ListActionDropdown tokens (including elevation/2). Accessibility: parent Breadcrumb maps to nav aria-label="Breadcrumb" + ordered list; link items map to anchors when navigable; state=current maps to aria-current="page"; type=overflow maps to a button with aria-expanded true when state=open; slash is decorative (aria-hidden="true"); state=skeleton is non-interactive and must not receive focus. React mapping: BreadcrumbItem(size, type, state, label, children?) where open overflow children map to ListActionDropdown content.
### Variants

- **size:** sm | md
- **type:** link | overflow
- **state:** default | hover | focus | pressed | current | skeleton | open

### Props

| Prop | Tipo / valores |
|---|---|
| `label` | breadcrumb item text (wired on type=link) |
| `size` | sm \| md |
| `type` | link \| overflow |
| `state` | default \| hover \| focus \| pressed \| current \| skeleton \| open |

### Rules

- **internalOnly:** Use inside Breadcrumb only
- **keepSlash:** Always preserve decorative slash layer with text "/ "
- **noUnderline:** Never use underline for hover/pressed/focus
- **focusStroke:** Focus uses outside stroke interactive/focus on linkItem/overflowButton — no separate focusRing layer
- **openOverlay:** state=open nests local ListActionDropdown as absolute overlay; root hugs trigger row
- **openShowDivider:** Demo open variants use showDivider=false unless a DividerHorizontal is present in the slot
- **openWidthHug:** Open demo panel width follows menu content hug — do not force fixed 240px in the component-set demo
- **sparseMatrix:** Intentional sparse: no link+open; no overflow+current; no overflow+skeleton
- **vsStandalone:** Do not use as Button, Tab, Chip, Menu or page title
- **localMenuOnly:** Nest local ListActionDropdown + ListActionDropdownItem only — no remote menu kits

### Token rules

- `text/primary` | `secondary` | `brand`
- `interactive/hover` | `pressed` | `selected` | `focus`
- `color/background-surface/0`
- nested ListActionDropdown tokens including `elevation/2`

### Accessibility

Parent Breadcrumb: nav aria-label=Breadcrumb + ordered list; link items as anchors; current → aria-current=page; overflow → button with aria-expanded when open; slash aria-hidden; skeleton non-interactive.

---


## Keyboard

**Node ID:** `3745:4228`

AI-READY COMPONENT: Keyboard is a placement-only on-screen keyboard utility for prototypes and wireframes. It is not a product input component and is not an accurate representation of Android Gboard or any OS keyboard. Use configuration=base-keyboard for the default alphabet layout, configuration=alphanumeric for mixed letter/number layouts, configuration=keypad for dialer-style keys, and configuration=numeric-only for digits-only entry. Use layout=portrait for stacked mobile portrait chrome, layout=landscape for wide landscape chrome, and layout=floating for a compact floating keyboard panel. Do not use Keyboard as TextInput, Button, Modal, Bottom sheet, or a real IME implementation. Composition is decorative placement chrome (toolbar, key rows, bottomNav nesting local MobileGestureNavigation appearance=default) — keep keys as non-interactive visual placeholders in design. Prefer local DS outline icons for toolbar and modifiers (shiftIcon, backspaceIcon, enterKey icon, gifIcon via photo-outline). Token rule: use existing DS kebab-case variables only — color/background-surface/0|1|2, text/primary|secondary|brand|on-color, color/actions/primary|secondary, color/border/1|2, border/radius/100|200|300|full, spacing/050|100|150|200|300 — never Schemes/* or M3/sys/*. Typography: key labels use body/large/regular; compact modifier labels use body/medium/medium. Accessibility: treat as decorative prototype chrome in design specs; in product UI, real text entry must use native OS keyboard / platform IME, not this component. React mapping: Keyboard(configuration, layout) for prototype mocks only. Code Connect is not configured.

### Variants

- **configuration:** base-keyboard | alphanumeric | keypad | numeric-only
- **layout:** portrait | landscape | floating

### Props

| Prop | Tipo / valores |
|---|---|
| `configuration` | base-keyboard \| alphanumeric \| keypad \| numeric-only (default base-keyboard) |
| `layout` | portrait \| landscape \| floating (default portrait) |

### Rules

- **placementOnly:** Wireframe/prototype placement only — not a product TextInput or real IME
- **vsTextInput:** Do not use as TextInput, Button, Modal, Bottom sheet, or OS keyboard replacement
- **localTokens:** Never use Schemes/* or M3/sys/* — local kebab-case only; radius/spacing bound where mappable
- **localIcons:** Local DS outline icons for toolbar/modifiers; gifIcon uses photo-outline; bottomNav nests MobileGestureNavigation
- **typography:** body/large/regular on key labels; body/medium/medium on compact modifiers
- **nonInteractiveKeys:** Keys are decorative placeholders in design

### Token rules

- `color/background-surface/0|1|2`
- `text/primary|secondary|brand|on-color`
- `color/actions/primary|secondary`
- `color/border/1|2`
- `border/radius/100|200|300|full` (bound)
- `spacing/050|100|150|200|300` (bound on common gaps)

### Accessibility

Decorative prototype chrome in design specs; product text entry must use native OS/platform IME, not this component.

### Composition

local DS outline icons, MobileGestureNavigation, decorative key rows

---

## Link

**Node ID:** `3820:13913`

AI-READY COMPONENT: Link is a text navigation control for in-page or external destinations. Use size=lg|md|sm for type density. Use state=default|hover|focus|active|visited|disabled for interaction. Use appearance=default on standard surfaces and appearance=inverse on inverse/dark/on-color surfaces. Props: label is the visible link text; inline toggles underline-only inline treatment (no trailing icon); showIcon toggles the trailing icon for standalone links; trailingIcon is an INSTANCE_SWAP for a local DS outline icon (default arrow-narrow-right-outline). Inline rule: when inline=true, hide the trailing icon and use underline; when inline=false, no underline and showIcon may reveal trailingIcon. Do not use Link as a Button, TabItem, BreadcrumbItem, MenuItem or Checkbox. Prefer Button variant=text for actions that are not navigational. Accessibility: expose as a link (a / role=link); ensure visible focus; communicate visited when relevant; do not rely on color alone; decorative trailingIcon should be aria-hidden when label is present. Token rule: local S2 kebab-case variables and text styles only — text/link|brand|secondary|primary|placeholder|on-color|on-color-disabled, interactive/focus, spacing/0|100, body/large|medium|small/regular. React mapping: Link(size, state, appearance, label, inline, showIcon, trailingIcon?). Code Connect is not configured.

### Variants

- **size:** lg | md | sm
- **state:** default | hover | focus | active | visited | disabled
- **appearance:** default | inverse

### Props

| Prop | Tipo / valores |
|---|---|
| `size` | lg \| md \| sm |
| `state` | default \| hover \| focus \| active \| visited \| disabled |
| `appearance` | default \| inverse |
| `label` | TEXT — visible link text |
| `inline` | boolean — underline inline treatment; hide trailing icon |
| `showIcon` | boolean — toggles trailingIcon (standalone) |
| `trailingIcon` | INSTANCE_SWAP — local DS outline icon (default arrow-narrow-right-outline) |

### Rules

- **inlineVsStandalone:** inline=true → underline, no icon; inline=false → no underline, optional trailingIcon
- **localIcons:** trailingIcon local DS outline only; preferredValues include arrow-narrow-right, arrow-right, arrow-big-right, chevron-right
- **vsButton:** Prefer Button variant=text for non-navigational actions
- **usage:** Do not use as Button, TabItem, BreadcrumbItem, MenuItem or Checkbox

### Token rules

- `text/link` | `brand` | `secondary` | `primary` | `placeholder` | `on-color` | `on-color-disabled` by state/appearance
- `interactive/focus` for focus ring
- `spacing/0` | `100`
- `body/large|medium|small/regular` by size

### Accessibility

a / role=link; visible focus; communicate visited; color not sole cue; trailingIcon aria-hidden when label present.

---

## ListItemStateLayer

**Node ID:** `3720:28`

AI-READY COMPONENT: ListItemStateLayer is a visual-only internal interaction surface used inside ListItem as stateLayer. Variants: state=default|hover|focus|pressed|dragged. default has no fill; hover uses interactive/hover; focus is ring-only (focusRing visible, no wash fill); pressed uses interactive/pressed plus optional pressedRipple with interactive/overlay; dragged uses interactive/selected plus local effect style elevation/1 (do not use remote M3 elevation). focusRing must stay absolute/STRETCH and cover the parent bounds. Do not expose as a product component, Button, Card, Chip or standalone surface. Token rule: use existing DS kebab-case variables only — interactive/hover|pressed|selected|focus|overlay, border/radius/0|200, border/width/025, elevation/1 for dragged. Accessibility: no runtime role; parent ListItem owns focus, keyboard and semantics. React mapping: internal only — ListItem(state) drives this layer.

### Variants

- **state:** default | hover | focus | pressed | dragged

### Rules

- **internalOnly:** Use only inside ListItem as stateLayer
- **focusRing:** absolute STRETCH; visible only on state=focus
- **focusRingOnly:** state=focus has no wash fill — ring only
- **pressedRippleLocal:** pressedRipple uses interactive/overlay — no remote State Layers tokens
- **draggedElevation:** state=dragged uses local elevation/1 — no remote M3 elevation
- **vsProduct:** Do not expose as Button, Card, Chip or standalone surface

### Token rules

- `interactive/hover | pressed | selected | focus | overlay`
- `border/radius/0 | 200`, `border/width/025` (focusRing)
- `elevation/1` for dragged

### Accessibility

no runtime role; parent ListItem owns focus, keyboard and semantics.

---

## ListItemImageThumbnail

**Node ID:** `3694:16209`

AI-READY COMPONENT: ListItemImageThumbnail is a compact image thumbnail block for ListItem leading media. Use imageSurface as the only layer for image fill replacement (SOLID placeholder + IMAGE scaleMode FILL). Do not use as ImageItem, gallery tile, avatar, button or selectable media option. Token rule: use existing DS kebab-case variables only — color/background-surface/2, border/radius/100. Accessibility: image alt text should be provided by the parent ListItem when informative; decorative thumbnails may be hidden from assistive technology. React mapping: internal only — ListItemImageThumbnail(src, alt).

### Rules

- **imageSurface:** only layer for image fill; SOLID + IMAGE FILL
- **internalOnly:** Use inside ListItem leading media
- **vsMedia:** Do not use as ImageItem, gallery tile, avatar or button

### Token rules

- `color/background-surface/2`, `border/radius/100`

### Accessibility

alt from parent ListItem when informative; decorative may be hidden from AT.

---

## ListItemVideoThumbnail

**Node ID:** `3694:16211`

AI-READY COMPONENT: ListItemVideoThumbnail is a compact video thumbnail block for ListItem leading media. Use imageSurface as the only layer for poster/image fill replacement (SOLID placeholder + IMAGE scaleMode FILL). playIcon is a local player-play-outline affordance (20px, proportional stroke) centered on the media and indicates playback. Do not use as ImageItem, gallery tile, video player, button or selectable media option. Token rule: use existing DS kebab-case variables only — color/background-surface/2, border/radius/100, text/on-color for playIcon, plus icon scale rule for 20px. Accessibility: parent ListItem should expose that the media is video when meaningful; playIcon is decorative if the parent label already conveys playback. React mapping: internal only — ListItemVideoThumbnail(src, alt, onPlay).

### Rules

- **imageSurface:** only layer for poster fill; SOLID + IMAGE FILL
- **playIcon:** local player-play-outline 20px centered; proportional stroke; text/on-color
- **internalOnly:** Use inside ListItem leading media
- **vsMedia:** Do not use as ImageItem, gallery, video player or button

### Token rules

- `color/background-surface/2`, `border/radius/100`
- `text/on-color` for playIcon
- icon scale 20px (stroke â‰ˆ 1.67)

### Accessibility

parent exposes video when meaningful; playIcon decorative if label already conveys playback.

---

## Modal

**Node ID:** `3306:4278`

AI-READY COMPONENT: Modal is the dialog surface for focused tasks that require user attention without leaving the current context. Props: platform=web|mobile|mobile-landscape; slot (SLOT — modal body; preferredValues include ModalCheckItem for guideline rows). Nested ModalHeader owns title, label, showLabel, showCloseAction (edit on nested instance — keep layout mapped to platform). Use platform=web for desktop/web dialogs, platform=mobile for portrait phone dialogs, and platform=mobile-landscape when the phone is rotated horizontally (same ModalHeader layout=mobile + sheetContent/slot as mobile, wider shorter shell). Composition: ModalHeader (web→layout=desktop; mobile|mobile-landscape→layout=mobile) + sheetContent → slot. Tokens: color/background-surface/0; shell corner radius via product-theme `component/modal/container/radius` (EV|site-loovi→`border/radius/600`; app-cliente→`border/radius/800`); elevation DROP_SHADOW color/elevation/6 (radius/offsetY spacing/100; spread/offsetX spacing/0); itemSpacing spacing/150 (web) | spacing/050 (mobile|mobile-landscape); paddingBottom spacing/500 (web) | spacing/400 (mobile|mobile-landscape); sheetContent horizontal pad spacing/300 (web) | spacing/200 (mobile|mobile-landscape); sheetContent itemSpacing spacing/0. Nested ModalHeader close chip stays mode-aware via `component/modal-header/close-action/*`. Do not hardcode shell radius/600. Do not use as BottomSheet, page, card, toast, or AppHeader host — use ModalHeader only. Compose guideline rows with ModalCheckItem in slot (not Checkbox, not BottomSheetCheckItem). Accessibility: dialog semantics owned by Modal; title via ModalHeader; close via showCloseAction. React mapping: Modal(platform, title, label, showLabel, showCloseAction, children). Code Connect is not configured.

### Variants

- **platform:** web | mobile | mobile-landscape

### Props

| Prop | Tipo / valores |
|---|---|
| `platform` | web \| mobile \| mobile-landscape |
| `slot` | SLOT — main modal body; preferredValues include ModalCheckItem for guideline rows |
| `title` | nested ModalHeader TEXT — modal heading |
| `label` | nested ModalHeader TEXT — optional supporting label |
| `showLabel` | nested ModalHeader BOOLEAN — toggles label |
| `showCloseAction` | nested ModalHeader BOOLEAN — toggles closeAction Button |

### Product theme (`product-theme`)

Modes: `escritorio-virtual` | `site-loovi` | `app-cliente`

| Token | Bind | escritorio-virtual | site-loovi | app-cliente |
|---|---|---|---|---|
| `component/modal/container/radius` | Modal shell corner radius (all platforms) | `border/radius/600` | `border/radius/600` | `border/radius/800` |

### Rules

- **nonPage:** Do not use Modal as toast, banner, bottom sheet, side sheet, page container or card
- **composition:** ModalHeader (desktop on web, mobile on mobile|mobile-landscape) + sheetContent/slot — never AppHeader
- **headerMapping:** platform=web → ModalHeader layout=desktop; platform=mobile|mobile-landscape → ModalHeader layout=mobile
- **headerProps:** title/label/showLabel/showCloseAction live on nested ModalHeader — do not remount AppHeader
- **slotCheckItems:** Optional guideline stacks in slot may compose ModalCheckItem rows (not Checkbox, not BottomSheetCheckItem)
- **productTheme:** Shell corners bind `component/modal/container/radius` — EV|site-loovi→600 (24px); app-cliente→800 (32px). Nested ModalHeader close-action tokens remain mode-aware. Do not hardcode radius/600 on the Modal root.

### Token rules

- `color/background-surface/0` for modal surface
- `product-theme component/modal/container/radius` (EV|site-loovi→600; app-cliente→800)
- `color/elevation/6` drop shadow (radius/offsetY spacing/100; spread/offsetX spacing/0)
- itemSpacing spacing/150 (web) | spacing/050 (mobile|mobile-landscape)
- paddingBottom spacing/500 (web) | spacing/400 (mobile|mobile-landscape)
- sheetContent pad horizontal spacing/300 (web) | spacing/200 (mobile|mobile-landscape); itemSpacing spacing/0
- nested ModalHeader product-theme close-action/*

### Accessibility

Block background interaction, trap focus, role=dialog or alertdialog, aria-modal=true, aria-labelledby for ModalHeader title, Escape to close when allowed, restore focus to trigger.

### Composition

ModalHeader, Button, x-outline, ModalCheckItem (optional guideline rows in slot)


## ModalHeader

**Node ID:** `3786:9403`

AI-READY COMPONENT: ModalHeader is the header block used only inside Modal surfaces. Use layout=desktop to match Modal platform=web and layout=mobile to match Modal platform=mobile|mobile-landscape while keeping the same content hierarchy. Use alignment=start for left-aligned title/label (default) and alignment=center for optically centered title/label with a leadingSpacer matching the close action width on layout=mobile. Props: title controls the modal heading; label controls the optional supporting label above the title; showLabel toggles that label; showCloseAction toggles the local icon-only Button used to dismiss the modal. Composition: alignment=start uses headingContent + trailingActions; alignment=center uses leadingSpacer + headingContent + trailingActions. closeAction must remain a local Button with x-outline, size=sm, variant=text, intent=primary and hidden visible label text set to Fechar modal for accessible mapping. Typography: layout=desktop title uses heading/h1/semi-bold; layout=mobile title uses heading/h3/semi-bold; label uses body/small/regular. Product-theme (escritorio-virtual|site-loovi|app-cliente): closeAction fill/radius bind component/modal-header/close-action/background + radius on all layouts; layout=mobile closeAction (+ center leadingSpacer) bind size-mobile (EV|site-loovi=40; app-cliente=32); layout=desktop closeAction size stays spacing/500 (40) in all modes. app-cliente resolves to surface/2 + radius/full + 32 on mobile. Do not hardcode close chip fill/radius/size. Do not use ModalHeader as AppHeader, page header, card header, BottomSheet header or navigation. Inherit the Modal surface instead of adding an independent background. Accessibility: the Modal owns role=dialog, aria-modal, focus trap and Escape behavior. The title must be referenced by aria-labelledby. The close action is a button with aria-label=Fechar modal and must be keyboard accessible. React mapping: ModalHeader(layout, alignment, title, label, showLabel, showCloseAction). Code Connect is not configured.

### Variants

- **layout:** desktop | mobile
- **alignment:** start | center

### Props

| Prop | Tipo / valores |
|---|---|
| `layout` | desktop \| mobile (map from Modal platform: web→desktop; mobile\|mobile-landscape→mobile) |
| `alignment` | start \| center (default start) |
| `title` | modal heading text |
| `label` | optional supporting label above title |
| `showLabel` | boolean — toggles label |
| `showCloseAction` | boolean — toggles closeAction Button |

### Product theme (`product-theme`)

Modes: `escritorio-virtual` | `site-loovi` | `app-cliente`

| Token | Bind | escritorio-virtual | site-loovi | app-cliente |
|---|---|---|---|---|
| `component/modal-header/close-action/background` | closeAction fill (all layouts) | `color/background-surface/0` | `color/background-surface/2` | `color/background-surface/2` |
| `component/modal-header/close-action/radius` | closeAction radius (all layouts) | `border/radius/200` | `border/radius/full` | `border/radius/full` |
| `component/modal-header/close-action/size-mobile` | closeAction (+ center leadingSpacer) on layout=mobile; desktop close stays spacing/500 (40) | `40` | `40` | `32` |

### Rules

- **composition:** start: headingContent + trailingActions; center: leadingSpacer + headingContent + trailingActions
- **closeAction:** Button text/sm/primary + x-outline; accessible label Fechar modal; showLabel=false
- **typography:** desktop title heading/h1/semi-bold; mobile title heading/h3/semi-bold; label body/small/regular
- **centerOptical:** alignment=center leadingSpacer must match close hit size. On layout=mobile both bind size-mobile. On layout=desktop close uses spacing/500 (40); keep spacer in parity with that close width.
- **productTheme:** closeAction binds background + radius on all layouts. size-mobile binds layout=mobile close (+ center leadingSpacer). EV: surface/0 + 200 + 40; site-loovi: surface/2 + full + 40; app-cliente: surface/2 + full + 32 (mobile only). Desktop close stays spacing/500 (40).
- **vsAppHeader:** Do not use as AppHeader, page header, card header, BottomSheet header or navigation
- **parentOnly:** Use only inside Modal
- **vsBottomSheetHeader:** Do not use as BottomSheet header — use BottomSheetHeader

### Token rules

- `product-theme component/modal-header/close-action/background` (EV→surface/0; site-loovi|app-cliente→surface/2)
- `product-theme component/modal-header/close-action/radius` (EV→200; site-loovi|app-cliente→full)
- `product-theme component/modal-header/close-action/size-mobile` on layout=mobile (EV|site-loovi=40; app-cliente=32)
- layout=desktop closeAction size → `spacing/500` (40) all modes
- `text/primary` | `text/secondary`
- `spacing/0|050|100|200|250|300|500`
- nested Button tokens

### Accessibility

Modal owns dialog semantics; title via aria-labelledby; close button aria-label=Fechar modal, keyboard accessible.

### Composition

Button, x-outline


## ModalCheckItem

**Node ID:** `4372:19371`

AI-READY COMPONENT: ModalCheckItem is a guideline / checklist row used inside Modal body content to present a tip or requirement with a leading check icon. Props: leadingIcon (INSTANCE_SWAP — local DS; default circle-check-filled; preferredValues circle-check-filled and circle-check-outline); description (TEXT — multi-line body copy; demo may include text/brand SemiBold emphasis spans). Anatomy: leadingIcon (20 FIXED) + description. Layout: horizontal Auto Layout, counterAxisAlignItems=MIN (icon top-aligned with first line), itemSpacing spacing/100, padding spacing/0, demo width 318, height Hug. Tokens: local body/medium/regular + text/secondary for base description; text/brand + body/medium/semi-bold (`font-weight/semi-bold` bound on emphasis spans) for optional in-copy emphasis; color/actions/primary on filled check icon paths; border/width/025 on strokes when applicable. Do not use as Checkbox (interactive selection), ListItem, FeatureStepsItem, VerticalStepperItem, Banner, Toast, or BottomSheetCheckItem (use BottomSheetCheckItem inside BottomSheet). Use inside Modal slot / sheetContent stacks. Icon is decorative (aria-hidden); meaning comes from description. React mapping: ModalCheckItem({ leadingIcon, description }).

### Variants

_(none — single component)_

### Props

| Prop | Tipo / valores |
|---|---|
| `leadingIcon` | INSTANCE_SWAP — default `circle-check-filled`; preferredValues: `circle-check-filled` \| `circle-check-outline`; FIXED 20 |
| `description` | TEXT — local `body/medium/regular` + `text/secondary`; optional `text/brand` + `font-weight/semi-bold` spans; master EN tip with emphasis |

### Rules

- **parentOnly:** Compose inside Modal slot / sheetContent — not a standalone page pattern
- **decorativeIcon:** leadingIcon is decorative (aria-hidden); meaning via description
- **mixedEmphasis:** Optional in-copy emphasis uses text/brand + font-weight/semi-bold (body/medium size/line-height)
- **typographyLocal:** Use local body/medium/* + font-family/base — no remote Font/* Title Case variables
- **vsCheckbox:** Do not use as Checkbox — this is not an interactive selection control
- **vsListItem:** Do not use as ListItem — no state layer, trailing, density matrix
- **vsFeatureStepsItem:** Do not use as FeatureStepsItem / VerticalStepperItem
- **vsBottomSheetCheckItem:** Use BottomSheetCheckItem inside BottomSheet — not ModalCheckItem
- **usage:** Do not use as Checkbox, ListItem, FeatureStepsItem, VerticalStepperItem, Banner, Toast, or BottomSheetCheckItem

### Token rules

- `spacing/100` (gap); `spacing/0` (pad)
- `body/medium/font-size|line-height` + `font-family/base` + `font-weight/regular`
- `text/secondary` (base); `text/brand` + `font-weight/semi-bold` (optional emphasis)
- `color/actions/primary` on filled icon paths
- `border/width/025` on icon strokes when applicable

### Accessibility

Decorative leadingIcon aria-hidden; expose description as list item / guideline text. Not a checkbox — do not announce checked state.

---

## BottomSheetCheckItem

**Node ID:** `4389:80`

AI-READY COMPONENT: BottomSheetCheckItem is a guideline / checklist row used inside BottomSheet body content (slot / sheetContent) to present a tip or requirement with a leading check icon. Props: leadingIcon (INSTANCE_SWAP — local DS; default circle-check-filled; preferredValues circle-check-filled and circle-check-outline); description (TEXT — multi-line body copy; demo may include text/brand SemiBold emphasis spans). Anatomy: leadingIcon (20 FIXED) + description. Layout: horizontal Auto Layout, counterAxisAlignItems=MIN (icon top-aligned with first line), itemSpacing spacing/100, padding spacing/0, demo width 318, height Hug. Tokens: local body/medium/regular + text/secondary for base description; text/brand + body/medium/semi-bold (`font-weight/semi-bold` bound on emphasis spans) for optional in-copy emphasis; color/actions/primary on filled check icon paths; border/width/025 on strokes when applicable. Do not use as Checkbox (interactive selection), ListItem, FeatureStepsItem, VerticalStepperItem, Banner, Toast, or ModalCheckItem (use ModalCheckItem inside Modal). Use inside BottomSheet slot / sheetContent stacks. Icon is decorative (aria-hidden); meaning comes from description. React mapping: BottomSheetCheckItem({ leadingIcon, description }).

### Variants

_(none — single component)_

### Props

| Prop | Tipo / valores |
|---|---|
| `leadingIcon` | INSTANCE_SWAP — default `circle-check-filled`; preferredValues: `circle-check-filled` \| `circle-check-outline`; FIXED 20 |
| `description` | TEXT — local `body/medium/regular` + `text/secondary`; optional `text/brand` + `font-weight/semi-bold` spans; master EN tip with emphasis |

### Rules

- **parentOnly:** Compose inside BottomSheet slot / sheetContent — not a standalone page pattern
- **decorativeIcon:** leadingIcon is decorative (aria-hidden); meaning via description
- **mixedEmphasis:** Optional in-copy emphasis uses text/brand + font-weight/semi-bold (body/medium size/line-height)
- **typographyLocal:** Use local body/medium/* + font-family/base — no remote Font/* Title Case variables
- **vsCheckbox:** Do not use as Checkbox — this is not an interactive selection control
- **vsListItem:** Do not use as ListItem — no state layer, trailing, density matrix
- **vsFeatureStepsItem:** Do not use as FeatureStepsItem / VerticalStepperItem
- **vsModalCheckItem:** Use ModalCheckItem inside Modal — not BottomSheetCheckItem
- **usage:** Do not use as Checkbox, ListItem, FeatureStepsItem, VerticalStepperItem, Banner, Toast, or ModalCheckItem

### Token rules

- `spacing/100` (gap); `spacing/0` (pad)
- `body/medium/font-size|line-height` + `font-family/base` + `font-weight/regular`
- `text/secondary` (base); `text/brand` + `font-weight/semi-bold` (optional emphasis)
- `color/actions/primary` on filled icon paths
- `border/width/025` on icon strokes when applicable

### Accessibility

Decorative leadingIcon aria-hidden; expose description as list item / guideline text. Not a checkbox — do not announce checked state.

---

## ProgressBar

**Node ID:** `3407:3492`

AI-READY COMPONENT: ProgressBar is a linear progress indicator used to communicate completion percentage for determinate processes. Use value to display the current progress percentage label and showValue to show or hide that visible label. Use size=md for default layouts and size=sm for compact layouts. The track represents the total amount and the indicator represents the completed amount — in Figma the indicator width is layout-controlled for design mocks; value is the visible label only and does not drive fill mathematically. Do not use ProgressBar as a loading spinner, slider, stepper, chart, timeline, badge or decorative divider. Accessibility: expose progress with role=progressbar, aria-valuemin=0, aria-valuemax=100 and aria-valuenow matching the current numeric value. If the visible value is hidden, provide an accessible label. Token rule: use existing DS variables only (color/actions/primary for indicator, color/background-surface/2 for track, text/primary for value, spacing/100|200|250, border/radius/150). React mapping: ProgressBar(value, showValue, size, progress?).

### Variants

- **size:** md | sm

### Props

| Prop | Tipo / valores |
|---|---|
| `value` | visible progress percentage label (e.g. 100%) |
| `showValue` | boolean — toggles value label visibility |
| `size` | md \| sm |

### Rules

- **valueVsFill:** value is the visible label only; indicator fill width is layout-controlled in Figma mocks
- **usage:** Do not use as loading spinner, slider, stepper, chart, timeline, badge or decorative divider

### Token rules

- `color/actions/primary` for indicator fill
- `color/background-surface/2` for track fill
- `text/primary` for value label
- `spacing/100` | `200` | `250` and `border/radius/150`

### Accessibility

role=progressbar with aria-valuemin=0, aria-valuemax=100, aria-valuenow; if showValue=false provide an accessible label.

---

## RadioButton

**Node ID:** `3653:5279`

AI-READY COMPONENT: RadioButton is a selectable control used when users must choose one option from a mutually exclusive group. Use checked=true for the selected option and checked=false for unselected options. Use state=default, hover, focus or disabled to represent interaction state. Use label for the primary option text and description for optional supporting text. Use showLabel, showDescription and showContent only to control visible content slots. Do not use RadioButton as a Checkbox, Toggle, Button, Chip, MenuItem or standalone multiple-selection control. Accessibility: expose the control with role=radio, reflect checked state with aria-checked, use aria-disabled when disabled, preserve visible focus, and place related options inside a RadioGroup with role=radiogroup. Token rule: use existing DS variables only (color/actions/primary for checked, color/border/1|2, interactive/hover|focus, text/primary|secondary|placeholder, border/radius/full|0, spacing/025|050|200|250|300). React mapping: RadioButton(label, description, showLabel, showDescription, showContent, state, checked).

### Variants

- **state:** default | hover | focus | disabled
- **checked:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `label` | primary option text |
| `description` | optional supporting text |
| `showLabel` | boolean — toggles label visibility |
| `showDescription` | boolean — toggles description visibility |
| `showContent` | boolean — toggles labelContent slot visibility |
| `state` | default \| hover \| focus \| disabled |
| `checked` | false \| true |

### Rules

- **usage:** Do not use as Checkbox, Toggle, Button, Chip, MenuItem or standalone multiple-selection control
- **grouping:** Related options belong in a RadioGroup (role=radiogroup)
- **vsRadioButtonCard:** For full-width card/row options use `RadioButtonCard` (`4498:68`)

### Token rules

- `color/actions/primary` for checked fill
- `color/border/1` | `color/border/2` for control stroke
- `interactive/hover` | `interactive/focus` for interaction states
- `text/primary` | `text/secondary` | `text/placeholder` for label/description
- `border/radius/full` | `border/radius/0` and `spacing/025` | `050` | `200` | `250` | `300`

### Accessibility

role=radio; aria-checked reflects checked; aria-disabled when disabled; visible focus; related options in RadioGroup with role=radiogroup.

---



## RadioButtonCard

**Node ID:** `4498:68`

AI-READY COMPONENT: RadioButtonCard is the card/row variation of RadioButton for mutually exclusive choices presented as selectable full-width rows (e.g. Sim/Não). Master demo width is FIXED 343 (mobile exemplar); instances should Fill container. Use when the option needs a full-width tappable surface with radio + label + optional helper description. Variants: state=default|hover|focus|disabled; checked=false|true. Props: label (TEXT); description (TEXT, default helper copy); showDescription (BOOLEAN, default true). Composition: radioControl (20, top-aligned) + labelContent (label + description); hover adds absolute stateLayer with interactive/hover. Description: body/small/regular + text/secondary (text/placeholder when disabled), gap spacing/050 — parity with RadioButton. React mapping: RadioButtonCard(state, checked, label, description, showDescription).

### Variants

- **state:** default | hover | focus | disabled
- **checked:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| hover \| focus \| disabled |
| `checked` | false \| true |
| `label` | TEXT — option label (default `Label`) |
| `description` | TEXT — helper below label (default `Texto de descrição abaixo do label do radio`) |
| `showDescription` | boolean — toggles description (default true) |

### Rules

- **descriptionParity:** mirrors RadioButton helper text (`description` + `showDescription`; `body/small/regular`; `text/secondary` / `text/placeholder` disabled)
- **vsRadioButton:** full-width card/row → RadioButtonCard; compact non-card → RadioButton
- **hoverStateLayer:** `state=hover` absolute `stateLayer` fill `interactive/hover`
- **disabledAlign:** disabled+checked radio stroke `border/width/025`
- **demoWidth:** master FIXED 343; instances Fill container
- **usage:** Do not use as Checkbox, Chip, ListItem alone, or Toast
- **grouping:** Related options in RadioGroup (`role=radiogroup`)

### Token rules

- `color/background-surface/0` | `color/background-surface/1`
- `color/border/1` | `color/border/2` | `color/border-feedback/primary`
- `interactive/hover` (hover stateLayer) | `interactive/focus` (shell stroke)
- `color/actions/primary` (checked radioControl stroke)
- `text/primary` | `text/secondary` (description) | `text/placeholder` (disabled)
- `body/medium/medium` (label) | `body/small/regular` (description)
- `border/radius/400` (shell) | `border/radius/full` (radioControl)
- `border/width/012` | `border/width/025` | `border/width/050`
- `spacing/200` (pad) | `spacing/100` (gap) | `spacing/050` (labelContent gap)

### Accessibility

role=radio; aria-checked; aria-disabled when disabled; aria-describedby when description is shown; visible focus on shell; card surface is the hit target; related options in RadioGroup.

### Composition

- radioControl (20, top-aligned) + labelContent (label + description)
- stateLayer absolute on hover (`interactive/hover`)

---

## StepProgressIndicator

**Node ID:** `3809:765`

AI-READY COMPONENT: StepProgressIndicator is a compact, non-interactive, segmented indicator for linear multi-step flows with a known and stable total. Use it for mobile screens, compact modals, onboarding, checkout, registration and document-upload flows when the user needs to understand the current step without the full labeled StepperPrimary. Do not use it for one or two steps, non-linear flows, conditionally changing totals, task loading, percentage progress, navigation tabs, pagination, sliders or decorative dividers. Use ProgressBar for continuous quantitative progress and StepperPrimary for labeled or structurally detailed steps. Variants: stepCount=3|4|5|6|7|8 and currentStep=1..stepCount. The published matrix is intentionally sparse: combinations where currentStep exceeds stepCount must not exist. Props: showCounter controls the visible localized counter derived from stepCount and currentStep; hasError replaces the current visual segment with feedback/danger and must only be enabled when the current step has a real validation error accompanied by an explanatory message. Structure: counter and segments; each segment uses the internal StepProgressSegment component; completed steps precede current, pending steps follow current, and currentSegmentSlot overlays errorSegment when hasError=true. Layout: horizontal segments only, no wrap and no horizontal scroll. Root uses vertical Auto Layout with HUG height so showCounter can expand the component; segment track height uses spacing/050. The master uses a 350px demonstration width; instances should use Fill container. Each segment distributes equally with spacing/100, 4px height and border/radius/full. Step-count policy: do not show for 1-2 steps; use 3-5 directly; for 6-8 enable showCounter; above 8 group screens into high-level chapters or use ProgressBar plus textual position. Accessibility: the visual segments are decorative and should be aria-hidden. Provide equivalent visible or accessible text such as Etapa 2 de 5: Dados do veiculo. When exposing a full navigable step list, use an ordered list and aria-current=step on the active step. Do not use role=progressbar for this component because it represents position in a flow rather than quantitative task completion. The component receives no focus and does not replace Back/Continue controls. Token rule: use existing DS kebab-case variables only - color/actions/primary, interactive/selected, color/background-surface/2, feedback/danger, text/secondary, spacing/050|100, border/radius/full - never Spacing/* Title Case. React mapping: StepProgressIndicator(stepCount, currentStep, showCounter, hasError); the localized counter text must be computed from stepCount and currentStep. Code Connect is not configured.

### Variants

- **stepCount:** 3 | 4 | 5 | 6 | 7 | 8
- **currentStep:** 1..stepCount (sparse)

### Props

| Prop | Tipo / valores |
|---|---|
| `stepCount` | 3 \| 4 \| 5 \| 6 \| 7 \| 8 |
| `currentStep` | 1..stepCount (never exceeds stepCount) |
| `showCounter` | boolean — toggles localized Etapa X de Y counter |
| `hasError` | boolean — overlays current segment with status=error |

### Rules

- **composeSegment:** Nest local StepProgressSegment only — completed before current, pending after
- **sparseMatrix:** No variants where currentStep > stepCount
- **vsProgressBar:** Use ProgressBar for quantitative % progress
- **vsStepperPrimary:** Use StepperPrimary for labeled/detailed steps
- **hugRoot:** Root vertical HUG so showCounter can expand; track height spacing/050

### Token rules

- `color/actions/primary` (current)
- `interactive/selected` (completed)
- `color/background-surface/2` (pending)
- `feedback/danger` (error)
- `text/secondary` (counter)
- `spacing/050|100`, `border/radius/full`

### Accessibility

Segments aria-hidden; expose Etapa X de Y (or equivalent); aria-current=step on navigable lists; do not use role=progressbar; no focus.

### Composition

StepProgressSegment

---

## StepProgressSegment

**Node ID:** `3807:31`

AI-READY INTERNAL COMPONENT: StepProgressSegment is the internal visual segment used only inside StepProgressIndicator. Variants: status=completed|current|pending|error. Default published demo uses status=completed. current uses color/actions/primary and must be the most visually prominent state. completed uses interactive/selected to remain visible with lower emphasis. pending uses color/background-surface/2 and must not appear disabled. error uses feedback/danger and must only be used when the current step contains a real validation error accompanied by explanatory text. Structure: segmentSurface fills the component, uses border/radius/full, and stretches horizontally when its instance is placed inside the StepProgressIndicator segments Auto Layout. This component is non-interactive, receives no focus, and must not be used as a ProgressBar, Button, Slider, TimelineItem or standalone navigation control. Token rule: use existing DS kebab-case variables only - color/actions/primary, interactive/selected, color/background-surface/2, feedback/danger, border/radius/full. No Code Connect mapping is configured. Do not publish StepProgressSegment as a standalone product Storybook component; document it as composition of StepProgressIndicator.

### Variants

- **status:** completed | current | pending | error

### Props

| Prop | Tipo / valores |
|---|---|
| `status` | completed \| current \| pending \| error |

### Rules

- **internalOnly:** Use only inside StepProgressIndicator — not a product standalone component
- **surface:** segmentSurface FILL + border/radius/full

### Token rules

- `color/actions/primary`
- `interactive/selected`
- `color/background-surface/2`
- `feedback/danger`
- `border/radius/full`

### Accessibility

Non-interactive; no focus; parent owns accessible step text.

---
## StepperPrimary

**Node ID:** `3437:396`

AI-READY COMPONENT: StepperPrimary is a single step item used inside a Stepper to represent progress across a multi-step flow. Use status=completed for finished steps, status=current for the active step and status=pending for upcoming steps. Use trail=left, right or both to define which connector sides are present in the step layout. Use trailState=none, left, right or both to define which present connector sides are visually active (color/actions/primary); inactive present connectors use color/border/2. Icons are structural by status: circle-check-filled (completed), circle-dot-filled (current), circle-outline (pending). The published matrix is intentional-sparse: trailState sides must be a subset of trail; current×trail=both only publishes trailState=none|left; pending always publishes trailState=none. Use label for the visible step text. Do not use StepperPrimary as a Button, PaginationItem, ProgressBar, TimelineItem or standalone navigation item unless the stepper interaction is explicitly implemented. Accessibility: when used in a stepper navigation, expose the full stepper as an ordered list or navigation group, mark the current step with aria-current=step, and ensure completed, current and pending status are available to assistive technologies. Token rule: use existing DS variables only (color/actions/primary, color/border/2, text/primary|placeholder, spacing/0|050|100|300, border/radius/full|0, border/width/012|025). React mapping: StepperPrimary(label, status, trail, trailState).

### Variants

- **status:** completed | current | pending
- **trail:** both | left | right
- **trailState:** none | both | left | right

### Props

| Prop | Tipo / valores |
|---|---|
| `label` | visible step text |
| `status` | completed \| current \| pending |
| `trail` | both \| left \| right |
| `trailState` | none \| both \| left \| right |

### Rules

- **icons:** structural by status: circle-check-filled | circle-dot-filled | circle-outline; local DS icons only
- **trails:** active trails use color/actions/primary; inactive present trails use color/border/2
- **sparseMatrix:** intentional-sparse: trailState âŠ† trail; current×both publishes none|left only; pending publishes trailState=none only
- **usage:** Do not use as Button, PaginationItem, ProgressBar, TimelineItem or standalone navigation item

### Token rules

- `color/actions/primary` for active trails, completed/current icon fills and completed label
- `color/border/2` for inactive present trails
- `text/primary` | `text/placeholder` for labels by status
- `spacing/0` | `050` | `100` | `300` and `border/radius/full` | `0`, `border/width/012` | `025`

### Accessibility

Expose stepper as ordered list or navigation group; current step aria-current=step; status available to assistive technologies.

---

## FeatureSteps

**Node ID:** `4344:224`

AI-READY COMPONENT: FeatureSteps is a vertical illustrative steps container that composes FeatureStepsItem rows through an items SLOT. Use it to present tasks, benefits or onboarding actions with thematic icons — not to communicate process progress. Do not use as VerticalStepper (progress feedback), StepperPrimary, StepProgressIndicator, ProgressBar, timeline status list or plain List. Props: items is the SLOT for FeatureStepsItem instances only (preferredValues). Default composition mirrors app onboarding copy: Permissões, Confirmar Veículo, Enviar fotos e documentos with showConnector=false on the final item (FeatureStepsItem master defaults remain generic Label/Description). Connector and leadingIcon live on each FeatureStepsItem; the container does not invent status math. Layout: vertical Auto Layout with spacing/0 between items (vertical rhythm comes from FeatureStepsItem content padding-bottom spacing/300 + stretching connector), width Fill container in compositions (342px demo), height Hug. Accessibility: render as a list; decorative icons/connectors aria-hidden on items; meaning comes from headline and supportingText. Token rule: local S2 kebab-case only — spacing/0, border/radius/0 on container; item tokens from FeatureStepsItem. React mapping: FeatureSteps(items). Code Connect is not configured.

### Variants

_(none — single component)_

### Props

| Prop | Tipo / valores |
|---|---|
| `items` | SLOT — FeatureStepsItem instances only (preferredValues) |

### Rules

- **slotItemOnly:** Compose items SLOT with FeatureStepsItem only
- **noProgressStatus:** Do not invent completed/current/pending/error — that belongs to VerticalStepper
- **defaultComposition:** Permissões, Confirmar Veículo, Enviar fotos e documentos; showConnector=false on final item (master Item uses Label/Description)
- **spacingModel:** Container itemSpacing=spacing/0; rhythm from FeatureStepsItem content padding-bottom spacing/300 + FILL connector
- **vsVerticalStepper:** Use VerticalStepper when communicating real step progress feedback
- **vsStepperPrimary:** Use StepperPrimary for compact horizontal labeled progress
- **usage:** Do not use as VerticalStepper, StepperPrimary, StepProgressIndicator, ProgressBar, timeline status list or plain List

### Token rules

- `spacing/0`, `border/radius/0` on container
- FeatureStepsItem owns badge/connector/text tokens and vertical rhythm (spacing/300)

### Accessibility

List; decorative icons/connectors aria-hidden; meaning via headline and supportingText.

---

## FeatureStepsItem

**Node ID:** `4343:222`

AI-READY COMPONENT: FeatureStepsItem is an illustrative vertical step row used to present a task, benefit or onboarding action with a thematic icon — not process progress feedback. Use inside FeatureSteps. Anatomy: indicatorColumn (iconBadge 48 with leadingIcon INSTANCE_SWAP + soft connector width spacing/100) + content (headline + supportingText). Layout: horizontal Auto Layout, spacing/200 between badge and content, counterAxisAlignItems=CENTER; indicatorColumn and content itemSpacing=spacing/0; content uses padding-bottom spacing/300 so the connector stretches and creates vertical rhythm when FeatureSteps itemSpacing is spacing/0. supportingText uses textAutoResize HEIGHT and vertical Hug so longer copy does not clip. Demo width 342; height Hug (Label/Description master demo). Props: leadingIcon (INSTANCE_SWAP; preferredValues local DS outlines: square-check-outline, car-outline, trophy-outline, camera-outline, file-outline, checkbox-outline), headline (TEXT, default Label), supportingText (TEXT, default Description), showSupportingText (BOOLEAN, default true), showConnector (BOOLEAN, default true — hide on final item). Icon vector layers use {icon}-path naming; strokeWeight bound to border/width/025. Do not use status completed/current/pending/error — that belongs to VerticalStepperItem. Do not use as VerticalStepperItem, StepperPrimary, StepProgressIndicator, ProgressBar, ListItem or timeline progress. Token rule: local S2 kebab-case only — color/background-surface/2, text/primary, text/secondary, border/radius/full, spacing/0|100|150|200|300, border/width/025. Typography: body/large/semi-bold (headline), body/medium/regular (supportingText). Prefer local DS icons. Accessibility: decorative icon and connector aria-hidden; convey meaning via headline/supportingText. React mapping: FeatureStepsItem(leadingIcon, headline, supportingText, showSupportingText?, showConnector?). Code Connect is not configured.

### Variants

_(none — single component)_

### Props

| Prop | Tipo / valores |
|---|---|
| `leadingIcon` | INSTANCE_SWAP — preferredValues: square-check-outline \| car-outline \| trophy-outline \| camera-outline \| file-outline \| checkbox-outline |
| `headline` | TEXT — primary label (body/large/semi-bold, text/primary); master default Label |
| `supportingText` | TEXT — supporting copy (body/medium/regular, text/secondary); HEIGHT + Hug; master default Description |
| `showSupportingText` | boolean — default true |
| `showConnector` | boolean — hides soft connector for final item; default true |

### Rules

- **composition:** indicatorColumn (iconBadge 48 + connector spacing/100 FILL) + content (headline + supportingText)
- **verticalRhythm:** content padding-bottom spacing/300 drives row height and connector stretch when parent gap is spacing/0
- **alignment:** counterAxisAlignItems=CENTER between badge column and content
- **illustrativeOnly:** No progress status matrix — thematic icon communicates topic, not completion
- **icons:** INSTANCE_SWAP leadingIcon; preferred local outlines listed in props; vector layers {icon}-path; stroke border/width/025
- **connector:** soft color/background-surface/2 — same as badge; width spacing/100; hide on final item
- **vsVerticalStepperItem:** Use VerticalStepperItem for real progress status (completed/current/pending/error)
- **usage:** Do not use as VerticalStepperItem, StepperPrimary, StepProgressIndicator, ProgressBar, ListItem or timeline progress

### Token rules

- color/background-surface/2 on iconBadge and connector
- text/primary on headline; text/secondary on supportingText
- border/radius/full on iconBadge
- spacing/0 column gaps; spacing/100 connector width; spacing/150 badge padding; spacing/200 gap badge→content; spacing/300 content padding-bottom
- border/width/025 on preferred icon strokes
- body/large/semi-bold; body/medium/regular

### Accessibility

Decorative icon/connector aria-hidden; meaning via headline and supportingText.

---

## VerticalStepper

**Node ID:** `3833:118`

AI-READY COMPONENT: VerticalStepper is a vertical ordered multi-step container that composes VerticalStepperItem rows through an items SLOT. Use it for multi-step flows that need contextual title/description per step — onboarding, checkout, registration, document review and similar vertical progress lists. Do not use it for compact horizontal labeled steps (use StepperPrimary), unlabeled segmented progress (use StepProgressIndicator), continuous quantitative progress (use ProgressBar), timelines, navigation lists or plain List. Props: items is the SLOT for VerticalStepperItem instances only. Default composition demonstrates completed, current, pending, pending with showConnector=false on the final item. Connector and status live on each VerticalStepperItem; the container does not invent status math. Layout: vertical Auto Layout, width Fill container in compositions (327px demo), height Hug. Accessibility: render as an ordered list; mark the active item with aria-current=step; expose each item status in accessible text; decorative statusIcon and connector remain aria-hidden on items. Token rule: local S2 kebab-case only — spacing/0, border/radius/0; item tokens come from VerticalStepperItem and nested ListItem. React mapping: VerticalStepper(items). Code Connect is not configured.

### Variants

_(none — single component)_

### Props

| Prop | Tipo / valores |
|---|---|
| `items` | SLOT — VerticalStepperItem instances only (preferredValues) |

### Rules

- **slotItemOnly:** Compose items SLOT with VerticalStepperItem only
- **statusOnItem:** status and showConnector live on each VerticalStepperItem — container does not invent status math
- **defaultComposition:** completed, current, pending, pending with showConnector=false on final item
- **vsStepperPrimary:** Use StepperPrimary for compact horizontal labeled steps
- **vsStepProgressIndicator:** Use StepProgressIndicator for unlabeled segmented progress
- **vsProgressBar:** Use ProgressBar for continuous quantitative progress
- **usage:** Do not use as timeline, navigation list, plain List, StepperPrimary or StepProgressIndicator

### Token rules

- `spacing/0`, `border/radius/0` on container
- VerticalStepperItem and nested ListItem own item/content tokens

### Accessibility

Ordered list; aria-current=step on active item; status in accessible text; decorative icons/connectors aria-hidden on items.

---

## VerticalStepperItem

**Node ID:** `3437:531`

AI-READY COMPONENT: VerticalStepperItem is a vertical step row that pairs a structural status indicator with a nested ListItem for content and optional row behaviors. Use it inside VerticalStepper or another ordered multi-step composition when each step needs contextual text and may reuse ListItem density, trailing actions or interaction states. Use status=completed for finished steps, status=current for the active step, status=pending for upcoming steps and status=error only when the step has a real blocking error with explanatory copy. Props: showConnector hides the vertical connector for the final item; status selects the structural icon and connector color. Nested ListItem props are exposed on the set: headline, supportingText, overline, trailingSupportingText, condition, showSupportingText, showOverline, showTrailingSupportingText, showDivider, leading, trailing and stateLayer. Defaults: leading=none (status lives in indicatorColumn — avoid duplicate leading status icons), trailing=none, showDivider=false, condition=2-line, showSupportingText=true, showOverline=false, stateLayer default. Interaction rule: default non-interactive with stateLayer=default; enable ListItem hover/pressed/focus/disabled or trailing/leading controls only when the step is intentionally actionable and progress is safely persisted. Icons are structural and fixed by status: circle-check-filled for completed, circle-dot-filled for current, circle-outline for pending and circle-x-filled for error. Do not expose arbitrary status icon swaps. Connector rule: completed uses color/actions/primary; current, pending and error use color/border/2. Do not color future connectors danger. Layout: horizontal Auto Layout with indicatorColumn and ListItem; root uses a 327px demonstration width and should use Fill container in compositions; indicatorColumn uses a 24px statusIcon and a 2px connector that stretches with content height. Do not use VerticalStepperItem as StepperPrimary, StepProgressIndicator, ProgressBar, TimelineItem, Button or standalone navigation. Prefer StepperPrimary for compact horizontal labeled steps and StepProgressIndicator for unlabeled segmented progress. Accessibility: the parent VerticalStepper should render an ordered list. Mark the active item with aria-current=step and expose completed, current, pending or error in accessible text. statusIcon and connector are decorative and should be aria-hidden. Color must not be the only status cue. When the nested ListItem is non-interactive, the row receives no focus; when actionable, follow ListItem focus and control semantics. Token rule: local S2 kebab-case variables and local text styles only — color/actions/primary, color/border/2, text/primary, text/secondary, text/placeholder, feedback/danger, spacing/0|050|100, border/width/025, border/radius/0, plus ListItem token rules for content. Future React mapping: VerticalStepperItem(status, showConnector, headline, supportingText, condition, leading, trailing, showSupportingText, showOverline, showDivider, stateLayer, ...). Code Connect is not configured.

### Variants

- **status:** completed | current | pending | error

### Props

| Prop | Tipo / valores |
|---|---|
| `status` | completed \| current \| pending \| error |
| `showConnector` | boolean — hides vertical connector for final item |
| `headline` | TEXT — ListItem primary label (exposed) |
| `supportingText` | TEXT — ListItem supporting copy (exposed) |
| `overline` | TEXT — optional ListItem overline (exposed) |
| `trailingSupportingText` | TEXT — optional trailing meta (exposed) |
| `condition` | 1-line \| 2-line \| 3-line — ListItem density (exposed) |
| `showSupportingText` | true \| false — ListItem (exposed) |
| `showOverline` | true \| false — ListItem (exposed) |
| `showTrailingSupportingText` | boolean — ListItem (exposed) |
| `showDivider` | boolean — ListItem; default false (exposed) |
| `leading` | none \| monogram \| icon \| image \| video \| checkbox \| radio \| switch — default none (exposed) |
| `trailing` | none \| icon \| checkbox \| radio \| switch — default none (exposed) |
| `stateLayer` | INSTANCE_SWAP — ListItemStateLayer; default non-interactive (exposed) |

### Rules

- **composition:** indicatorColumn (statusIcon + connector) + nested ListItem; ListItem props exposed on the set
- **leadingDefault:** leading=none by default — status lives in indicatorColumn; avoid duplicate leading status icons
- **interaction:** default non-interactive (stateLayer=default); enable ListItem states/controls only when step is intentionally actionable
- **icons:** structural by status: circle-check-filled | circle-dot-filled | circle-outline | circle-x-filled; local DS icons only
- **connector:** completed uses color/actions/primary; current|pending|error use color/border/2
- **vsStepperPrimary:** Use StepperPrimary for compact horizontal labeled steps
- **vsStepProgressIndicator:** Use StepProgressIndicator for unlabeled segmented progress
- **usage:** Do not use as StepperPrimary, StepProgressIndicator, ProgressBar, TimelineItem, Button or standalone navigation

### Token rules

- `color/actions/primary` for completed/current icons and completed connector
- `color/border/2` for current|pending|error connectors
- `text/placeholder` for pending icon stroke; `feedback/danger` for error icon
- `spacing/0` | `050` | `100`, `border/width/025`, `border/radius/0` on indicator/root
- ListItem owns content spacing/text tokens

### Accessibility

Parent ordered list; aria-current=step on active item; status in accessible text; statusIcon/connector aria-hidden; color not sole cue; non-interactive rows receive no focus; actionable rows follow ListItem semantics.

---

## SelectCountry

**Node ID:** `3935:5522`

AI-READY COMPONENT: SelectCountry is a compact country/DDI trigger used only inside InputNumber (phone). Anatomy: countryFlag (local Flags, Style=Square Radius=On) + expandIcon (local chevron-down-outline when expanded=false; local chevron-up-outline when expanded=true). Variants: state=default|hover|focus|disabled; size=sm|md; expanded=false|true (14 variants). Sparse matrix: disabled only publishes expanded=false. size=sm is in-field density for InputNumber; size=md uses spacing/100 vertical and spacing/200 horizontal. No fill on default/hover/focus; hover stroke color/border-feedback/primary + border/width/012; focus stroke interactive/focus + border/width/012. Disabled uses root opacity â‰ˆ0.64 with no stroke. Props: countryFlag (INSTANCE_SWAP → local Flags). Do not nest the country menu — compose a floating list externally when expanded=true. Do not use as InputSelect, Autocomplete, Select, stepper, or standalone field. Accessibility: trigger with accessible name beyond the flag; aria-expanded; aria-controls external list; aria-disabled when disabled. Token rule: local S2 kebab-case only — border/radius/300, border/width/012, spacing/050|100|200, interactive/focus, color/border-feedback/primary, text/primary|placeholder on expandIcon. No remote icon libraries; no Border/Icon/* tokens. React mapping: SelectCountry({ state, size, expanded, countryFlag, onOpenChange }). Code Connect is not configured.

### Variants

- **state:** default | hover | focus | disabled
- **size:** sm | md
- **expanded:** false | true (`disabled` only publishes `expanded=false`)

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| hover \| focus \| disabled (disabled â‰ˆ0.64 opacity, no stroke) |
| `size` | sm \| md — sm for in-field InputNumber density |
| `expanded` | false \| true — external country list; invalid with disabled (not published) |
| `countryFlag` | INSTANCE_SWAP — local Flags set (default Brazil Square Radius=On) |

### Rules

- **inputNumberOnly:** Building block for InputNumber phone — not a standalone field
- **noDisabledExpanded:** `state=disabled` only publishes `expanded=false`
- **externalMenu:** Country list floats externally when `expanded=true`; never nested
- **localAssets:** Flags from page `5. Country flags`; chevrons from local DS outline icons
- **vsSelectAutocomplete:** Do not use as InputSelect, Autocomplete, Select, stepper, or standalone field

### Token rules

- `border/radius/300`
- `border/width/012`
- `spacing/050|100|200`
- `interactive/focus`
- `color/border-feedback/primary`
- `text/primary|placeholder` on expandIcon
- no remote `Border/Icon/*` tokens

### Accessibility

button or combobox trigger with accessible name beyond the flag; aria-expanded; aria-controls external list; aria-disabled when disabled.

### Composition

- Flags (local)
- chevron-down-outline / chevron-up-outline (local)
- external country list (screen-level)

---

## Switch

**Node ID:** `3444:318`

AI-READY COMPONENT: Switch is a binary control used to turn a setting on or off. Use checked=true for the on state and checked=false for the off state. Use state=default, focus or disabled to represent interaction state — there is no hover state. Use size=md for standard layouts and size=sm for compact layouts. Use showIcon to show or hide the internal check/x icon on size=md only; size=sm does not publish an icon layer. Icons are structural by checked: x-outline when unchecked and check-outline when checked. Do not use Switch as a Checkbox, RadioButton, Button, Chip, ToggleGroup or navigation item. Accessibility: expose the control as role=switch, reflect state with aria-checked, use aria-disabled when disabled, preserve visible focus, and ensure the switch has an accessible label from the surrounding form field or aria-label. Token rule: use existing DS variables only (color/actions/primary, color/background-surface/0|1|3, interactive/focus|disabled-surface, text/secondary|placeholder, spacing/0|200|250|300|400|500|700, border/radius/full|0, border/width/012|025). React mapping: Switch(checked, state, size, showIcon).

### Variants

- **size:** md | sm
- **state:** default | focus | disabled
- **checked:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `size` | md \| sm |
| `state` | default \| focus \| disabled |
| `checked` | false \| true |
| `showIcon` | boolean — toggles internal check/x icon visibility (size=md only) |

### Rules

- **icons:** structural by checked: x-outline unchecked, check-outline checked; local DS icons only; showIcon applies to size=md only
- **states:** Only default|focus|disabled published — no hover
- **showIconMdOnly:** size=sm does not publish an icon layer
- **usage:** Do not use as Checkbox, RadioButton, Button, Chip, ToggleGroup or navigation item

### Token rules

- `color/actions/primary` for checked track and checked icon stroke
- `color/background-surface/0|1` for thumb; `color/background-surface/3` for unchecked track
- `interactive/focus` | `interactive/disabled-surface` for state affordances
- `text/secondary` | `text/placeholder` for unchecked icon by state
- `spacing/0` | `200` | `250` | `300` | `400` | `500` | `700` and `border/radius/full` | `0`, `border/width/012` | `025`

### Accessibility

role=switch; aria-checked reflects checked; aria-disabled when disabled; visible focus; accessible label from form field or aria-label.

---

## TabItem

**Node ID:** `3532:6782`

AI-READY COMPONENT: TabItem is the individual tab control used inside a Tabs/TabList pattern to switch between related views in the same page or section. Use variant=primary for filled/elevated tab treatment and variant=secondary for underline tab treatment. Use state=default, hover, selected or disabled. Focus is intentionally not published on TabItem. Use platform=web or platform=mobile for density. Use appearance=default on standard surfaces and appearance=inverse on inverse/dark/on-color surfaces. Intentional sparse matrix: appearance=inverse is published only for variant=primary + platform=mobile. It is not published for primary+web or for any secondary combination. Use label for the visible tab text. Use showIcon to toggle the leading icon and leadingIcon (INSTANCE_SWAP) to choose the local DS outline icon. Use showAttention and attentionIcon for the optional attention/status affordance. Do not use TabItem as a standalone Button, NavigationItem, Chip, segmented control, or page-level route link. Compose TabItem only inside a Tabs/TabList wrapper. Accessibility: wrapper role=tablist; each TabItem role=tab; aria-selected=true only for state=selected; disabled tabs aria-disabled=true; decorative icons aria-hidden when label is visible; keyboard follows Tabs pattern (arrows + Enter/Space). Token rule: prefer DS kebab-case variables (color/actions/primary, color/background-surface/0, text/primary|brand, spacing/100|150, border/radius/0|300). Avoid Title Case legacy aliases; Border/Icon/20 may remain on icon stroke weight when no local kebab equivalent exists. React mapping: TabItem(variant, state, platform, appearance, label, showIcon, leadingIcon?, showAttention, attentionIcon?).

### Variants

- **variant:** primary | secondary
- **state:** default | hover | selected | disabled
- **platform:** web | mobile
- **appearance:** default | inverse

### Props

| Prop | Tipo / valores |
|---|---|
| `variant` | primary \| secondary |
| `state` | default \| hover \| selected \| disabled |
| `platform` | web \| mobile |
| `appearance` | default \| inverse |
| `label` | TEXT — visible tab label |
| `showIcon` | boolean — toggles leadingIcon visibility |
| `leadingIcon` | INSTANCE_SWAP — local DS outline icon |
| `showAttention` | boolean — toggles attentionIcon visibility |
| `attentionIcon` | INSTANCE_SWAP — optional attention/status icon |

### Rules

- **composition:** Compose only inside Tabs/TabList — not a standalone Button/NavigationItem/Chip
- **intentionalSparse:** appearance=inverse only for variant=primary + platform=mobile
- **noFocus:** Focus is intentionally not published
- **secondaryIndicator:** selectedIndicator visible only on state=selected for variant=secondary
- **usage:** Do not use as Button, NavigationItem, Chip, segmented control or page-level route link

### Token rules

- `color/actions/primary` and `color/background-surface/0`
- `text/primary` | `text/brand`
- `spacing/100` | `150` and `border/radius/0` | `300`
- `Border/Icon/20` may remain on icon strokeWeight when no local kebab equivalent exists

### Accessibility

role=tab inside role=tablist; aria-selected only when selected; aria-disabled when disabled; decorative icons aria-hidden when label visible.

---

## TabsPrimary

**Node ID:** `3532:6900`

AI-READY COMPONENT: TabsPrimary is the primary tab-list wrapper used to navigate between related sections of content. Compose only with local TabItem instances (variant=primary). Do not use TabsPrimary as a single TabItem, segmented control, navigation bar, chip group, breadcrumb or button group. Use itemCount=2–5 to control how many TabItem instances are composed. Use platform=web or platform=mobile to match TabItem density. Use alignment=left or alignment=center for horizontal distribution of items. Use appearance=default on standard surfaces and appearance=inverse on inverse/dark/on-color surfaces. Intentional sparse matrix: appearance=inverse is published only for platform=mobile (aligned with TabItem inverse availability). It is not published for platform=web. Demo variants show tabItem01 as state=selected; in product implementation selection is controlled via nested TabItem state. Accessibility: map the wrapper to role=tablist; each TabItem to role=tab; active tab aria-selected=true; support arrow-key navigation; decorative icons aria-hidden when a visible label is present. Token rule: use existing DS kebab-case variables on the wrapper (spacing/050|100|150|200, border/radius/0|200|300, color/background-surface/0|2). Nested TabItem/icon may retain Border/Icon/* strokeWeight leftovers when no local kebab equivalent exists. React mapping: TabsPrimary(itemCount, platform, alignment, appearance, children as TabItem).

### Variants

- **itemCount:** 2 | 3 | 4 | 5
- **platform:** web | mobile
- **alignment:** left | center
- **appearance:** default | inverse

### Props

| Prop | Tipo / valores |
|---|---|
| `itemCount` | 2 \| 3 \| 4 \| 5 — number of composed TabItem instances |
| `platform` | web \| mobile — synced to nested TabItem platform |
| `alignment` | left \| center — horizontal distribution |
| `appearance` | default \| inverse — synced to nested TabItem appearance |

### Rules

- **composition:** Compose only local TabItem variant=primary (tabItem01–tabItem0N)
- **intentionalSparse:** appearance=inverse published only for platform=mobile — not for platform=web
- **selectionDemo:** Demo shows tabItem01 as selected; product selection via nested TabItem.state
- **usage:** Do not use as single TabItem, segmented control, nav bar, chip group, breadcrumb or button group

### Token rules

- `spacing/050` | `100` | `150` | `200` on the wrapper
- `border/radius/0` | `200` | `300` and `color/background-surface/0` | `2`
- `Border/Icon/*` may remain on nested icon strokeWeight when no local kebab equivalent exists

### Accessibility

role=tablist; nested TabItem role=tab; aria-selected on active tab; arrow-key navigation; decorative icons aria-hidden when label visible.

---

## TabsSecondary

**Node ID:** `3532:7346`

AI-READY COMPONENT: TabsSecondary is the secondary tab-list wrapper used for nested or secondary navigation inside a page, section or panel. Compose only with local TabItem instances using variant=secondary. Do not use TabsSecondary as a standalone TabItem, SegmentedControl, ButtonGroup, NavigationBar or primary page navigation (use TabsPrimary for that). Use itemCount=2–5 to control how many TabItem instances are composed. Use platform=web or platform=mobile to match TabItem density. Use alignment=left or alignment=center for horizontal distribution. There is no appearance axis on TabsSecondary — TabItem secondary does not publish appearance=inverse, so inverse combinations are intentionally absent. The wrapper does not publish state, focus, selected or disabled; interaction states live on nested TabItem. Demo variants show tabItem01 as state=selected; product selection is controlled via nested TabItem state. Accessibility: map the wrapper to role=tablist; each TabItem to role=tab; active tab aria-selected=true; support ArrowLeft/ArrowRight and Home/End when applicable; decorative icons aria-hidden when a visible label is present. Token rule: use existing DS kebab-case variables on the wrapper (spacing/0|050|100|150|200, border/radius/0|full, border/width/012, color/background-surface/0). Nested TabItem/icon may retain Border/Icon/* strokeWeight leftovers when no local kebab equivalent exists. React mapping: TabsSecondary(itemCount, platform, alignment, children as TabItem secondary).

### Variants

- **itemCount:** 2 | 3 | 4 | 5
- **platform:** web | mobile
- **alignment:** left | center

### Props

| Prop | Tipo / valores |
|---|---|
| `itemCount` | 2 \| 3 \| 4 \| 5 — number of composed TabItem instances |
| `platform` | web \| mobile — synced to nested TabItem platform |
| `alignment` | left \| center — horizontal distribution |

### Rules

- **composition:** Compose only local TabItem variant=secondary (tabItem01–tabItem0N)
- **noAppearance:** No appearance axis — TabItem secondary does not publish inverse; inverse combinations are intentionally absent
- **selectionDemo:** Demo shows tabItem01 as selected; product selection via nested TabItem.state
- **usage:** Do not use as standalone TabItem, SegmentedControl, ButtonGroup, NavigationBar or primary page navigation (use TabsPrimary)

### Token rules

- `spacing/0` | `050` | `100` | `150` | `200` on the wrapper
- `border/radius/0` | `full`, `border/width/012`, `color/background-surface/0`
- `Border/Icon/*` may remain on nested icon strokeWeight when no local kebab equivalent exists

### Accessibility

role=tablist; nested TabItem role=tab; aria-selected on active tab; ArrowLeft/ArrowRight and Home/End when applicable; decorative icons aria-hidden when label visible.

---

## TextHeader

**Node ID:** `3667:4129`

AI-READY COMPONENT: TextHeader is the compact title + optional supporting text block used inside AppHeader, SystemHeader, and similar chrome. Props: `size=large|medium|small`; `alignment=left|center`; `title` (TEXT); `description` (TEXT); `showDescription` (BOOLEAN, default true). Typography: `large` → `heading/h1/medium` + `body/large/regular`; `medium` → `heading/h2/medium` + `body/medium/regular`; `small` → `heading/h3/medium` + `body/small/regular`. Do not use Text AppHeader, Button label, Chip, Banner, or page hero. AppHeader `hierarchy=global` does **not** use TextHeader — greeting stays `body/large/medium`. React mapping: TextHeader(size, alignment, title, description, showDescription).

### Variants

- **size:** large | medium | small
- **alignment:** left | center

### Props

| Prop | Tipo / valores |
|---|---|
| `size` | large \| medium \| small |
| `alignment` | left \| center |
| `title` | TEXT — headline |
| `description` | TEXT — supporting |
| `showDescription` | boolean — default true |

### Rules

- **matrix:** Published 6/6 — size × alignment
- **appHeaderUsage:** AppHeader specific|super-app nests TextHeader as `headingContent`; global uses greeting `body/large/medium`
- **inverseOverride:** When nested in `appearance=inverse` chrome (e.g. AppHeader), override title → `text/on-color` and description → `text/on-color-disabled`
- **kebab:** Variant keys/values kebab-case

### Token rules

- size=large: `heading/h1/medium` + `body/large/regular`
- size=medium: `heading/h2/medium` + `body/medium/regular`
- size=small: `heading/h3/medium` + `body/small/regular`
- `text/primary` on title; `text/secondary` on description

### Accessibility

Title provides the accessible name for the header region when nested; supporting description is supplementary.

---

## Toast

**Node ID:** `3550:4107`

AI-READY COMPONENT: Toast is a transient feedback message used to confirm an action, inform system status, or warn about a temporary condition. Use for short, non-blocking messages. Do not use as Modal, Banner, AlertDialog, Snackbar replacement for persistent critical content, or primary navigation. Variants: status=system|info|success|danger|warning. status=danger replaces deprecated error naming. status=system is intentional-sparse and has no statusIcon; other statuses compose a local DS statusIcon. Props: message (TEXT), showAction (BOOLEAN, default false), dismissible (BOOLEAN, default true). When showAction=true, set the nested action Button label (React actionLabel). dismiss controls the dismiss Button (x-outline). Composition: action and dismiss use the local Button component (variant=text). Status icons use local DS filled icons only (info-circle-filled, circle-check-filled, alert-circle-filled, alert-triangle-filled). Accessibility: role=status for system|info|success. role=alert only for urgent warning|danger. Do not move focus automatically. If dismissible=true, expose a clear accessible close label. Decorative status icons should be aria-hidden=true when the message already communicates status. Token rule: use existing DS kebab-case variables (color/background-surface/inverse-3, text/on-color, spacing/0|150|200, border/radius/400, color/elevation/6). Status icon fills: feedback/success|danger|warning; info uses feedback/info (no local feedback/info). React mapping: Toast(status, message, showAction, actionLabel, dismissible, onAction, onDismiss).

### Variants

- **status:** system | info | success | danger | warning

### Props

| Prop | Tipo / valores |
|---|---|
| `status` | system \| info \| success \| danger \| warning |
| `message` | main toast message |
| `showAction` | boolean — toggles nested action Button (default false) |
| `actionLabel` | React mapping for nested action Button label (Figma: Button.label) |
| `dismissible` | boolean — toggles dismiss Button with x-outline (default true) |

### Rules

- **composition:** Compose local Button for action and dismiss; local DS filled status icons only
- **intentionalSparse:** status=system publishes no statusIcon
- **actionLabel:** actionLabel is React-side; in Figma set nested action Button label when showAction=true
- **usage:** Do not use as Modal, Banner, AlertDialog or persistent critical content

### Status map

| Status | Ãcone | Icon fill token |
|---|---|---|
| system | — | — |
| info | `info-circle-filled` | `feedback/info` |
| success | `circle-check-filled` | `feedback/success` |
| danger | `alert-circle-filled` | `feedback/danger` |
| warning | `alert-triangle-filled` | `feedback/warning` |

### Token rules

- `color/background-surface/inverse-3`, `text/on-color`
- `spacing/0` | `150` | `200`, `border/radius/400`, `color/elevation/6`
- Status icon fills: `feedback/success` | `danger` | `warning`; info → `feedback/info`

### Accessibility

role=status for system|info|success; role=alert only for urgent warning|danger; no automatic focus move; dismiss needs accessible close label; decorative status icons aria-hidden when message conveys status.

---

## Tooltip

**Node ID:** `3566:10587`

AI-READY COMPONENT: Tooltip is the simple/base contextual tooltip of Design System 2.0. Use for short, purely informational help associated with a trigger. Do not use for long content, persistent critical messages, forms, clickable actions, or decision flows — use TooltipRich, Popover, or Dialog depending on complexity. Variants: placement=top-center|top-left|top-right|bottom-center|bottom-left|bottom-right. Props: description (TEXT). Composition: description text and a decorative arrow. No buttons and no internal focus. Arrow constraints: top placements vertical=MIN and bottom placements vertical=MAX; horizontal follows placement — center=CENTER, left=MIN, right=MAX. Accessibility: associate to the trigger via aria-describedby when visible; open on hover/focus; close on blur, mouseleave and Escape; do not move focus automatically; arrow must be aria-hidden=true. Token rule: use existing DS kebab-case variables and local text styles only — color/background-surface/inverse-3 for surface and arrow, text/on-color and body/small/regular for description, color/elevation/6 for drop shadow (radius/offsetY spacing/100; spread/offsetX spacing/0), spacing/0 gap, spacing/200 padding, spacing/200×spacing/150 arrow size, border/radius/300 on surface, border/radius/0 on arrow, border/width/012 on surface and arrow stroke weight. React mapping: Tooltip(placement, description). Code Connect is not configured.

### Variants

- **placement:** top-center | top-left | top-right | bottom-center | bottom-left | bottom-right

### Props

| Prop | Tipo / valores |
|---|---|
| `placement` | top-center \| top-left \| top-right \| bottom-center \| bottom-left \| bottom-right |
| `description` | TEXT — short informational tooltip text |

### Rules

- **composition:** description TEXT + decorative arrow only — no buttons or internal focus
- **vsTooltipRich:** Use TooltipRich when title, actions, or richer content are needed
- **arrowConstraints:** top vertical=MIN; bottom vertical=MAX; horizontal center=CENTER, left=MIN, right=MAX
- **usage:** Do not use for long content, critical persistent messages, forms, or actionable flows

### Token rules

- `color/background-surface/inverse-3` on surface and arrow
- `text/on-color` + `body/small/regular` on description
- `color/elevation/6` drop shadow (radius/offsetY `spacing/100`; spread/offsetX `spacing/0`)
- `spacing/0` gap; `spacing/200` padding; arrow size `spacing/200`×`spacing/150`
- `border/radius/300` surface; `border/radius/0` arrow; `border/width/012` stroke weight

### Accessibility

aria-describedby when visible; open on hover/focus; close on blur/mouseleave/Escape; no automatic focus move; arrow aria-hidden.

---

## TooltipRich

**Node ID:** `3566:10477`

AI-READY COMPONENT: TooltipRich is a rich contextual tooltip/popover surface with optional title, description, and primary/secondary actions. Use it when contextual guidance needs more than a short passive tooltip. Do not use it as a Modal, Toast, Dropdown, Select, Menu, or persistent help panel. Variants: placement=top-center|top-left|top-right|bottom-center|bottom-left|bottom-right. Props: title, showTitle, description, showDescription, showActions, showPrimaryAction, showSecondaryAction. Action labels live on nested Button label (React: primaryActionLabel / secondaryActionLabel). Composition: must use local Button for actions — primaryAction maps to Button variant=solid size=sm intent=primary; secondaryAction maps to Button variant=text size=sm intent=primary. Intentional token override: on the inverse tooltip surface, secondaryAction label uses text/on-color (not the default Button text/primary) so the text remains readable on color/background-surface/inverse-3. The arrow is decorative and must be aria-hidden=true. Accessibility: when content is purely informative, associate it to the trigger with aria-describedby. When it includes actionable buttons, treat the behavior as a lightweight popover/dialog: allow focus to enter the surface, preserve logical focus order, close on Escape, and return focus to the trigger. Buttons must have clear accessible labels. Do not auto-focus content on hover-only reveal. Token rule: use existing DS kebab-case variables (color/background-surface/inverse-3, text/on-color, color/elevation/6, spacing/0|100|150|200, border/radius/300). React mapping: TooltipRich(placement, title, showTitle, description, showDescription, showActions, showPrimaryAction, showSecondaryAction, primaryActionLabel, secondaryActionLabel, onPrimaryAction, onSecondaryAction).

### Variants

- **placement:** top-center | top-left | top-right | bottom-center | bottom-left | bottom-right

### Props

| Prop | Tipo / valores |
|---|---|
| `placement` | top-center \| top-left \| top-right \| bottom-center \| bottom-left \| bottom-right |
| `title` | optional heading text |
| `showTitle` | boolean |
| `description` | optional body text |
| `showDescription` | boolean |
| `showActions` | boolean — toggles actions container |
| `showPrimaryAction` | boolean — toggles primaryAction Button |
| `showSecondaryAction` | boolean — toggles secondaryAction Button |
| `primaryActionLabel` | React mapping for nested primary Button label |
| `secondaryActionLabel` | React mapping for nested secondary Button label |

### Rules

- **composition:** primaryAction = Button solid/sm/primary; secondaryAction = Button text/sm/primary; local DS icons only
- **intentionalSecondaryOnColor:** secondaryAction label uses `text/on-color` on inverse surface — intentional override, do not remap to `text/primary`
- **layerOrder:** content → arrow → actions on all placements
- **usage:** Do not use as Modal, Toast, Dropdown, Select, Menu, or persistent help panel

### Token rules

- `color/background-surface/inverse-3`, `text/on-color`, `color/elevation/6`
- `spacing/0` | `100` | `150` | `200`, `border/radius/300`
- secondaryAction label: `text/on-color` (intentional)

### Accessibility

aria-describedby when informative; popover/dialog focus pattern when actionable; Escape closes and returns focus to trigger; arrow aria-hidden; no auto-focus on hover-only reveal.

---

## TableCell

**Node ID:** `3459:13960`

AI-READY COMPONENT: TableCell is a reusable table cell used inside a Table row to display header text, primary content, secondary content, tertiary content with description, or slot-based custom content. Use type=header for column headers, type=primary for main cell content, type=secondary for supporting cell content, type=tertiary when label and description are needed, and type=slot for custom slot content. Use state=default, hover, pressed or selected to represent interaction state — there is no focus state on TableCell. type=header is intentional-sparse and publishes only state=default. Use header, label and description text properties for visible content, and slot for type=slot custom content. Do not use TableCell as a full Table, Card, ListItem, Button, NavigationItem or standalone layout container. Accessibility: use inside a semantic table structure; header cells map to columnheader/th, body cells to cell/td; actionable content inside type=slot must expose buttons/links with clear accessible labels. Token rule: use existing DS variables only (color/background-surface/0|2, interactive/hover|pressed|selected, color/border/1|2, text/primary|secondary, spacing/0|150|200|500|800, border/radius/0, border/width/012). React mapping: TableCell(type, state, header, label, description, slot?).

### Variants

- **type:** header | primary | secondary | tertiary | slot
- **state:** default | hover | pressed | selected

### Props

| Prop | Tipo / valores |
|---|---|
| `header` | column header text (type=header) |
| `label` | primary cell text (primary\|secondary\|tertiary) |
| `description` | supporting text (type=tertiary) |
| `slot` | custom content slot (type=slot) |
| `type` | header \| primary \| secondary \| tertiary \| slot |
| `state` | default \| hover \| pressed \| selected |

### Rules

- **sparseHeader:** type=header publishes only state=default (intentional-sparse)
- **noFocus:** No state=focus published
- **noShowAction:** showAction axis removed; cells do not publish a trailing action Button
- **slotType:** type=slot uses the slot property for custom/actionable content
- **usage:** Do not use as full Table, Card, ListItem, Button, NavigationItem or standalone layout container

### Token rules

- `color/background-surface/0` for body cells; `color/background-surface/2` for header
- `interactive/hover` | `pressed` | `selected` for interaction fills
- `text/primary` for labels; `text/secondary` for header and description
- `spacing/0` | `150` | `200` | `500` | `800`
- `border/radius/0`, `border/width/012`

### Accessibility

Use inside semantic table; header → columnheader/th; body → cell/td; actionable content in type=slot must expose button/link with clear accessible label.

---

## TableExpandCell

**Node ID:** `3459:8530`

AI-READY COMPONENT: TableExpandCell is an interactive expansion control cell used inside TableRow to expand or collapse row details. Use type=body for regular table rows and type=header for header-level expand controls when the product supports expand-all behavior. Use state=default, hover, pressed, selected, focus or disabled to represent interaction state. Density is fixed (no size axis). state=selected represents the expanded visual: chevron-up-outline with text/primary. Collapsed interactive states use chevron-down-outline with text/secondary (text/placeholder when disabled). The icon INSTANCE_SWAP applies to non-selected states; on state=selected the chevron-up icon is structural and not swap-driven. showChevron is a header-oriented variant axis (true|false). Use showChevron=true for interactive header expand controls. Use type=header + state=default + showChevron=false as an intentional-sparse spacer: no chevron is rendered, but the cell keeps the same 56×40 footprint so body expand columns stay aligned. showChevron=false is not published for type=body. Do not use TableExpandCell as a full TableCell, Button, PaginationItem, NavigationItem or generic icon button outside table rows. Accessibility: expose as a button when interactive (showChevron=true), provide an accessible label such as Expand row or Collapse row, use aria-expanded reflecting expanded/collapsed, and preserve visible focus. For showChevron=false spacer headers, omit the control from the accessibility tree (aria-hidden or presentational) because there is no interactive expand affordance. Token rule: use existing DS variables only (color/background-surface/0|2, interactive/hover|pressed|focus, text/secondary|primary|placeholder, spacing/0|200|800, border/radius/0|100, border/width/0|025). React mapping: TableExpandCell(type, state, showChevron, icon).

### Variants

- **type:** body | header
- **state:** default | hover | pressed | selected | focus | disabled
- **showChevron:** true | false

### Props

| Prop | Tipo / valores |
|---|---|
| `icon` | INSTANCE_SWAP — local DS outline icon; applies to non-selected states |
| `type` | body \| header |
| `state` | default \| hover \| pressed \| selected \| focus \| disabled |
| `showChevron` | true \| false — header spacer when false (intentional-sparse with state=default only) |

### Rules

- **density:** Fixed density — no size axis
- **selectedExpanded:** state=selected = expanded visual (chevron-up-outline, text/primary)
- **iconStructuralSelected:** On state=selected, chevron-up is structural and not icon INSTANCE_SWAP-driven
- **headerSpacer:** type=header + state=default + showChevron=false keeps 56×40 with no chevron; not published for type=body
- **icons:** Collapsed states: chevron-down-outline; local DS icons only
- **usage:** Do not use as TableCell, Button, PaginationItem, NavigationItem or generic icon button outside table rows

### Token rules

- `color/background-surface/0` for body; `color/background-surface/2` for header
- `interactive/hover` | `pressed` on icon frame; `interactive/focus` for focus affordance
- `text/secondary` | `text/primary` | `text/placeholder` for icon stroke by state
- `spacing/0` | `200` | `800` and `border/radius/0` | `100`, `border/width/0` | `025`

### Accessibility

Button when interactive (showChevron=true); Expand/Collapse label; aria-expanded maps selected→true; spacer header (showChevron=false) should be presentational/aria-hidden.

---

## TableMobile

**Node ID:** `3452:2722`

AI-READY COMPONENT: TableMobile is the mobile/compact data-row composite used to present tabular data as a list or card-like block on small screens. It composes local TableMobileCell instances (and nested Button inside type=action cells). Use state=default, hover or pressed for the block interaction state. Focus, selected and disabled are intentionally not published on TableMobile. Use interactive=true when the block shows the expanded/affordance layout (second detailRow; typically taller). Use interactive=false for the compact single-row layout. Use showTag=true to show the tag TableMobileCell and showTag=false to hide it. Use columnCount=2–6 to control how many informational cells are composed in the row(s). Intentional sparse matrix: interactive=true is published only for columnCount=4|5|6 — columnCount=2|3 do not combine with interactive=true. Do not use TableMobile as desktop Table/TableRow/TableCell, as a standalone Card, or by rebuilding cells from raw text/icons. Accessibility: when interactive, map to button/link/listitem per product navigation; expose a clear accessible name from primary content; if expansion is used, expose aria-expanded on the real control; decorative icons aria-hidden=true. Token rule: use existing DS kebab-case variables only (color/background-surface/0, color/border/2, spacing/0|100|200|250|500|700|800, border/width/0|012, border/radius/0). Avoid Title Case legacy aliases. React mapping: TableMobile(state, interactive, showTag, columnCount).

### Variants

- **state:** default | hover | pressed
- **interactive:** false | true
- **showTag:** true | false
- **columnCount:** 2 | 3 | 4 | 5 | 6

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| hover \| pressed |
| `interactive` | false \| true — expanded/affordance layout when true |
| `showTag` | true \| false — toggles tag TableMobileCell |
| `columnCount` | 2 \| 3 \| 4 \| 5 \| 6 |

### Rules

- **composition:** Composes local TableMobileCell (row + optional detailRow)
- **intentionalSparse:** interactive=true only with columnCount=4|5|6; not published for columnCount=2|3
- **noFocusSelectedDisabled:** Focus, selected and disabled are intentionally not published
- **vsTable:** Mobile composite — do not substitute for desktop Table/TableRow/TableCell
- **usage:** Do not rebuild from raw text/icons or use as standalone Card

### Token rules

- `color/background-surface/0` and `color/border/2`
- `spacing/0` | `100` | `200` | `250` | `500` | `700` | `800`
- `border/width/0` | `012` and `border/radius/0`

### Accessibility

Interactive blocks map to button/link/listitem; clear accessible name; aria-expanded when expanding; decorative icons aria-hidden.

---

## TableMobileCell

**Node ID:** `3452:2656`

AI-READY COMPONENT: TableMobileCell is a reusable mobile table cell used inside mobile table rows, responsive table lists or compact table-card layouts. Use type=primary for the main value, type=secondary for supporting value, type=tag for compact status/tag content via slot, type=action for an inline Button action, and type=icon for an icon-only affordance. Use state=default, hover, pressed or selected to represent visual interaction state. Focus and disabled are intentionally not published on this component. Use label for visible text on primary/secondary cells, slot for type=tag custom content (preferred Chip/Tag), and icon INSTANCE_SWAP for type=icon (local DS outline icons only). Unlike desktop TableCell, TableMobileCell has no type=header or type=tertiary and uses type=tag|action|icon instead of type=slot for those mobile patterns. Do not use TableMobileCell as a full Table, TableRow, TableCell, Card, Button, Chip, NavigationItem or standalone layout container. Accessibility: when the cell or owning row is tappable, expose button/link semantics and a clear accessible label; selected state should be communicated by the parent row/list semantics; icon-only cells require aria-label or surrounding context; decorative icons should be aria-hidden. Token rule: use existing DS variables only (color/background-surface/0, interactive/hover|pressed|selected, text/primary|secondary, spacing/0|100|800, border/radius/0). Avoid Title Case legacy aliases such as Spacing/800. React mapping: TableMobileCell(type, state, label, slot?, icon?).

### Variants

- **type:** primary | secondary | tag | action | icon
- **state:** default | hover | pressed | selected

### Props

| Prop | Tipo / valores |
|---|---|
| `type` | primary \| secondary \| tag \| action \| icon |
| `state` | default \| hover \| pressed \| selected |
| `label` | TEXT — primary/secondary visible text |
| `slot` | SLOT — type=tag content (preferred chip clickable) |
| `icon` | INSTANCE_SWAP — type=icon local DS outline icon |

### Rules

- **noInteractiveAxis:** interactive variant axis removed — tap/action semantics live on the parent row or nested Button
- **noFocusDisabled:** Focus and disabled are intentionally not published
- **vsTableCell:** No type=header/tertiary; uses type=tag|action|icon instead of desktop type=slot patterns
- **actionComposesButton:** type=action composes local Button (variant=text, size=sm)
- **usage:** Do not use as Table, TableRow, TableCell, Card, Button, Chip, NavigationItem or standalone layout container

### Token rules

- `color/background-surface/0` for default surface
- `interactive/hover` | `pressed` | `selected` for state surfaces
- `text/primary` for primary label; `text/secondary` for secondary label
- `spacing/0` | `100` | `800` and `border/radius/0`

### Accessibility

Tappable row/action → button/link + clear label; selected via parent semantics; icon-only needs aria-label; decorative icons aria-hidden.

---

## TableRow

**Node ID:** `3459:12787`

AI-READY COMPONENT: TableRow is a table row container composed of TableCell instances plus an optional trailing TableExpandCell. Use type=header for header rows and type=body for body rows. Use cellCount=3, 4, 5, 6, 7, 8 or 9 to control how many TableCell instances are visible in the row. Cells are named headerCell01–headerCell09 (header) or cell01–cell09 (body). Use showExpandCell=true to show the trailing expandCell (TableExpandCell) at the end of the row, and showExpandCell=false to hide it. Use state=default, hover, pressed, selected or focus to represent row-level interaction. Header rows intentionally publish only state=default. Body rows publish default, hover, pressed, selected and focus. state=focus is row-level only — nested TableCell instances stay on matching non-focus cell states because TableCell has no focus axis. The expandCell type matches the row type (header|body) and its state matches the row state when available. TableRow must compose local TableCell and TableExpandCell instances; it must not recreate cell internals manually. Do not use TableRow as a full Table, Card, ListItem, Button, NavigationItem, grid layout or standalone content section. Accessibility: use TableRow inside a semantic table structure. Header rows belong inside the table header and cells map to columnheader/th. Body rows map to row/tr and cells map to cell/td. Interactive rows should preserve visible focus and expose selected state when selection is meaningful. When showExpandCell=true, the expand control needs Expand row / Collapse row labeling and aria-expanded. Token rule: use existing DS variables only (border/radius/0|200, border/width/012|025, interactive/focus on focus rows, nested TableCell and TableExpandCell tokens). React mapping: TableRow(type, cellCount, state, showExpandCell, cells, expandCell?).

### Variants

- **type:** header | body
- **cellCount:** 3 | 4 | 5 | 6 | 7 | 8 | 9
- **state:** default | hover | pressed | selected | focus

### Props

| Prop | Tipo / valores |
|---|---|
| `type` | header \| body |
| `cellCount` | 3 \| 4 \| 5 \| 6 \| 7 \| 8 \| 9 |
| `state` | default \| hover \| pressed \| selected \| focus |
| `showExpandCell` | boolean — toggles trailing expandCell (TableExpandCell) visibility |

### Rules

- **composition:** Composes local TableCell (headerCell01–09 / cell01–09) plus optional trailing expandCell
- **showExpandCell:** BOOLEAN; expandCell is last child; type/state match the row
- **sparseHeader:** type=header publishes only state=default (intentional-sparse)
- **rowLevelFocus:** state=focus is row-level only; nested TableCell has no focus axis
- **cellTypes:** Body demo cells use secondary, primary, tertiary and slot TableCell types
- **usage:** Do not use as full Table, Card, ListItem, Button, NavigationItem or standalone layout

### Token rules

- `border/radius/0` | `200` and `border/width/012` | `025` for row chrome / focus corners
- `interactive/focus` for row-level focus affordance
- Nested TableCell and TableExpandCell use their own DS tokens

### Accessibility

Header rows → thead/columnheader; body rows → tr/td; preserve visible focus; expose selected when selection is meaningful; expandCell needs Expand/Collapse label and aria-expanded when shown.

---

## TableSkeleton

**Node ID:** `3459:9331`

AI-READY COMPONENT: TableSkeleton is a non-interactive loading placeholder used while table data is being fetched. Use empty=false for the normal loading table skeleton (header and body skeletonBars visible) and empty=true for the empty-state loading layout (header skeletonBars remain visible; body skeletonBars are hidden). empty is published as a variant axis (false|true), not a BOOLEAN prop. Density is fixed in Figma: 5 columns and 6 visible body rows (bodyRow01–bodyRow06). bodyRow07–bodyRow10 exist as intentional leftover layers and stay hidden in both empty variants — they are not a published rowCount axis. Structure uses headerRow with headerSkeletonCell01–05 and body rows with skeletonCell01–05 containing skeletonBar. Do not use TableSkeleton as a data table, TableRow, TableCell, ProgressBar, LoadingSpinner, card or decorative illustration. Accessibility: hide visual skeleton bars from assistive technologies with aria-hidden=true and expose the real loading state from the parent table region with aria-busy=true or a nearby status message. Token rule: use existing DS variables only (color/background-surface/0|2|3, color/border/1|2, spacing/0|100|200|250, border/radius/0|full, border/width/012). React mapping: TableSkeleton(empty).

### Variants

- **empty:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `empty` | false \| true — variant axis; empty=true hides body skeletonBars |

### Rules

- **emptyAxis:** empty is a VARIANT axis (false|true), not a BOOLEAN prop
- **emptyTrue:** empty=true keeps header skeletonBars; hides body skeletonBars
- **fixedDensity:** Fixed 5 columns and 6 visible body rows (bodyRow01–06)
- **leftoverRows:** bodyRow07–10 are intentional leftovers and remain hidden in both variants
- **usage:** Do not use as data table, TableRow, TableCell, ProgressBar, LoadingSpinner, card or decorative illustration

### Token rules

- `color/background-surface/0` for table/body surfaces
- `color/background-surface/2` for header row and body skeletonBars
- `color/background-surface/3` for header skeletonBars
- `color/border/1` | `color/border/2` for borders
- `spacing/0` | `100` | `200` | `250` and `border/radius/0` | `full`, `border/width/012`

### Accessibility

Skeleton bars aria-hidden=true; parent table region aria-busy=true or nearby status message.

---

## Table

**Node ID:** `3480:6228`

AI-READY COMPONENT: Table is the desktop/web composite table used to assemble a full data table from TableRow instances. Use columns=3–9 to set nested TableRow cellCount for headerRow and rows-slot body rows. Use showHeader=true to show headerRow and showHeader=false to hide it. Use the rows SLOT to control body row count and content — default variants ship with eight bodyRow01–bodyRow08 TableRow instances (type=body); designers may add, remove or replace rows (preferred: TableRow). headerRow must be TableRow type=header with matching cellCount; body rows must be TableRow type=body with matching cellCount. showExpandCell stays available on nested TableRow when needed. Do not use Table as a mobile-only table shell, a single TableRow/TableCell, TableSkeleton, Card, List or decorative layout frame. Accessibility: compose into a semantic table (table/thead/tbody/tr/th/td); headerRow maps to column headers; body rows in the rows slot map to data rows; preserve visible focus, selection and expand semantics from nested TableRow/TableCell/TableExpandCell. Token rule: rely on nested TableRow/TableCell/TableExpandCell DS tokens; do not invent tokens on the Table shell. React mapping: Table(columns, showHeader, rows).

### Variants

- **columns:** 3 | 4 | 5 | 6 | 7 | 8 | 9

### Props

| Prop | Tipo / valores |
|---|---|
| `columns` | 3 \| 4 \| 5 \| 6 \| 7 \| 8 \| 9 — variant axis; sets nested TableRow cellCount |
| `showHeader` | boolean — toggles headerRow visibility |
| `rows` | SLOT — body TableRow instances; defaults include bodyRow01–08; add/remove/replace as needed (preferred TableRow) |

### Rules

- **name:** Published Figma name is Table (platform suffix deferred)
- **modernProps:** Props use camelCase: columns, showHeader, rows
- **rowsSlot:** Body row count is designer-controlled via the rows SLOT; defaults ship eight TableRow body rows
- **composition:** Composes TableRow headerRow plus rows SLOT of TableRow type=body (cellCount matches columns)
- **usage:** Do not use as mobile-only shell, single TableRow/TableCell, TableSkeleton, Card, List or decorative layout frame

### Token rules

- Rely on nested TableRow/TableCell/TableExpandCell DS tokens
- Do not invent tokens on the Table shell

### Accessibility

Semantic table structure; headerRow → column headers; rows slot → data rows; preserve nested focus/selection/expand semantics.

---

## List

**Node ID:** `3745:10921`

AI-READY COMPONENT: List is a vertical container that composes one or more ListItem rows through an items SLOT. Use type=plain for an embedded page list surface and type=dropdown for an elevated menu/panel surface. Defaults: type=dropdown, showScroll=false. Props: items (SLOT — ListItem + optional DividerHorizontal); showScroll. Product-theme: `component/list-action/container/radius` on both plain and dropdown shells (EV→`border/radius/200`; site-loovi|app-cliente→`border/radius/500` — shared with ListActionDropdown). Dropdown elevation `color/elevation/5`. Do not use ListActionDropdownItem inside List. React mapping: List({ type, showScroll, children }).

### Variants

- **type:** plain | dropdown

### Props

| Prop | Tipo / valores |
|---|---|
| `type` | plain \| dropdown |
| `items` | SLOT — prefer ListItem (+ DividerHorizontal) |
| `showScroll` | boolean — toggles local scroll affordance (default false) |

### Product theme (`product-theme`)

Modes: `escritorio-virtual` | `site-loovi` | `app-cliente`

| Token | Bind | escritorio-virtual | site-loovi | app-cliente |
|---|---|---|---|---|
| `component/list-action/container/radius` | shell corner radius on `plain`\|\`dropdown` | `border/radius/200` | `border/radius/500` | `border/radius/500` |

### Rules

- **productTheme:** both types bind shell corners to shared `component/list-action/container/radius` — do not hardcode `radius/0` or `radius/200`
- **slotListItemOnly:** Compose items SLOT with ListItem only — not ListActionDropdownItem
- **plainVsDropdown:** plain = page list surface; dropdown = elevated panel (`elevation/5`)
- **triggerExternal:** dropdown has no internal trigger — parent owns open/aria-expanded
- **vsActionMenu:** For action menus use ListActionDropdown

### Token rules

- `product-theme component/list-action/container/radius` (EV→200; site-loovi|app-cliente→500; shared with ListActionDropdown)
- `color/background-surface/0`
- `elevation/5` on type=dropdown
- scroll: `color/palette/graph` + `border/radius/full`
- nested ListItem and DividerHorizontal tokens

---

## ListActionDropdown

**Node ID:** `3694:1501`

AI-READY COMPONENT: ListActionDropdown is a menu surface container for grouped list actions opened by an external trigger. Use it as the menu panel only — compose action rows with ListActionDropdownItem and separate groups with DividerHorizontal inside the slot. Props: showScroll; showDivider; slot. Product-theme: `component/list-action/container/radius` (EV→`border/radius/200`; site-loovi|app-cliente→`border/radius/500`). Tokens: `color/background-surface/0`, `color/elevation/5`, scroll `color/palette/graph`, spacing/0|050|100|200|300|800. React mapping: ListActionDropdown(showScroll, showDivider, children).

### Props

| Prop | Tipo / valores |
|---|---|
| `showScroll` | boolean — toggles scroll affordance (default false) |
| `showDivider` | boolean — toggles divider in default slot composition (default true) |
| `slot` | menu content — prefer ListActionDropdownItem + DividerHorizontal |

### Product theme (`product-theme`)

Modes: `escritorio-virtual` | `site-loovi` | `app-cliente`

| Token | Bind | escritorio-virtual | site-loovi | app-cliente |
|---|---|---|---|---|
| `component/list-action/container/radius` | shell corner radius (shared with List) | `border/radius/200` | `border/radius/500` | `border/radius/500` |

### Rules

- **productTheme:** shell radius via product-theme — do not hardcode `radius/200`
- **composition:** root surface + slot (items/divider) + scroll affordance
- **itemOnly:** compose rows with ListActionDropdownItem only
- **dividerLocal:** use DividerHorizontal for group separation
- **triggerExternal:** trigger/aria-expanded live outside this component

### Token rules

- `product-theme component/list-action/container/radius` (EV→200; site-loovi|app-cliente→500)
- `color/background-surface/0` for menu surface
- `color/elevation/5` + `spacing/0|200|300` for drop shadow
- nested ListActionDropdownItem and DividerHorizontal tokens

---

## PaginationSelectMenu

**Node ID:** `3841:22501`

AI-READY COMPONENT: PaginationSelectMenu is the numeric listing menu surface opened by PaginationSelectInput. Use it as the panel only — the select trigger owns open state via expanded. Compose rows with PaginationSelectMenuItem inside the items SLOT (numbers for page or page-size options). Props: items is the SLOT for PaginationSelectMenuItem; showScroll toggles the local right-edge scroll affordance when the list overflows. Pattern is based on ListActionDropdown (surface, elevation, scroll) but content-hug width for compact numeric options — do not force 240px. Do not use PaginationSelectMenu as ListActionDropdown, List, generic Dropdown or Modal. Do not put ListActionDropdownItem icons here. Accessibility: map to listbox or menu; trigger uses aria-expanded/aria-controls; options use PaginationSelectMenuItem semantics; scroll is visual-only. Token rule: local S2 kebab-case only — color/background-surface/0, color/elevation/5, spacing/0|100|200|300|050|800, border/radius/200|full, color/palette/graph for scroll; item tokens from PaginationSelectMenuItem. React mapping: PaginationSelectMenu(items, showScroll). Code Connect is not configured.

### Variants

_(none — single component)_

### Props

| Prop | Tipo / valores |
|---|---|
| `items` | SLOT — PaginationSelectMenuItem only (preferredValues) |
| `showScroll` | boolean — toggles local scroll affordance (default false) |

### Rules

- **basedOnListActionDropdown:** Same surface/elevation/scroll pattern as ListActionDropdown; content-hug width for numbers
- **slotItemOnly:** Compose items with PaginationSelectMenuItem only — not ListActionDropdownItem
- **triggerExternal:** PaginationSelectInput owns expanded/open state
- **usage:** Do not use as ListActionDropdown, List, generic Dropdown or Modal

### Token rules

- `color/background-surface/0`
- `color/elevation/5` drop shadow
- `spacing/0` | `100` | `200` | `300`; scroll `spacing/050`×`800` + `border/radius/full`
- `border/radius/200` on surface

### Accessibility

listbox/menu; trigger aria-expanded/aria-controls; scroll visual-only.

### Composition

PaginationSelectMenuItem

---

## PaginationSelectMenuItem

**Node ID:** `3841:22500`

AI-READY COMPONENT: PaginationSelectMenuItem is a numeric option row used inside PaginationSelectMenu to choose a page number or items-per-page value. Use state=default|hover|pressed|selected|focus|disabled. Props: label is the visible numeric (or short) value. Do not add leading icons — this item is numeric-only. Do not use it as ListActionDropdownItem, Button, PaginationItem or MenuItem outside pagination select menus. Composition pattern mirrors ListActionDropdownItem interaction states without icon slots. Accessibility: option role inside a listbox/menu; selected maps to aria-selected=true; disabled uses aria-disabled; focusRing is decorative for the focus state. Token rule: local S2 kebab-case only — color/background-surface/0, interactive/hover|pressed|selected|disabled-surface|focus, text/primary|placeholder, spacing/0|200, border/radius/100, border/width/025, body/medium/regular. React mapping: PaginationSelectMenuItem(state, label). Code Connect is not configured.

### Variants

- **state:** default | hover | pressed | selected | disabled | focus

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| hover \| pressed \| selected \| disabled \| focus |
| `label` | TEXT — numeric (or short) option value |

### Rules

- **numericOnly:** No leading icon — label only
- **vsListActionDropdownItem:** Same interaction states as ListActionDropdownItem without icon slots
- **usage:** Use only inside PaginationSelectMenu

### Token rules

- `color/background-surface/0`; `interactive/hover|pressed|selected|disabled-surface`
- `interactive/focus` on focusRing
- `text/primary` | `text/placeholder`
- `spacing/0` | `200`, `border/radius/100`, `border/width/025`, `body/medium/regular`

### Accessibility

option; aria-selected when selected; aria-disabled when disabled; focusRing decorative.

---

## PaginationSelectInput

**Node ID:** `3653:5902`

AI-READY COMPONENT: PaginationSelectInput is a compact select-like control used inside Pagination to display and change a pagination-related numeric value, such as the current page or items per page. Use value to define the visible selected value. Use expanded=true when the select menu is open (chevron-up-outline, interactive/focus border) and expanded=false when it is closed (chevron-down-outline). Use size=sm, md or lg according to the density of the pagination layout. Use state=default or hover only — focus, pressed and disabled interaction states are not published on this component. Composition: expanded=true nests PaginationSelectMenu as an absolute overlay below the trigger (root hugs the trigger only; menu is not part of hug height). Do not use PaginationSelectInput as a generic TextInput, Button, Dropdown, PaginationItem, SearchInput, form field or standalone select outside pagination unless explicitly documented. Accessibility: map the control to a button or combobox depending on implementation, expose the selected value as the accessible name, use aria-expanded and aria-controls to reflect the open PaginationSelectMenu, and preserve visible keyboard focus. Token rule: use existing DS variables only (interactive/hover|focus, text/primary|secondary, spacing/400|500|600 by size, border/radius/100). React mapping: PaginationSelectInput(value, size, state, expanded). Code Connect is not configured.

### Variants

- **size:** sm | md | lg
- **state:** default | hover
- **expanded:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `value` | visible selected numeric/text value |
| `size` | sm \| md \| lg |
| `state` | default \| hover |
| `expanded` | false \| true |

### Rules

- **icons:** trailing chevron is structural by expanded (down when closed, up when open); local DS outline icons only
- **states:** Only default|hover published — no focus/pressed/disabled axes
- **expandedBorder:** expanded=true uses interactive/focus border (not border-feedback)
- **openOverlay:** expanded=true nests PaginationSelectMenu absolute below trigger; root hugs trigger only
- **usage:** Use inside Pagination; not as generic TextInput, Dropdown, PaginationItem or standalone form select

### Token rules

- `interactive/hover` for hover fill; `interactive/focus` for expanded border
- `text/primary` for value; `text/secondary` for trailing icon
- `spacing/400` (sm) | `500` (md) | `600` (lg) for height
- `border/radius/100` and `border/width/012` | `025`

### Accessibility

Button or combobox; expose selected value; aria-expanded/aria-controls for PaginationSelectMenu; preserve visible keyboard focus.

### Composition

PaginationSelectMenu

---

## Overlay

**Node ID:** `3768:3886`

AI-READY COMPONENT: Overlay is a full-viewport scrim composition used to present a blocking Modal or a mobile BottomSheet on top of page content in prototypes and product layouts. Use type=modal when the slotted content is a centered dialog and type=bottom-sheet when the slotted content is a bottom-anchored sheet. Use platform=mobile for compact device frames and platform=web for desktop/web frames. Intentional sparse matrix: type=bottom-sheet is published only with platform=mobile — do not expect bottom-sheet+web. Props: slot hosts the surface content. Default composition nests local Modal (platform matched) for type=modal and local BottomSheet (header=none) for type=bottom-sheet. Prefer swapping slot content only with local Modal or BottomSheet via preferredValues — do not place Toast, Tooltip, Banner, Card or page chrome in the slot. Do not use Overlay as a standalone Modal, BottomSheet, drawer, toast or opaque page background. Token rule: use existing DS kebab-case variables only — color/overlay/overlay for the scrim, spacing/100 for item gap, spacing/250 for horizontal padding, spacing/400 for modal vertical padding, spacing/700 and spacing/0 for bottom-sheet vertical padding. Accessibility: Overlay provides the dimmed backdrop; the nested Modal/BottomSheet owns dialog semantics (role=dialog or alertdialog when appropriate), focus trap, Escape to dismiss when allowed, and restoring focus to the trigger. The scrim itself is not focusable. React mapping: Overlay(type, platform, children) where children map to slot and should be Modal or BottomSheet. Code Connect is not configured.

### Variants

- **type:** modal | bottom-sheet
- **platform:** mobile | web

### Props

| Prop | Tipo / valores |
|---|---|
| `type` | modal \| bottom-sheet |
| `platform` | mobile \| web (bottom-sheet only with mobile) |
| `slot` | SLOT — default Modal or BottomSheet; preferredValues Modal + BottomSheet |

### Rules

- **composeModalBottomSheet:** type=modal nests local Modal (platform matched); type=bottom-sheet nests local BottomSheet header=none
- **sparseBottomSheet:** bottom-sheet + web is intentionally unpublished
- **slotPreferred:** Swap slot only with local Modal or BottomSheet
- **vsStandalone:** Do not use Overlay as standalone Modal, BottomSheet, drawer, toast or page background

### Token rules

- `color/overlay/overlay` for scrim
- `spacing/100` for item gap
- `spacing/250` for horizontal padding
- `spacing/400` for modal vertical padding
- `spacing/700` + `spacing/0` for bottom-sheet vertical padding

### Accessibility

Scrim is non-focusable; nested Modal/BottomSheet owns dialog semantics, focus trap, Escape and focus restore.

### Composition

Modal, BottomSheet

### Sparse matrix

- no type=bottom-sheet + platform=web

---
## Pagination

**Node ID:** `3382:9417`

AI-READY COMPONENT: Pagination is a navigation control used to move across paginated content such as tables, lists, search results and reports. It composes PaginationItem for page numbers and overflow indicators, plus previousAction and nextAction (Button text/icon, size=sm). Use position=start when the current page is near the beginning (previous disabled), position=middle when the current page is between ranges (both actions enabled), and position=end when the current page is near the final pages (next disabled). Use size=lg for default interfaces and size=sm for compact layouts. Do not use Pagination as tabs, breadcrumbs, stepper, carousel navigation, menu, button group or standalone page number label. Accessibility: map the wrapper to nav with aria-label=Pagination. The active page item should use aria-current=page. Previous and next actions need clear aria-label text and must be disabled when unavailable. Token rule: use existing DS variables only (spacing/100|200|250|500, nested PaginationItem/Button tokens). React mapping: Pagination(position, size, pageItems, previousAction?, nextAction?).

### Variants

- **position:** start | middle | end
- **size:** lg | sm

### Props

| Prop | Tipo / valores |
|---|---|
| `position` | start \| middle \| end |
| `size` | lg \| sm |

### Rules

- **composition:** Composes PaginationItem (pageItem*) plus previousAction/nextAction Button text icon-only size=sm
- **positionActions:** start: previous disabled; middle: both enabled; end: next disabled
- **usage:** Do not use as tabs, breadcrumbs, stepper, carousel navigation, menu or button group

### Token rules

- `spacing/100` | `200` | `250` | `500` for gaps and action sizes
- Nested PaginationItem and Button use their own DS tokens

### Accessibility

Wrapper as nav with aria-label=Pagination; active page aria-current=page; previous/next need aria-label and disabled when unavailable.

---

## PaginationItem

**Node ID:** `3382:9339`

AI-READY COMPONENT: PaginationItem is an interactive pagination control item used to represent a page number or overflow indicator inside Pagination. Use content=number for visible page numbers and content=overflow for collapsed page ranges (dots-outline). Use selected=true only for the current active page. Use state=default, hover, focus or disabled to represent interaction state — there is no pressed state. selected=true is intentional-sparse with focus and disabled: those combinations are not published; keyboard focus on the current page uses selected=true with default/hover visuals, and the current page is never disabled. Do not use PaginationItem as a Button, NavigationItem, Chip, Badge, Tab, MenuItem or standalone icon action. Accessibility: number items should expose the page number as the accessible name, selected items should map to aria-current=page, overflow items should be hidden from assistive technology when decorative or given a clear label when interactive, and all interactive items must preserve keyboard focus. Token rule: use existing DS variables only (color/actions/primary for selected, interactive/hover|focus|disabled-surface, text/primary|on-color|placeholder, spacing/050|500, border/radius/full). React mapping: PaginationItem(label, icon, content, state, selected).

### Variants

- **content:** number | overflow
- **state:** default | hover | focus | disabled
- **selected:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `label` | page number text (content=number) |
| `icon` | local DS icon swap (content=overflow, typically dots-outline) |
| `content` | number \| overflow |
| `state` | default \| hover \| focus \| disabled |
| `selected` | false \| true |

### Rules

- **icons:** overflow icon must use local DS outline icons only (dots-outline)
- **noPressed:** No pressed interaction state — use default|hover|focus|disabled only
- **sparseSelected:** selected=true × focus and selected=true × disabled are intentionally omitted
- **usage:** Use inside Pagination; not as Button, NavigationItem, Chip, Badge, Tab or MenuItem

### Token rules

- `color/actions/primary` for selected fill
- `interactive/hover` | `focus` | `disabled-surface` for interaction states
- `text/primary` | `text/on-color` | `text/placeholder` for labels/icons
- `spacing/0` | `050` | `500` and `border/radius/full`

### Accessibility

Number items expose page number as accessible name; selected maps to aria-current=page; overflow decorative or clearly labeled; preserve keyboard focus.

---

## NavigationRailExpanded

**Node ID:** `3327:4894`

AI-READY COMPONENT: NavigationRailExpanded is a persistent or collapsible expanded side navigation container used on tablet, desktop or wide layouts to provide access to primary app destinations, nested navigation trees and key app actions. It composes NavigationRailExpandedItem and NavigationRailExpandedTree. Use appearance=default on light surfaces and appearance=inverse on inverse or dark navigation surfaces. Use alignment=top when destinations should start near the top of the rail and alignment=middle when destinations should be vertically centered. Use itemCount to control the number of primary visible destinations. Use showMenu and showButton to toggle menuAction (Button text) and primaryAction (Button solid). Use showTree01 through showTree05 only with alignment=top to reveal nested NavigationRailExpandedTree groups — alignment=middle is peer destinations only and does not include tree slots. itemCount=6 introduces section01 and section02 groupings with section labels. Nested item/tree appearance must match the rail appearance. Do not use NavigationRailExpanded as a drawer, bottom navigation bar, tab list, toolbar, modal, page content container or generic sidebar. Accessibility: implement as a nav region; each item represents a route or destination; selected items should map to aria-current=page; trees must preserve hierarchy; menuAction and primaryAction need accessible names; preserve visible focus and keyboard navigation. Token rule: use existing DS variables only (color/background-surface/0 | inverse-3, spacing/050|100|250|600|1000, nested NavigationRailExpandedItem/Tree/Button/logo tokens). React mapping: NavigationRailExpanded(appearance, alignment, itemCount, showMenu, showButton, showTree01?, showTree02?, showTree03?, showTree04?, showTree05?, items, trees?, menuAction?, primaryAction?, logo?).

### Variants

- **appearance:** default | inverse
- **alignment:** top | middle
- **itemCount:** 3 | 4 | 5 | 6

### Props

| Prop | Tipo / valores |
|---|---|
| `showMenu` | boolean — toggles menuAction visibility |
| `showButton` | boolean — toggles primaryAction visibility |
| `showTree01` | boolean — toggles tree slot 01 (alignment=top only) |
| `showTree02` | boolean — toggles tree slot 02 (alignment=top only) |
| `showTree03` | boolean — toggles tree slot 03 (alignment=top only) |
| `showTree04` | boolean — toggles tree slot 04 (alignment=top only) |
| `showTree05` | boolean — toggles tree slot 05 (alignment=top only) |
| `appearance` | default \| inverse |
| `alignment` | top \| middle |
| `itemCount` | 3 \| 4 \| 5 \| 6 |

### Rules

- **composition:** Composes NavigationRailExpandedItem and NavigationRailExpandedTree; railActions = menuAction + primaryAction; logo slot
- **treesTopOnly:** showTree01–05 apply only to alignment=top; alignment=middle is peer destinations without tree slots
- **itemCount6:** itemCount=6 uses section01 and section02 groupings with section labels
- **appearanceMatch:** Nested item/tree appearance must match rail appearance
- **usage:** Do not use as drawer, bottom navigation bar, tab list, toolbar, modal or page content container

### Token rules

- `color/background-surface/0` for default rail surface
- `color/background-surface/inverse-3` for inverse rail surface
- `spacing/050` | `100` | `250` | `600` | `1000` for rail paddings/gaps/action sizes
- Nested NavigationRailExpandedItem, NavigationRailExpandedTree, Button and logo use their own DS tokens

### Accessibility

Implement as a nav region; selected items map to aria-current=page; trees preserve hierarchy; menuAction and primaryAction need accessible names; preserve visible focus and keyboard navigation.

---

## NavigationRailExpandedTree

**Node ID:** `3327:6048`

AI-READY COMPONENT: NavigationRailExpandedTree is a grouped navigation tree used inside NavigationRail expanded layouts to display a set of related navigation destinations. It composes NavigationRailExpandedItem instances and controls which item is active through selectedItem. Use level=default for a flat group of four peer destinations (selectedItem=none|item-01|item-02|item-03|item-04). Use level=second-level for a nested group: a parent NavigationRailExpandedItem (hierarchy=nav-tree) that stays selected=true as the expanded group header, plus a navTree of three child items; selectedItem=none|item-01|item-02|item-03 maps to the active child — selectedItem=item-04 is intentionally unavailable at second-level (sparse matrix). Use appearance=default on light surfaces and appearance=inverse on inverse or dark navigation rail surfaces. Nested item appearance must match the tree appearance. Do not use NavigationRailExpandedTree as a standalone sidebar, drawer, menu, tab list, accordion, list item, button group or generic content container. Accessibility: implement inside a nav region, preserve logical keyboard order, map the active destination to aria-current=page, and ensure level=second-level reflects both visual and semantic hierarchy (parent group + nested children). Token rule: use existing DS variables only (color/background-surface/2 | inverse-1, color/border/2, spacing/0|100|300|600, border/radius/050, nested NavigationRailExpandedItem tokens). React mapping: NavigationRailExpandedTree(appearance, level, selectedItem, items, parentItem?).

### Variants

- **selectedItem:** none | item-01 | item-02 | item-03 | item-04
- **level:** default | second-level
- **appearance:** default | inverse

### Props

| Prop | Tipo / valores |
|---|---|
| `selectedItem` | none \| item-01 \| item-02 \| item-03 \| item-04 (item-04 only at level=default) |
| `level` | default \| second-level |
| `appearance` | default \| inverse |

### Rules

- **composition:** Composes NavigationRailExpandedItem; chrome layers treeRail + marker; second-level adds navTree of child items
- **secondLevel:** Parent item uses hierarchy=nav-tree and stays selected=true as group header; selectedItem controls which of the three nested children is active
- **sparseMatrix:** selectedItem=item-04 × level=second-level is intentionally omitted (only three nested children)
- **appearanceMatch:** Nested NavigationRailExpandedItem appearance must match tree appearance
- **usage:** Do not use as standalone sidebar, drawer, menu, tab list, accordion or content container

### Token rules

- `color/background-surface/2` for marker/surface accents on default
- `color/background-surface/inverse-1` where used on inverse chrome
- `color/border/2` for treeRail line
- `spacing/0` | `100` | `300` | `600` and `border/radius/050` for tree chrome
- Nested NavigationRailExpandedItem uses its own DS tokens

### Accessibility

Implement inside a nav region; map active destination to aria-current=page; second-level must reflect parent group + nested children hierarchy; preserve keyboard order.

---

## NavigationRailExpandedItem

**Node ID:** `3327:5795`

AI-READY COMPONENT: NavigationRailExpandedItem is an interactive horizontal navigation item used inside NavigationRail expanded layouts to represent a primary or nested app destination. Use selected=true for the current active destination. Use appearance=default on light surfaces and appearance=inverse on inverse or dark navigation surfaces. Use badge=dot for activity indication and badge=count for numeric notification count. When badge=count, edit the nested Badge count (and overflowLabel when needed); keep Badge size/content as designed by the variant. Use hierarchy=nav-tree only when the item belongs to an expanded navigation tree or nested destination group. hierarchy=nav-tree is an intentional sparse axis: only resting selected variants are published (state=default, selected=true × appearance × badge); interaction states for nested tree items reuse hierarchy=default or product-level overrides — do not expect a full nav-tree state matrix. Do not use NavigationRailExpandedItem as a Button, NavigationBarItem, NavigationRailCompactItem, Chip, Badge, ListItem, MenuItem, Tab or Accordion trigger. Accessibility: implement as link or button depending on navigation behavior; use aria-current=page when selected=true and the item represents the current route; preserve visible focus and keyboard navigation; hide decorative icons from assistive technology when a visible label exists; expose an accessible label for badges when they communicate important notifications. Colors follow the intentional expanded-rail model (selected/actions and tangerine badge accents). Token rule: use existing DS variables only (interactive/*, text/*, color/actions/*, color/palette/tangerine-1, spacing/*, border/*). React mapping: NavigationRailExpandedItem(icon, label, appearance, state, hierarchy, badge, selected, count?).

### Variants

- **appearance:** default | inverse
- **state:** default | hover | focus | pressed
- **hierarchy:** default | nav-tree
- **badge:** none | count | dot
- **selected:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `icon` | local DS icon swap |
| `label` | visible item label |
| `appearance` | default \| inverse |
| `state` | default \| hover \| focus \| pressed |
| `hierarchy` | default \| nav-tree |
| `badge` | none \| count \| dot |
| `selected` | false \| true |
| `count` | nested Badge TEXT when badge=count (exposed instance) |
| `overflowLabel` | nested Badge TEXT when badge=count (exposed instance) |

### Rules

- **icons:** icon must use local DS outline icons only; no remote/external icon libraries
- **badge:** badge mode is a variant (none|count|dot); count/overflowLabel come from exposed nested Badge — do not change Badge size/content away from the variant
- **hierarchyNavTree:** hierarchy=nav-tree is intentional sparse: only state=default + selected=true × appearance × badge (6 variants); full interaction matrix applies to hierarchy=default
- **colors:** intentional color model: color/actions/primary|tertiary for selected/accent, color/palette/tangerine-1 for badge accent; do not remap as feedback tokens
- **usage:** Use inside NavigationRail expanded layouts; not as Button, NavigationBarItem, NavigationRailCompactItem, Chip, Badge, Tab or ListItem

### Token rules

- `text/primary` | `text/secondary` | `text/on-color-disabled` for labels/icons by appearance/selected
- `interactive/hover` | `focus` | `pressed` | `selected` for interaction fills/strokes
- `color/background-surface/2` where used as surface
- `color/actions/primary` | `color/actions/tertiary` for selected/accent affordances (intentional)
- `color/palette/tangerine-1` for badge accent (intentional)
- `spacing/0` | `150` | `200` | `600` and `border/radius/0` | `300` | `full`

### Accessibility

Link or button depending on navigation behavior; selected=true maps to aria-current=page for routes; decorative icons aria-hidden when label visible; badge count needs accessible notification label when meaningful.

---

## NavigationRailCompact

**Node ID:** `3327:5125`

AI-READY COMPONENT: NavigationRailCompact is a compact side navigation container used on tablet, desktop or wider layouts to provide access to three to six primary app destinations. It composes NavigationRailCompactItem for each destination and may include an optional menu action and primary action button. Use appearance=default on light surfaces and appearance=inverse on inverse or dark navigation surfaces. Use alignment=top when destinations should start near the top of the rail and alignment=middle when destinations should be vertically centered. Use itemCount=3, 4, 5 or 6 to control the number of destinations. Use showMenu and showButton to toggle menuAction (Button text/lg) and primaryAction (Button solid/md). NavigationRailCompactItem appearance must match the rail appearance. Do not use NavigationRailCompact as a drawer, sidebar menu, bottom navigation bar, toolbar, tab list, content container or generic action group. Accessibility: implement with nav semantics, map selected destination to aria-current=page, provide aria-label for menuAction and primaryAction, preserve visible focus and keyboard navigation, and mark decorative icons as aria-hidden when labels are visible. Token rule: use existing DS variables only (color/background-surface/0 | inverse-3, spacing/1000 paddings, spacing/600 action sizes, nested NavigationRailCompactItem/Button/logo tokens). React mapping: NavigationRailCompact(appearance, alignment, itemCount, showMenu, showButton, items, menuAction?, primaryAction?, logo?).

### Variants

- **appearance:** default | inverse
- **alignment:** top | middle
- **itemCount:** 3 | 4 | 5 | 6

### Props

| Prop | Tipo / valores |
|---|---|
| `showMenu` | boolean — toggles menuAction visibility |
| `showButton` | boolean — toggles primaryAction visibility |
| `appearance` | default \| inverse |
| `alignment` | top \| middle |
| `itemCount` | 3 \| 4 \| 5 \| 6 |

### Rules

- **composition:** Composes NavigationRailCompactItem in navItems; railActions = menuAction (Button text/lg) + primaryAction (Button solid/md); logo slot at bottom
- **appearanceMatch:** Nested NavigationRailCompactItem appearance must match rail appearance
- **usage:** Do not use as drawer, sidebar menu, bottom navigation bar, toolbar, tab list or content container

### Token rules

- `color/background-surface/0` for default rail surface
- `color/background-surface/inverse-3` for inverse rail surface
- `spacing/1000` for vertical paddings; `spacing/600` for menu/primary action sizes
- Nested NavigationRailCompactItem, Button and logo use their own DS tokens

### Accessibility

Use nav semantics; selected destination maps to aria-current=page; aria-label for menuAction and primaryAction; decorative icons aria-hidden when labels visible; preserve visible focus and keyboard navigation.

---

## NavigationRailCompactItem

**Node ID:** `3327:5296`

AI-READY COMPONENT: NavigationRailCompactItem is an interactive compact navigation item used inside NavigationRail compact layouts to represent a primary app destination. Use selected=true for the current active destination. Use appearance=default on light surfaces and appearance=inverse on inverse or dark navigation surfaces. Use badge=dot for an unread/activity indicator and badge=count for a numeric notification count. When badge=count, edit the nested Badge count (and overflowLabel when needed); keep Badge size/content as designed by the variant. Use showLabel=false only when the compact navigation rail supports icon-only items. Colors follow the intentional compact-rail model (selected/actions and tangerine badge accents). Do not use NavigationRailCompactItem as a Button, NavigationBarItem, Chip, Badge, ListItem, MenuItem, Tab, Accordion trigger or generic icon action. Accessibility: implement as a link when it represents a route, map selected=true to aria-current=page, preserve visible focus, support keyboard navigation, set aria-label when showLabel=false, and expose badge count with an accessible label when it communicates important notification information. Token rule: use existing DS variables only (interactive/*, text/*, color/actions/*, color/palette/tangerine-1, spacing/*, border/*). React mapping: NavigationRailCompactItem(icon, label, appearance, state, badge, selected, showLabel, count?).

### Variants

- **appearance:** default | inverse
- **state:** default | hover | focus | pressed
- **badge:** none | count | dot
- **selected:** false | true
- **showLabel:** true | false

### Props

| Prop | Tipo / valores |
|---|---|
| `icon` | local DS icon swap |
| `label` | visible item label |
| `appearance` | default \| inverse |
| `state` | default \| hover \| focus \| pressed |
| `badge` | none \| count \| dot |
| `selected` | false \| true |
| `showLabel` | true \| false |
| `count` | nested Badge TEXT when badge=count (exposed instance) |
| `overflowLabel` | nested Badge TEXT when badge=count (exposed instance) |

### Rules

- **icons:** icon must use local DS outline icons only; no remote/external icon libraries
- **badge:** badge mode is a variant (none|count|dot); count/overflowLabel come from exposed nested Badge — do not change Badge size/content away from the variant
- **colors:** intentional color model: color/actions/primary|tertiary for selected/accent, color/palette/tangerine-1 for badge accent; do not remap as feedback tokens
- **usage:** Use inside NavigationRail compact layouts; not as Button, NavigationBarItem, Chip, Badge, Tab or ListItem

### Token rules

- `text/primary` | `text/secondary` | `text/on-color` | `text/on-color-disabled` for labels/icons by appearance/selected
- `interactive/hover` | `focus` | `pressed` | `selected` for interaction fills/strokes
- `color/background-surface/2` where used as surface
- `color/actions/primary` | `color/actions/tertiary` for selected/accent affordances (intentional)
- `color/palette/tangerine-1` for badge accent (intentional)
- `spacing/0` | `050` | `100` | `200` | `250` | `800` and `border/radius/0` | `300` | `400` | `full`

### Accessibility

Link for routes; selected=true maps to aria-current=page; icon-only requires aria-label; badge count needs accessible notification label when meaningful.

---

## NavigationBar

**Node ID:** `3653:14851`

AI-READY COMPONENT: NavigationBar is a bottom navigation container used in mobile layouts to provide access to primary app destinations. Props: itemCount=3|4|5; appearance=default|inverse; layout=flush|floating. Intentional full matrix 12/12 (itemCount × appearance × layout). Use itemCount=3 or 4 for bars composed only of NavigationBarItem destinations. Use itemCount=5 for four NavigationBarItem destinations plus a centered primaryIconButtonSlot for the primary action — itemCount=5 is not five equal nav destinations. Use appearance=default on light surfaces and appearance=inverse on inverse or dark surfaces. Use layout=flush for edge-to-edge bars (border/radius/0, no elevation). Use layout=floating for the pill bottom bar (border/radius/full + soft DROP_SHADOW y=8 blur=24 a=0.16 — manual elevation, not a bound color/elevation/* token). NavigationBar composes NavigationBarItem for each destination; item appearance must match the bar appearance. Do not use NavigationBar as a tab bar, toolbar, bottom sheet, action bar, drawer, menu, generic footer or content container. PRIMARY ACTION (itemCount=5 only — NavigationBar-local overrides on nested Button; do NOT change the Button component master for this pattern): nest local Button variant=solid size=lg intent=primary as primaryIconButton (exposed). NavigationBar-specific instance overrides: FIXED square spacing/700×spacing/700 (56); border/radius/full (circular FAB); padding spacing/400 horizontal + spacing/200 vertical; itemSpacing spacing/200; showLabel=false; showIcon=true; default icon plus-outline; icon stroke text/on-color. Fill keeps component/button/container/background (primary) on both appearance=default and appearance=inverse. Slot primaryIconButtonSlot uses height spacing/600 and paddingBottom spacing/050. This circular FAB chrome is exclusive to NavigationBar itemCount=5 — other surfaces must use standard Button sizes/radii. Accessibility: implement with nav semantics; each item should represent a route or primary destination; selected item should map to aria-current=page; icons may be aria-hidden when labels are visible; the primary action button needs its own accessible name (e.g. Acionar); preserve visible focus and keyboard navigation. Token rule: color/background-surface/0 | inverse-3; spacing/800 height; spacing/0 root pads/gaps; nested NavigationBarItem tokens; FAB overrides as above. PAINEL HOME: layout=floating + itemCount=5 (four destinations + Acionar primary). Horizontal inset margins around the pill are a screen composition pattern, not part of this component. React mapping: NavigationBar(appearance, itemCount, layout, items, primaryAction?). Code Connect is not configured.

### Variants

- **itemCount:** 3 | 4 | 5
- **appearance:** default | inverse
- **layout:** flush | floating

### Props

| Prop | Tipo / valores |
|---|---|
| `itemCount` | 3 \| 4 \| 5 — 5 = four items + primary slot |
| `appearance` | default \| inverse |
| `layout` | flush \| floating |

### Rules

- **matrix:** Published 12/12 — itemCount × appearance × layout
- **composition:** Composes NavigationBarItem; item appearance must match bar appearance
- **itemCount5:** itemCount=5 = navItem01 + navItem02 + primaryIconButtonSlot (Button) + navItem04 + navItem05 — four destinations plus centered primary action, not five equal items
- **primaryFabLocalOnly:** Circular FAB overrides apply only inside NavigationBar — do **not** change the Button master
- **primaryFabSpec:** Button `solid/lg/primary`; FIXED `spacing/700×700`; `border/radius/full`; pad `400/200`; gap `200`; `showLabel=false` `showIcon=true`; icon `plus-outline` stroke `text/on-color`; fill `component/button/container/background` on default and inverse
- **floatingChrome:** layout=floating: border/radius/full + soft DROP_SHADOW (y=8, blur=24, a=0.16) — manual, not bound elevation token
- **flushChrome:** layout=flush: border/radius/0; no elevation
- **screenInset:** Horizontal inset around floating pill is screen composition — not this component
- **painelHome:** PAINEL HOME: layout=floating + itemCount=5 (Acionar primary)
- **usage:** Do not use as tab bar, toolbar, bottom sheet, action bar, drawer, menu, footer or content container

### Token rules

- `color/background-surface/0` for default bar surface
- `color/background-surface/inverse-3` for inverse bar surface
- `spacing/800` for bar height; `spacing/0` root paddings/gaps
- `border/radius/0` on flush; `border/radius/full` on floating
- floating shadow: manual DROP_SHADOW y=8 blur=24 a=0.16
- FAB (NavigationBar-local): `spacing/700×700`; `border/radius/full`; pad `spacing/400|200`; gap `spacing/200`; icon stroke `text/on-color`; fill `component/button/container/background`
- `primaryIconButtonSlot`: height `spacing/600`; `paddingBottom` `spacing/050`

### Accessibility

Use nav semantics; items as routes with aria-current=page when selected; icons may be aria-hidden when labels are visible; primary action button needs its own accessible name; preserve visible focus and keyboard navigation.

### Composition

- navItem01..N (NavigationBarItem, exposed)
- primaryIconButtonSlot → primaryIconButton (Button solid/lg with NavigationBar-local circular FAB overrides; itemCount=5 only)

---

## NavigationBarItem

**Node ID:** `3327:2878`

AI-READY COMPONENT: NavigationBarItem is an interactive vertical navigation item used inside NavigationBar or navigation rail surfaces to represent a primary app destination. Use selected=true for the current active destination. Use appearance=default on light surfaces and appearance=inverse on inverse or dark navigation surfaces. Use badge=dot for unread/activity indicators and badge=count for numeric notification counts. When badge=count, edit the nested Badge count (and overflowLabel when needed); keep Badge size/content as designed by the variant. Use showLabel=false only when the navigation pattern supports icon-only items. Colors follow the intentional NavigationBarItem model (selected/actions and tangerine badge accents). Do not use NavigationBarItem as a Button, Chip, Badge, ListItem, MenuItem, Tab, Accordion trigger or generic icon action. Accessibility: use link semantics for routes or button semantics for actions; selected=true maps to aria-current=page when route-based; icon-only items require aria-label; badge count requires an accessible notification label when meaningful. React mapping: NavigationBarItem(icon, label, appearance, state, badge, selected, showLabel, count?).

### Variants

- **appearance:** default | inverse
- **state:** default | hover | focus | pressed
- **badge:** none | count | dot
- **selected:** false | true
- **showLabel:** true | false

### Props

| Prop | Tipo / valores |
|---|---|
| `icon` | local DS icon swap |
| `label` | visible item label |
| `appearance` | default \| inverse |
| `state` | default \| hover \| focus \| pressed |
| `badge` | none \| count \| dot |
| `selected` | false \| true |
| `showLabel` | true \| false |
| `count` | nested Badge TEXT when badge=count (exposed instance) |
| `overflowLabel` | nested Badge TEXT when badge=count (exposed instance) |

### Rules

- **icons:** icon must use local DS outline icons only; no remote/external icon libraries
- **badge:** badge mode is a variant (none|count|dot); count/overflowLabel come from exposed nested Badge — do not change Badge size/content away from the variant
- **colors:** intentional color model: color/actions/primary|tertiary for selected/accent, color/palette/tangerine-1 for badge accent; do not remap as feedback tokens
- **usage:** Use inside NavigationBar or navigation rail; not as Button, Chip, Badge, Tab or ListItem

### Token rules

- `text/primary` | `text/secondary` | `text/on-color` | `text/on-color-disabled` for labels/icons by appearance/selected
- `color/actions/primary` | `color/actions/tertiary` for selected/accent affordances (intentional)
- `color/palette/tangerine-1` for badge accent (intentional)
- `interactive/focus` for focus ring
- `spacing/0` | `050` | `100` | `200` | `250` | `800` and `border/radius/0` | `300` | `400` | `full`
- `border/width/012` | `025` where used

### Accessibility

Link for routes or button for actions; selected=true maps to aria-current=page when route-based; icon-only requires aria-label; badge count needs accessible notification label when meaningful.

---

## NavigationDrawerItem

**Node ID:** `3327:1178`

AI-READY COMPONENT: NavigationDrawerItem is an interactive navigation item used inside NavigationDrawer or navigation surfaces to represent a destination, section or route. Use selected=true for the current active destination. Use appearance=default on light surfaces and appearance=inverse on inverse or dark navigation surfaces. Use state=default, hover, focus and pressed to represent interaction states. Use showBadge=true and badgeLabel to show an optional numeric/status count; badge is controlled by props, not by variants. The leadingIcon must come from the local DS icon library. Do not use NavigationDrawerItem as Button, Chip, Badge, ListItem, MenuItem, Accordion trigger or generic content row. Accessibility: behave as a link for routes or a button for in-place navigation; expose visible focus; map selected=true to aria-current=page or aria-selected=true depending on navigation pattern; badge counts need accessible labels when meaningful. React mapping: NavigationDrawerItem(label, leadingIcon, showLeadingIcon, showBadge, badgeLabel, appearance, state, selected).

### Variants

- **appearance:** default | inverse
- **state:** default | hover | focus | pressed
- **selected:** false | true

### Props

| Prop | Tipo / valores |
|---|---|
| `leadingIcon` | local DS icon swap |
| `showLeadingIcon` | boolean |
| `showBadge` | boolean |
| `badgeLabel` | optional badge text/count |
| `label` | visible item label |
| `appearance` | default \| inverse |
| `state` | default \| hover \| focus \| pressed |
| `selected` | false \| true |

### Rules

- **icons:** leadingIcon must use local DS outline icons only; no remote/external icon libraries
- **badge:** badge visibility and label are props (showBadge, badgeLabel), not variants
- **usage:** Use inside NavigationDrawer or navigation surfaces; not as Button, Chip, Badge or ListItem

### Token rules

- `text/primary` for default label
- `text/secondary` for muted/badge on default surfaces
- `text/on-color-disabled` for muted content on inverse surfaces
- `interactive/hover` | `focus` | `pressed` | `selected` for interaction fills
- `color/actions/tertiary` for selected/accent affordances
- `color/background-surface/2` where used as surface
- `spacing/100` | `150` | `200` | `600` and `border/radius/200` | `400`

### Accessibility

Link for routes or button for in-place navigation; visible focus; selected=true maps to aria-current=page or aria-selected=true; badge counts need accessible labels when meaningful.

---

## NavigationDrawer

**Node ID:** `3327:1091`

AI-READY COMPONENT: NavigationDrawer is a vertical navigation container used to expose primary and secondary destinations in app, dashboard or system layouts. Use appearance=default on light surfaces and appearance=inverse on inverse or dark navigation surfaces. Use itemCount=3, 4, 5 or 6 to control the number of visible primary navigation items. itemCount=6 is the layout that also includes a secondary section separated by DividerHorizontal (primary + secondary items). NavigationDrawer composes NavigationDrawerItem for each destination. Do not use NavigationDrawer as a modal, side sheet, generic card, list, menu popover, content container or page layout wrapper. Accessibility: use nav semantics or aria-label for primary navigation; each item should behave as a link when representing a route; selected/current items should map to aria-current=page; preserve visible focus and keyboard navigation; badge counts need accessible labels when they communicate important information. Token rule: use existing DS variables only. React mapping: NavigationDrawer(heading, appearance, itemCount, items, secondaryItems).

### Variants

- **appearance:** default | inverse
- **itemCount:** 3 | 4 | 5 | 6

### Props

| Prop | Tipo / valores |
|---|---|
| `heading` | section/navigation heading text |
| `appearance` | default \| inverse |
| `itemCount` | 3 \| 4 \| 5 \| 6 |

### Rules

- **composition:** Composes NavigationDrawerItem; item appearance must match drawer appearance
- **itemCount6:** itemCount=6 includes primarySection + DividerHorizontal (middle-inset) + secondarySection; total items exceed 6
- **usage:** Do not use as modal, side sheet, card, list, menu popover or page layout wrapper

### Token rules

- `color/background-surface/1` or `inverse-3` for drawer surface
- `text/primary` | `text/on-color` for heading
- `spacing/100` | `150` | `200` | `250` | `300` | `600`
- `border/radius/0` | `200` | `400` | `full`
- Nested NavigationDrawerItem and DividerHorizontal use their own DS tokens

### Accessibility

Use nav semantics or aria-label; items as links for routes; selected maps to aria-current=page; visible focus and keyboard navigation; badge counts need accessible labels when meaningful.

---

## QuickAccessTile

**Node ID:** `4203:447`

AI-READY COMPONENT: QuickAccessTile — compact mobile shortcut tile for home quick-access grids (pay bill, assist, insurance). Props: `state=default|pressed|disabled`; `label` (TEXT, default `Label`); `icon` (INSTANCE_SWAP — local outline; default `apps-outline`; preferredValues include apps/grid/category/squares/star/credit-card outlines). Composition: icon (24) + label (up to 2 lines, left-aligned). `state=pressed` adds absolute `stateLayer` with `interactive/pressed` over the surface. Tokens: `color/background-surface/2`; `border/radius/400`; `spacing/200` (vertical pad); `spacing/150` (horizontal pad); `spacing/050` (gap); size `spacing/1000`×`spacing/1100` (80×88); icon stroke `text/brand` (disabled: `text/placeholder`) on outline path — not fill; label `text/primary` + `caption/medium/medium` (disabled: `text/placeholder`). No hover/focus (intentional — mobile press model). Do not use as Button, Chip, marketing Card, or NavigationBarItem. Document group pattern "Acesso rÃ¡pido" as a screen composition of N tiles — not a separate published component set. React mapping: QuickAccessTile(icon, label, state, onPress). Code Connect is not configured.

### Variants

- **state:** default | pressed | disabled

### Props

| Prop | Tipo / valores |
|---|---|
| `state` | default \| pressed \| disabled |
| `label` | TEXT — default `Label`; `caption/medium/medium` + `text/primary` |
| `icon` | INSTANCE_SWAP — default `apps-outline`; stroke `text/brand` |

### Rules

- **matrix:** Published 3/3 — state
- **pressedOverlay:** `state=pressed` uses absolute `stateLayer` `interactive/pressed` over surface
- **noHoverFocus:** No hover/focus variants (intentional — mobile press model)
- **groupPattern:** Acesso rÃ¡pido grid is a screen composition of N tiles — not a separate set
- **demoSize:** FIXED 80×88 via `spacing/1000`×`spacing/1100`
- **typography:** `caption/medium/medium` (nearest local to former 10px remote)
- **labelAlign:** label textAlign LEFT (manual)
- **genericDefaults:** Default label `Label` + icon `apps-outline` (product copy/icons via props)
- **iconStroke:** Outline path uses stroke `text/brand` (not fill); disabled `text/placeholder`
- **iconLocal:** Default and preferredValues use local DS outline icons — no remotes

### Token rules

- `color/background-surface/2`
- `border/radius/400`
- `spacing/200` (vertical pad); `spacing/150` (horizontal pad); `spacing/050` (gap)
- `spacing/1000` × `spacing/1100` (size)
- `text/brand` (icon stroke; disabled `text/placeholder`)
- `text/primary` (label; disabled `text/placeholder`)
- `caption/medium/medium`
- `interactive/pressed` (pressed stateLayer)

### Accessibility

Expose as button; label is accessible name; disabled must not be focusable.

### Composition

- `stateLayer` (pressed only; absolute STRETCH)
- `icon` (INSTANCE_SWAP 24)
- `label` (TEXT; left-aligned)

---

## VehicleSummaryCard

**Node ID:** `3942:25249`

AI-READY COMPONENT: VehicleSummaryCard summarizes the insured vehicle on Home/Painel. Anatomy: vehicle icon, brand+model, nested ChipTag soft status (Ativo/Inativo), plate, coverages summary. Entire card is pressable to vehicle details. Use status=active|inactive. Nest ChipTag emphasis=soft intent=success for active. Tokens: color/background-surface/0, border/radius/400, elevation shadow. Do not use as generic Card, OfferProductCard, or ListItem. React mapping: VehicleSummaryCard(brand, model, plate, status, coverages, vehicleIcon, onPress).

### Variants

- **status:** active | inactive

### Props

| Prop | Tipo / valores |
|---|---|
| `brandModel` | TEXT — brand + model |
| `plate` | TEXT — license plate |
| `coverages` | TEXT — compact coverage list |
| `status` | active \| inactive |

### Token rules

- `color/background-surface/0`
- `border/radius/400`
- Nested ChipTag soft tokens for status
- `text/primary` | `text/secondary`

### Accessibility

Card behaves as a single button/link to vehicle details; status label must remain exposed.

---

## VehicleConfirmCard

**Node ID:** `4360:444`

AI-READY COMPONENT: VehicleConfirmCard — onboarding vehicle confirmation card in a compact sheet-style surface. Shows plate as the hero identifier plus brand/model under a brand topo bar with centered drag handle. Props: plate (TEXT, default "ABC1D23"); brandModel (TEXT, default "Brand Model"). Anatomy: topo (brand bar + handle) + text (plate + brandModel). Layout: vertical Auto Layout; demo width 342; height Hug (~105); clipsContent true. Tokens: color/background-surface/1; text/brand (topo); color/elevation/inverse-4 (handle); stroke color/elevation/disabled @ ~32% opacity (weight 2 inside); border/radius/400; text/primary + heading/h1/semi-bold (plate); text/secondary + body/medium/regular (brandModel). No vehicle illustration. Use to validate/confirm which vehicle is being onboarded. Do not use as VehicleSummaryCard, OfferProductCard, CardHorizontal, or Banner. Confirm CTA lives on the screen, not inside this card. React mapping: VehicleConfirmCard({ plate, brandModel }).

### Variants

_(none — single component)_

### Props

| Prop | Tipo / valores |
|---|---|
| `plate` | TEXT — vehicle plate / hero identifier (heading/h1/semi-bold + text/primary); master default `ABC1D23` |
| `brandModel` | TEXT — brand + model supporting line (body/medium/regular + text/secondary); master default `Brand Model` |

### Rules

- **job:** Onboarding vehicle validation/confirmation display — not Home status summary
- **ctaOutside:** Confirm CTA lives on the screen, not inside this card
- **plateHero:** Plate is the primary typographic hierarchy (heading/h1), brandModel is secondary
- **sheetTopo:** topo bar `text/brand` + centered handle (`color/elevation/inverse-4`, 43×4, radius/full)
- **noIllustration:** Illustration SLOT removed — use VehicleSummaryCard when vehicle art is required
- **vsVehicleSummaryCard:** Use VehicleSummaryCard for Home/Painel (status ChipTag + coverages + illustration)
- **vsOfferProductCard:** Use OfferProductCard for add-on offers with price + CTA
- **vsCardHorizontal:** Do not force CardHorizontal — does not match plate-hero anatomy
- **usage:** Do not use as VehicleSummaryCard, OfferProductCard, CardHorizontal, CardFilledItem alone, or Banner

### Token rules

- `color/background-surface/1`
- `text/brand` (topo); `color/elevation/inverse-4` (handle)
- `color/elevation/disabled` @ ~32% opacity (stroke 2 inside)
- `border/radius/400` (card); `border/radius/full` (handle)
- `spacing/200` (root pad bottom); `spacing/250` (text horizontal pad); `spacing/150|100` (topo vertical pad)
- `text/primary` (plate); `text/secondary` (brandModel)
- `heading/h1/semi-bold` (plate); `body/medium/regular` (brandModel)

### Accessibility

Present plate and brandModel as text. Handle is decorative. If the card is pressable, expose accessible name from plate + brandModel. Confirm action is a separate control on the screen.

---

## OfferProductCard

**Node ID:** `4227:418`

AI-READY COMPONENT: OfferProductCard — add-on product offer card for Home/Painel carousels. Props: state=default; title (TEXT, default "Title"); description (TEXT, default "Description"); price (TEXT, default "R$ 0,00"); pricePeriod (TEXT, default "/mÃªs"); icon (INSTANCE_SWAP — local outline; default package-outline; preferredValues include package/tag/gift/box/shopping-bag/apps outlines). Anatomy: iconContainer (icon) + text (title + description) + priceRow (price + pricePeriod) + cta (local Button solid/sm/primary, exposed; default label "Label"). Tokens: color/background-surface/2; color/background-surface/3 (iconContainer); border/radius/500; spacing/250 (pad); spacing/150 (root gap); spacing/100 (text gap); text/primary + text/secondary; body/medium/semi-bold (title); body/small/regular (description/period); heading/h3/semi-bold (price); icon stroke text/brand. Do not use as VehicleSummaryCard, Banner, CardStacked/Horizontal, or a carousel shell (carousel is a screen pattern). Accessibility: CTA is the primary action; title maps to accessible name for the offer. React mapping: OfferProductCard(icon, title, description, price, pricePeriod, ctaLabel, onAdd). Code Connect is not configured.

### Variants

- **state:** default

### Props

| Prop | Tipo / valores |
|---|---|
| `title` | TEXT — default `Title` |
| `description` | TEXT — default `Description` |
| `price` | TEXT — default `R$ 0,00` |
| `pricePeriod` | TEXT — default `/mÃªs` |
| `icon` | INSTANCE_SWAP — default `package-outline` |
| `cta` | Exposed Button solid/sm/primary — default label `Label` |
| `state` | default |

### Token rules

- `color/background-surface/2` (root)
- `color/background-surface/3` (iconContainer)
- `border/radius/500`
- `spacing/250` (pad); `spacing/150` (root gap); `spacing/100` (text gap)
- `text/primary` \| `text/secondary`; `text/brand` (icon stroke)
- Nested Button solid/sm/primary tokens

### Accessibility

CTA is the primary action; card title should map to accessible name for the offer.

---

## ReferralDiscountCard

**Node ID:** `3943:24343`

AI-READY COMPONENT: ReferralDiscountCard is the Home/Painel referral promo with a 10-step discount simulator (descontÃ´metro). Rule: 10 referrals = 100% discount (mensalidade zerada). Anatomy: promo surface (color/background-surface/promo-1|2|accent), title, description, simulator link, discrete 10-node track (completed/current/pending), discount summary, CTA Convidar via Button intent=secondary (color/actions/secondary). Variants: referralCount=0|2|10 (sparse exemplars; product may interpolate 0..10). Do NOT replace with ProgressBar, StepProgressIndicator, or StepperPrimary. React mapping: ReferralDiscountCard(title, description, referralCount, maxReferrals=10, discountPercent, discountAmount, interactive, onInvite, onOpenSimulator).

### Variants

- **referralCount:** 0 | 2 | 10

### Props

| Prop | Tipo / valores |
|---|---|
| `title` | TEXT |
| `description` | TEXT |
| `referralCount` | 0 \| 2 \| 10 (sparse; runtime 0..10) |

### Token rules

- `color/background-surface/promo-1` | `promo-2` | `promo-accent`
- `color/actions/primary` for track filled nodes
- `color/actions/secondary` for Convidar CTA
- Nested Button intent=secondary
- `text/primary` | `text/link` for simulator link

### Accessibility

Expose referral progress in text (e.g. 2 de 10 indicaÃ§Ãµes, 20% desconto); track nodes decorative when text equivalent exists; CTA and simulator link keyboard reachable.

---

## Painel Home — mapa de cobertura

| Elemento da tela | Componente DS | Notas |
|---|---|---|
| Status bar iOS | — | Sistema, fora do DS |
| Header OlÃ¡ + avatar + search/bell | `AppHeader` + `Avatar` | `hierarchy=global`; bell visÃ­vel; search opcional (`showFirstTrailingAction`) |
| Card veÃ­culo | `VehicleSummaryCard` | status soft via `ChipTag` |
| Adicionar veÃ­culo | `ChipClickable` | `intent=soft` + leading plus |
| Acesso rÃ¡pido tiles | `QuickAccessTile` | grupo = composiÃ§Ã£o de tela |
| TÃ­tulos de seÃ§Ã£o | `SectionHeader` | `showAction` para overflow / ver mais |
| Zere sua mensalidade | `ReferralDiscountCard` | descontÃ´metro prÃ³prio |
| Simulador de indicaÃ§Ã£o | `Link` (ou texto link no card) | nested / composed |
| Convidar | `Button` intent=secondary | color/actions/secondary |
| Ofertas cards | `OfferProductCard` | carrossel = padrÃ£o de tela |
| Adicionar ao plano | `Button` solid primary | nested |
| Bottom nav floating | `NavigationBar` | layout=floating; itemCount=5 + Acionar |

---

## Atualizações recentes

- **alert-fill-stack:** Alert: shell fill stack inverse-3 + brand overlay; icon 32 docs; AI-READY + storybook.
- **list-product-theme:** List: product-theme shell radius shared with ListActionDropdown; AI-READY + storybook.
- **list-action-dropdown-product-theme:** ListActionDropdown: product-theme shell radius for site-loovi|app-cliente; AI-READY + storybook.
- **radiobuttoncard-description:** RadioButtonCard: description helper text + showDescription; AI-READY + storybook.
- **radiobuttoncard-audit-apply:** RadioButtonCard: card/row radio; hover stateLayer; token binds; docs seeded.
- **app-header-pad-200:** AppHeader: lateral padding → spacing/200 across global|small|medium|large; docs synced.
- **product-theme-catalog:** product-theme docs: complete mode matrix for AppHeader (8), Button (6), ModalHeader (3), Input (1), InputTextArea (1). Switch mode to preview; no per-product component forks.
- **alert-overlay-token:** Alert: overlay paint → color/elevation/inverse-3 @ ~48% opacity; docs synced.
- **alert-audit-apply:** Alert: seed docs; icon *-path; clear icon fills; AI-READY + actionLabel; dark overlay characteristic; docs synced.
- **modal-audit-apply:** Modal audit apply: mobile-landscape docs; spacing/050 + sheetContent spacing/0 binds; elevation tokenRules; nested ModalHeader props; docs synced.
- **bottom-sheet-check-item-audit-apply:** BottomSheetCheckItem + ModalCheckItem audit apply: font-weight/semi-bold on emphasis; Modal SLOT preferredValues; docs synced.
- **bottom-sheet-check-item:** BottomSheetCheckItem: ModalCheckItem sibling for BottomSheet slot; preferredValues wired; docs synced.
- **bottom-sheet-header-layout-fix:** BottomSheetHeader layout fix: text/sm icon-only 40×40; leadingSlotKeeper; SPACE_BETWEEN; matches MENU sheet reference; docs synced.
- **modal-check-item-audit-apply:** ModalCheckItem audit apply: local body/medium typography (no remote Font/*); root Hug; outline *-path; EN demo emphasis; docs synced.
- **vehicle-confirm-card-audit-apply:** VehicleConfirmCard audit apply: vehicleArt/artwork naming; SLOT preferredValues vehicle-confirm-car; ABC1D23/Brand Model; docs synced.
- **feature-steps-item-audit-apply:** FeatureStepsItem audit apply: local preferred icons, *-path + stroke token, spacing/0|100, supportingText Hug, Label/Description master; docs synced.
- **feature-steps-visual-fix:** FeatureSteps: spacing/0 container; Item rhythm via spacing/300 content pad + connector stretch; docs synced.
- **feature-steps:** FeatureSteps + FeatureStepsItem: illustrative vertical steps (icon badge, soft connector); not VerticalStepper progress feedback; docs synced.
- **app-header-optical-center:** AppHeader: trailing slot stays when showSecondTrailingAction off; optical center fixed; docs synced.
- **app-header-trailing-layout:** AppHeader small/small-centered: fix leading recenter when trailing hidden; docs synced.
- **app-header-inverse-text:** AppHeader inverse: TextHeader title text/on-color; docs synced.
- **text-header-normalize:** TextHeader: kebab size/alignment; AppHeader nests TextHeader (non-global); global greeting body/large/medium characteristic; docs synced.
- **icon-libraries-swap:** Icon libs: Library Swap + *-outline/*-filled contract; EV Tabler / App Hugeicons aliases; foundations docs.
- **avatar-surface-3:** Avatar: default fill color/background-surface/3 for initials|placeholder all sizes; nodeId 3669:8605; docs synced.
- **card-stacked-tokens:** CardStacked: media FILL; radius/300 binds; Avatar initials local type; docs synced.
- **chip-clickable-label-tokens:** ChipClickable: soft label prop wired; local body/small/medium; danger gaps spacing/100; docs synced.
- **chip-clickable-soft:** ChipClickable intent=soft: soft surface chip matrix 16; docs synced.
- **navigation-bar-fab-local:** NavigationBar FAB: local circular Button overrides only in this component; docs synced.
- **navigation-bar-floating-docs:** NavigationBar: layout floating matrix 12/12; pill + soft shadow; nodeId 3653:14851; AI-READY + storybook.
- **app-header-global-icon-stroke:** AppHeader global trailing icons: stroke text/primary|on-color (manual); docs synced.
- **app-header-global-docs:** AppHeader global: Avatar+greeting; local Button/icons; bell visible / search hidden; inverse-3; AI-READY + storybook.
- **section-header-docs:** SectionHeader (4235:406): local Button text/sm; Title default; S2 tokens; AI-READY + storybook 2.
- **offer-product-card-docs:** OfferProductCard (4227:418): local Button sm; package-outline; generic defaults; S2 tokens; AI-READY + storybook 1.
- **dashboard-card-primary-apply:** DashboardCardPrimary: clear remotes; local type; chartTrack/Accent; inverse-4; docs synced.
- **dashboard-card-secondary-docs:** DashboardCardSecondary (4181:528): S2 surfaces; growth success|danger; type×growth 4; AI-READY + storybook.
- **dashboard-card-primary-docs:** DashboardCardPrimary (4181:493): rename + type web|mobile; local inverse tokens; AI-READY + storybook.
- **quick-access-tile-icon-brand:** QuickAccessTile icon: stroke text/brand (disabled text/placeholder); docs synced.
- **quick-access-tile-generic:** QuickAccessTile: generic defaults Label + apps-outline; docs synced.
- **quick-access-tile-label-left:** QuickAccessTile: label textAlign LEFT; docs synced.
- **quick-access-tile-docs:** QuickAccessTile (4203:447): S2 kebab tokens; local icon; caption/medium/medium; text/primary; storybook state×3.
- **card-stacked-docs:** CardStacked: S2 spacing; slot 100/200; media FILL; expose Avatar/actions; AI-READY + storybook 6.
- **card-horizontal-slot-pad:** CardHorizontal layout=slot: pad vertical spacing/100 + horizontal spacing/200; docs synced.
- **card-horizontal-docs:** CardHorizontal: drop slotSwap; slot + spacing/radius tokens; expose Avatar; media FILL; storybook 6.
- **card-elevated-filled-items-docs:** CardElevatedItem + CardFilledItem: S2 parity with CardOutlinedItem; AI-READY + storybook state×5.
- **card-outlined-pressed-sync:** CardOutlinedItem pressed: root interactive/pressed; stateLayer empty; docs synced.
- **card-outlined-item-docs:** CardOutlinedItem: focus ring default on; spacing/100; fill/elevation sync; AI-READY + storybook state×5.
- **carousel-shell-docs:** Carousel: showPaginationItem toggle; slot demos + ImageItem preferredValues; AI-READY + storybook sync.
- **carousel-pagination-gap-100:** CarouselPaginationItem dots gap → spacing/100 (8px); docs synced.
- **carousel-pagination-item-docs:** CarouselPaginationItem (ex-CarouselItem): local spacing; expose on Carousel; AI-READY + storybook sparse 14.
- **photo-text-item-docs:** PhotoTextItem + ImageItem showPhotoTextItem: full-bleed text scrim; S2 tokens; storybook entries.
- **slider-docs:** Slider + SliderBaseItem: AI-READY; feedback typography; spacing gaps; expose nested; Base TEXT props; storybook entries.
- **painel-home-gap-close:** Closed Painel Home gap — promo surface tokens; ChipTag emphasis=soft; ChipClickable Adicionar veÃ­culo exemplar; Button intent=secondary; AppHeader greeting; NavigationBar layout=floating; new QuickAccessTile, VehicleSummaryCard, OfferProductCard, ReferralDiscountCard.
- **input-focus-caret-error-icon-docs:** Input: added focus caret (Material pattern) and always-on trailingIconError (alert-circle) for error a11y; docs updated.
- **input-docs:** Added Input (outlined floating-label, h=56, radius/200) from Material Text field matrix + target visual identity; S2 tokens; AI-Ready and storybook docs.
- **input-removed-docs:** Removed Input component from Figma and cleared Input storybook/AI-Ready docs to restart from scratch.
- **pagination-select-menu-docs:** Added PaginationSelectMenu + PaginationSelectMenuItem (ListActionDropdown pattern); nested under PaginationSelectInput expanded; deprecated Carbon draft.
- **link-docs:** Link: modernized from Carbon to S2 — kebab props/variants, local tokens/typography/icons, AI-Ready and storybook docs.
- **tooltip-sync-docs:** Tooltip: synced AI-Ready/token rules to manual specs — border/width/012, arrow constraints horizontal, body/small/regular, elevation/spacing detail.
- **vertical-stepper-docs:** VerticalStepper: items SLOT for VerticalStepperItem; preferredValues; default completed/current/pending composition; AI-Ready and storybook added.
- **vertical-stepper-item-docs:** VerticalStepperItem: kept nested ListItem; exposed ListItem props; unified counter alignment; cleaned AI-Ready; storybook added.
- **step-progress-docs:** StepProgressIndicator: HUG root, spacing/050 track, AI-Ready cleaned; Segment documented as internal; storybook added.
- **modal-header-alignment-docs:** ModalHeader: alignment=start|center; centered title with leadingSpacer; docs updated.
- **modal-header-docs:** ModalHeader integrated into Modal; AppHeader removed from Modal; AI-Ready and storybook docs updated.
- **mobile-gesture-navigation-docs:** MobileGestureNavigation: INTERNAL AI-Ready; appearance default|inverse; Keyboard composition updated.
- **overlay-docs:** Overlay: type/platform kebab; slot composes Modal/BottomSheet; spacing bound; AI-Ready and storybook docs added.
- **keyboard-polish-docs:** Keyboard polish: remotes removed; radius/spacing bound; body text styles; local modifier icons; enter on-color; docs synced.
- **keyboard-docs:** Keyboard: Option A placement utility; configuration/layout kebab; Schemes remapped; Poppins + local icons; AI-Ready and storybook docs added.
- **breadcrumb-docs:** Breadcrumb: cleaned AI-Ready entities; hid currentItem slash; fixed leadingIcon 16px alignment; page renamed; storybook docs added.
- **list-manual-sync-docs:** List docs synced after manual edits: canonical nodeId 3745:10921; default type=dropdown documented.
- **list-docs:** List: type=plain|dropdown container with items SLOT for ListItem; showScroll; preferredValues ListItem+DividerHorizontal; AI-Ready and storybook docs added.
- **list-item-manual-sync-docs:** ListItem docs synced after manual refinements: Switch size=md; Checkbox/Radio control-only; icon defaults; contentRow layout; component defaults documented.
- **list-item-docs:** ListItem: replaced remote M3 building blocks/controls with local S2; Schemes/Static remapped; props camelCase; state via ListItemStateLayer; AI-Ready and storybook docs added.
- **breadcrumb-item-docs:** BreadcrumbItem: open overflow ListActionDropdown absolute overlay with content-hug width (manual demo); showDivider=false; Contente→Content; label wired; focus stroke documented; canonical AI-Ready and storybook docs added.
- **list-item-building-blocks-docs:** ListItem building blocks: focusRing STRETCH; ring-only focus; local pressedRipple; video FILL + playIcon; AI-Ready and storybook docs added.
- **icon-scale-docs:** Formalized icon size scale 80/64/40/32/24/20/16 with proportional stroke from master 24px + border/width/025; Scale/unbind rules and INSTANCE_SWAP caveat documented.
- **list-action-dropdown-docs:** ListActionDropdown: remapped Spacing/* to local spacing; wired showDivider/showScroll; added local scroll affordance; slot preferredValues; canonical AI-Ready and storybook docs added.
- **list-action-dropdown-item-no-country-docs:** ListActionDropdownItem: removed showCountry prop and countryFlag layer; docs updated.
- **list-action-dropdown-item-docs:** ListActionDropdownItem: fixed focusRing STRETCH; added state=focus; local icon preferredValues; canonical AI-Ready and storybook docs added.
- **image-block-docs:** ImageItem: restored verticalResize keepers from Aspect ratio base; local color/background-surface/1; kept imageSurface; canonical AI-Ready and storybook docs added.
- **chip-group-docs:** ChipGroup: recomposed nested chips on ChipClickable intent=outline size=sm; reset broken overrides; filter uses selected; AI-Ready and storybook docs added.
- **comment-block-docs:** CommentItem: remapped elevation/spacing tokens; local category icons; unified leadingIcon/showIcon; intentional generic vs categoryTag composition; AI-Ready and storybook docs added.
- **organization-header-docs:** OrganizationHeader: descriptionSlot FILL wrap; local ChipTag circle-check-outline; cleaned AI-Ready React mapping; storybook docs added.
- **file-uploader-skeleton-bones-docs:** FileUploader: restored uploadAction/uploadDropzone/fileList names and showFiles bind; skeleton bones-only (no nested components); docs updated.
- **file-uploader-docs:** FileUploader: Button size/icon/label aligned to matrix; skeleton cleaned; showFiles intentional on default-only; AI-Ready and storybook docs added.
- **upload-photos-docs:** UploadPhotos: local text styles; local chevron + visible Button labels; renamed camera path; intentional surface/1|2 by status; AI-Ready and storybook docs added.
- **file-uploader-list-docs:** FileUploaderList: recomposed on FileUploaderItem; showFileItem02–07; deprecated legacy file item set; AI-Ready and storybook docs added.
- **file-uploader-item-docs:** FileUploaderItem: removed orphan longFileName/showLongFileName; renamed layers; aligned danger-long text tokens; AI-Ready and storybook docs added.
- **file-uploader-block-docs:** FileUploaderDropzoneItem: unified focus padding; cleaned dropzone dash/root fills; documented stroke width tokens and dashPattern leftover; AI-Ready and storybook docs added.
- **tooltip-docs:** Tooltip: remapped Title Case elevation/spacing tokens; fixed bottom-center arrow constraint; AI-Ready (EN) and storybook docs added.
- **tooltip-rich-docs:** TooltipRich: remapped Title Case tokens; documented intentional secondaryAction text/on-color; unified layer order; AI-Ready and storybook docs added.
- **toast-docs:** Toast: published showAction and dismissible; split action/dismiss Buttons; unified statusIcon fills; AI-Ready and storybook docs added.
- **tabs-secondary-docs:** TabsSecondary: remapped Spacing/050|100|200 and Color/Content/Disabled; no appearance/inverse documented; AI-Ready and storybook docs added.
- **tabs-primary-docs:** TabsPrimary: remapped Spacing/200 and Color/Content/Disabled; intentional-sparse inverse×web documented; AI-Ready and storybook docs added.
- **tab-item-docs:** TabItem: selectedIcon→leadingIcon; intentional-sparse inverse documented; secondary selectedIndicator only when selected; Color/Content/Brand→text/brand; storybook docs added.
- **table-mobile-docs:** TableMobile: relinked orphan TableMobileCell instances; remapped Title Case tokens; intentional-sparse interactive×columnCount documented; storybook docs added.
- **table-mobile-cell-docs:** TableMobileCell: removed interactive axis; Instance→icon; Spacing/800→spacing/800; slot preferred chip clickable; storybook docs added.
- **table-expand-chevron-docs:** TableExpandCell: added intentional-sparse type=header showChevron=false spacer (56×40, no chevron); docs updated.
- **table-docs:** Table: renamed from Table Web; recomposed on TableRow; AI-Ready and storybook docs updated.
- **table-web-docs:** TableWeb: modernized props (columns, showHeader, rows slot with default body lines); AI-Ready description and storybook docs added.
- **table-skeleton-docs:** TableSkeleton: AI-Ready description cleaned (fixed density, empty false vs true, intentional leftover bodyRow07–10); storybook docs added.
- **table-row-expand-docs:** TableRow: added showExpandCell boolean with trailing TableExpandCell on all variants; AI-Ready description and storybook docs updated.
- **table-row-tokens-docs:** TableRow: repaired 60 detached TableCell instances; Border/Radius legacy remapped; row-level focus documented; storybook docs added.
- **table-cell-slot-docs:** TableCell: docs and AI-Ready description aligned to type=slot; spacing token rule refreshed to used tokens.
- **table-expand-cell-docs:** TableExpandCell: AI-Ready description cleaned (no size axis; selected=expanded with structural chevron-up); selected path layers renamed; storybook docs added.
- **table-cell-remove-show-action:** TableCell: removed showAction variant axis (kept non-action variants); AI-Ready description and storybook docs updated.
- **table-cell-tokens-docs:** TableCell: Spacing/800|100|500 remapped to kebab-case; AI-Ready description updated with sparse header and showAction variant axis; storybook docs added.
- **button-text-icon-docs:** Button: showIcon (leadingIcon) on variant=text + intent=primary (enabled) documented as text/primary across states; token rules clarified.
- **switch-tokens-docs:** Switch: Spacing/0 and Border/Radius/0 remapped; parent Loovi renamed to Switch; checked icon to color/actions/primary; showIcon documented as md-only; storybook docs added.
- **stepper-primary-tokens-docs:** StepperPrimary: inactive trails unified to color/border/2; AI-Ready description cleaned with React mapping, token rule and intentional sparse trailState matrix; storybook docs added.
- **radio-button-tokens-docs:** RadioButton: Border/Radius/0 remapped to border/radius/0; AI-Ready description cleaned with React mapping and token rule; storybook docs added.
- **progress-bar-docs:** ProgressBar: parent frame name trimmed; AI-Ready description cleaned; value-as-label vs layout-controlled fill documented; storybook docs added.
- **pagination-select-input-tokens-docs:** PaginationSelectInput: expanded border remapped from color/border-feedback/primary to interactive/focus; default|hover-only states documented; storybook docs added.
- **pagination-tokens-docs:** Pagination: Spacing/500 and Color/Content/Ghost remapped; size=lg prev/next disabled fixed by position; actions and pageItems exposed; parent page name trimmed; storybook docs added.
- **pagination-item-docs:** PaginationItem: removed pressed from documented states; intentional sparse selected×focus/disabled matrix documented; storybook docs added.
- **navigation-rail-expanded-tokens-docs:** NavigationRailExpanded: legacy Spacing/Border/Content tokens remapped; showMenu wired on all variants; nested trees exposed; Section 1/2 renamed to section01/02; top-only trees and itemCount=6 documented; storybook docs added.
- **navigation-rail-expanded-tree-tokens-docs:** NavigationRailExpandedTree: legacy Spacing/Color/Border tokens remapped; layers renamed (marker/navTree/treeRail); nested navItem01 exposed; second-level sparse selectedItem documented; storybook docs added.
- **navigation-rail-expanded-item-tokens-docs:** NavigationRailExpandedItem: hierarchy=nav-tree documented as intentional sparse axis; nested Badge exposed; storybook docs added with intentional color model.
- **navigation-rail-compact-tokens-docs:** NavigationRailCompact: Spacing/600, Spacing/1000 and Color/Content/Default Inverse remapped; parent frame typo fixed; storybook docs added.
- **navigation-rail-compact-item-tokens-docs:** NavigationRailCompactItem: Color/Interactive/* and Color/Background Surface/2 remapped; Label text renamed to label; nested Badge exposed; storybook docs added with intentional color model.
- **navigation-bar-tokens-docs:** NavigationBar: Spacing/700 remapped on FAB; itemCount=5 documented as 4 items + primaryIconButtonSlot; plus-outline Vector renamed; storybook docs added.
- **navigation-bar-item-tokens-docs:** NavigationBarItem: Spacing/800 and Color/Interactive/Focus remapped to kebab-case; nested Badge exposed for count/overflowLabel; storybook docs added with intentional color model.
- **navigation-drawer-docs:** NavigationDrawer storybook docs added; documents composition with NavigationDrawerItem/DividerHorizontal and itemCount=6 secondary section.
- **navigation-drawer-item-token-icons:** NavigationDrawerItem tokens kebab-case; remote info-circle-outline replaced with local DS icon; storybook docs added.
- **modal-token-fix:** Modal tokens kebab-case; storybook docs added. AppHeader internal layout left as designed (header override reverted).
- **appheader-icons-tokens:** AppHeader profileMenu Color/Border/2 remapped; Profile menu spacing/radius kebab-case; remote icons replaced with local DS outline icons.
- **divider-vertical-token-fix:** DividerVertical bindings migrated to color/border/2; storybook metadata added.
- **divider-horizontal-token-fix:** DividerHorizontal bindings migrated to color/border/2 and text/on-color-disabled; Text prop renamed to label.
- **feedback-usage-table:** Documented feedback token layers: content, bg-primary, bg-secondary, interactive/*-surface and border-feedback with unified vocabulary and decision guide.
- **ai-ready-descriptions:** 12 component descriptions aligned to current variables, semantic tokens, props and kebab-case variants.
- **banner-danger:** Banner supports status=danger with alert-circle-outline and color/background-feedback-primary/danger.
- **icon-vector-layers:** Icon source layers should use semantic path names such as check-outline-path instead of Vector.

## Changelog (meta)

- **2026-07-28** [storybook-alert-feedback-info]: Created feedback/info; Alert+Toast info icon → feedback/info; actionLabel remains nested Button.label.
- **2026-07-28** [storybook-alert-overlay-token]: Alert: overlay paint bound to `color/elevation/inverse-3` @ ~48% opacity (was unbound black); AI-READY + docs synced.
- **2026-07-28** [storybook-alert-audit-apply]: Alert (`4406:91`): seed docs; icon paths `*-path`; clear icon root fills; AI-READY icon-fill accuracy + actionLabel; dark overlay documented as characteristic; docs synced.
- **2026-07-28** [storybook-modal-audit-apply]: Modal audit apply: document platform `mobile-landscape`; bind itemSpacing `spacing/050` (mobile|landscape) + sheetContent `spacing/0`; AI-READY + ModalCheckItem preferredValues; elevation tokenRules; header props via nested ModalHeader; docs synced.
- **2026-07-28** [storybook-bottom-sheet-check-item-audit-apply]: BottomSheetCheckItem + ModalCheckItem audit apply: emphasis span binds `font-weight/semi-bold`; Modal AI-READY mentions sibling; Modal SLOT preferredValues→ModalCheckItem; docs synced.
- **2026-07-28** [storybook-bottom-sheet-check-item]: BottomSheetCheckItem (`4389:80`): ModalCheckItem sibling for BottomSheet slot/sheetContent; preferredValues on BottomSheet slot; docs synced.
- **2026-07-28** [storybook-bottom-sheet-header-layout-fix]: BottomSheetHeader layout fix: Button text/sm icon-only 40×40 (was md 208); leadingSlotKeeper + absolute actions; SPACE_BETWEEN; height 40; matches MENU sheet reference; docs synced.
- **2026-07-28** [storybook-modal-check-item-audit-apply]: ModalCheckItem audit apply: replace remote `Font/*` with local `body/medium` typography; root height Hug; `circle-check-outline-path` + `border/width/025`; generic EN demo with `text/brand` emphasis; icon FIXED 20; docs synced.
- **2026-07-28** [storybook-vehicle-confirm-card-audit-apply]: VehicleConfirmCard audit apply: rename `vehicleArt`/`artwork`; SLOT description + preferredValues `vehicle-confirm-car`; master demo `ABC1D23`/`Brand Model`; SLOT height Hug; product vectors documented as unbound exception; docs synced.
- **2026-07-28** [storybook-feature-steps-item-audit-apply]: FeatureStepsItem audit apply: preferredValues locais (square-check/car/trophy/camera/file/checkbox-outline); paths `*-path` + `border/width/025`; `spacing/0` columns; supportingText HEIGHT+Hug; connector `spacing/100`; master Label/Description; docs synced.
- **2026-07-28** [storybook-feature-steps-visual-fix]: FeatureSteps visual polish: container spacing/0; Item rhythm via spacing/300 + FILL connector; docs synced.
- **2026-07-28** [storybook-feature-steps]: FeatureSteps + FeatureStepsItem: illustrative sibling of VerticalStepper; docs synced.
- **2026-07-28** [storybook-app-header-title-theme-typo]: AppHeader title product-theme typography — `app-cliente`→`body/medium/regular` on `small|small-centered` × default × specific; UPPER via `text-transform` in impl; docs synced.
- **2026-07-28** [storybook-app-header-product-theme]: AppHeader product-theme tokens (5): `inverse/background`, `leading-action/background|radius`, `avatar/background|icon-color` — modes `escritorio-virtual`|`site-loovi`|`app-cliente`; docs synced.
- **2026-07-27** [storybook-app-header-audit-apply]: AppHeader audit apply: super-app anatomy fixed; spacing binds; legacy action removed; medium/large keepers; icon `*-path`; profileMenu=super-app only; docs synced.
- **2026-07-27** [storybook-bottom-sheet-header-audit-apply]: BottomSheetHeader audit apply: `body/medium/medium` + `text/primary`; AI-READY descriptions; icon `*-path` renames; `spacing/0` gap; Button instances refreshed; BottomSheet nest swapped; docs synced.
- **2026-07-27** [storybook-bottom-sheet-header-close-edge]: BottomSheetHeader: `headingContent` FILL — `showLabel` off / only close keeps X on the trailing edge; docs synced.
- **2026-07-27** [storybook-bottom-sheet-header-leading]: BottomSheetHeader: no inverse; leading `optionsAction` + `leadingAction`; `showLabel` toggles title; docs synced.
- **2026-07-27** [storybook-bottom-sheet-header]: BottomSheetHeader (`4307:3760`): dedicated sheet header (`appearance` default|inverse, `title`, `showCloseAction`); BottomSheet `header=app-header`→`sheet-header` nests BottomSheetHeader (not AppHeader); docs synced.
- **2026-07-27** [storybook-app-header-leading-optical-center]: AppHeader `small|small-centered` specific default|inverse: `leadingActions` FIXED 48 + `leadingSlotKeeper` — `showAction` off keeps optical center with trailing visible; docs synced.
- **2026-07-27** [storybook-app-header-textheader-small]: AppHeader specific `small|small-centered` default: `headingContent` = local TextHeader `size=small` (left|center), `showDescription=false`; docs synced.
- **2026-07-27** [storybook-background-surface-brand]: Tokens: `primitive-colors/brand-blue` (`#4967EE`) + `color/background-surface/brand` (`FRAME_FILL`|`SHAPE_FILL` alias); docs synced.
- **2026-07-27** [storybook-app-header-optical-center]: AppHeader small|small-centered: unbind `trailingActions.visible` from `showSecondTrailingAction`; fixed 48 slot + keeper — optical center holds when trailing off; docs synced.
- **2026-07-27** [storybook-app-header-trailing-layout]: AppHeader small|small-centered specific: `headingContent` in auto-layout (not absolute); `trailingActions` minWidth 48 — hiding trailing no longer recenters `leadingAction`; docs synced.
- **2026-07-27** [storybook-app-header-inverse-text]: AppHeader `appearance=inverse`: TextHeader title → `text/on-color` (overrides); docs synced.
- **2026-07-27** [storybook-text-header-normalize]: TextHeader (`3667:4129`): rename from Text header; kebab `size`/`alignment`; `title`/`description`/`showDescription`; AppHeader non-global → TextHeader; global greeting `body/large/medium` kept as characteristic; orphan set removed; AI-READY + storybook.
- **2026-07-27** [storybook-icon-libraries-swap]: Documented multi-product icon architecture — Library Swap + DS name contract (`*-outline`/`*-filled`); EV Tabler vs App Cliente Hugeicons + Semantic Aliases; alias publish rules; foundations/GlobalRules + storybook MD.
- **2026-07-27** [storybook-avatar-surface-3]: Avatar (`3669:8605`): default fill `color/background-surface/3` for initials|placeholder across all sizes; nodeId synced; AI-READY + storybook.
- **2026-07-27** [storybook-card-stacked-tokens]: CardStacked (`4170:4433`): mediaImage scaleMode FILL; corner radius binds `border/radius/300` (+ slotContent `200`); unify slot content clip; Avatar initials local type styles; dots-vertical-outline path rename; AI-READY + storybook.
- **2026-07-27** [storybook-chip-clickable-label-tokens]: ChipClickable (`3653:23577`): soft label TEXT prop re-wired (16); label typography local `body/small/medium` (cleared remotes on 116); danger itemSpacing→`spacing/100`; AI-READY + storybook.
- **2026-07-24** [storybook-chip-clickable-soft]: ChipClickable (`3653:23577`): new intent=soft (16 variants) — surface/2 + border/2; Painel Adicionar veÃ­culo; AI-READY + storybook.
- **2026-07-24** [storybook-navigation-bar-fab-local]: NavigationBar itemCount=5: document NavigationBar-local Button FAB overrides (circular lg 56, radius/full, plus-outline, text/on-color) — not Button master; AI-READY + docs.
- **2026-07-24** [storybook-navigation-bar-floating]: NavigationBar (`3653:14851`): full matrix layout flush|floating × itemCount 3|4|5 × appearance; floating pill radius/full + soft shadow; AI-READY + storybook 12.
- **2026-07-24** [storybook-app-header-global-icon-stroke]: AppHeader global: manual sync — trailing Button icon stroke `text/primary` (default) / `text/on-color` (inverse); AI-READY + docs.
- **2026-07-24** [storybook-app-header-global]: AppHeader global (`3143:8822`): default+inverse small-centered; local Button text/md; local icons; greeting prop + body/large/medium; Avatar exposed; bell-only trailing; inverse-3 AI-READY + docs.
- **2026-07-24** [storybook-section-header]: SectionHeader (`4235:406`): clear remotes; body/large/semi-bold + text/primary; local Button text/sm icon-only; generic Title; AI-READY + storybook showAction×2.
- **2026-07-24** [storybook-offer-product-card]: OfferProductCard (`4227:418`): clear remotes; local Button solid/sm; package-outline + generic copy; surface/2|3; radius/500; AI-READY + storybook state×1.
- **2026-07-24** [storybook-dashboard-card-primary-apply]: DashboardCardPrimary (`4181:493`): clear remotes; local typography; icon strokes on-color*; rename `chartTrack`/`chartAccent` + `metricItem1|2`; `inverse-4` AI-READY + docs sync.
- **2026-07-24** [storybook-dashboard-card-primary]: DashboardCardPrimary (`4181:493`): rename from Dash-card-primary; `type=web|mobile` kebab; camelCase props; local inverse-* dark surface + text/on-color*; local icons; AI-READY + storybook type×2.
- **2026-07-24** [storybook-dashboard-card-secondary]: DashboardCardSecondary (`4181:528`): S2 spacing/surface; icon chip `text/brand`+`on-color`; info placeholder; rename `percentual`/`percentageRow`; AI-READY + storybook type×growth 4.
- **2026-07-24** [storybook-quick-access-tile-icon-brand]: QuickAccessTile icon: manual sync — outline stroke `text/brand` (disabled `text/placeholder`); AI-READY + docs.
- **2026-07-24** [storybook-quick-access-tile-generic]: QuickAccessTile: generic defaults — label `Label` + icon `apps-outline`; preferredValues mix; AI-READY + docs.
- **2026-07-24** [storybook-quick-access-tile-label-left]: QuickAccessTile: manual sync — label textAlign LEFT; AI-READY + docs.
- **2026-07-24** [storybook-quick-access-tile]: QuickAccessTile (`4203:447`): remap remotes→S2 kebab; local `credit-card-outline` + preferredValues; `caption/medium/medium`; `text/primary` + `actions/primary`; AI-READY + storybook state×3.
- **2026-07-24** [storybook-card-stacked]: CardStacked (`4170:4433`): S2 spacing binds; slot `100`vert/`200`horiz + content wrapper; media FILL; layer renames; expose Avatar/actions; demos + ImageItem preferredValues; AI-READY + storybook style×layout 6.
- **2026-07-24** [storybook-card-horizontal-slot-pad]: CardHorizontal `layout=slot`: manual pad sync — vertical `spacing/100` + horizontal `spacing/200` (filled aligned); AI-READY + docs.
- **2026-07-24** [storybook-card-horizontal]: CardHorizontal (`4170:4506`): removed `slotSwap`; slot kept + demos; `spacing/200|050` + `radius/300`; expose Avatar; media FILL; AI-READY + storybook style×layout 6.
- **2026-07-23** [storybook-card-elevated-filled-items]: CardElevatedItem (`4170:4564`) + CardFilledItem (`4170:4576`): rename from Material Card states; kebab state; `showFocusIndicator` default true; S2 surfaces/interactive/elevation; `spacing/100`; pressed root fill; AI-READY + storybook state×5.
- **2026-07-23** [storybook-card-outlined-pressed]: CardOutlinedItem pressed: manual sync — root `interactive/pressed` over `surface/0`; stateLayer empty; AI-READY + docs.
- **2026-07-23** [storybook-card-outlined-item]: CardOutlinedItem (`4170:4552`): `showFocusIndicator` default true; `border/2` on focus; stateLayer `spacing/100`; dedupe hover/pressed fills; elevation/6|/5 AI-READY; storybook state×5.
- **2026-07-23** [storybook-carousel]: Carousel (`4152:849`): `showPaginationItem` BOOLEAN; slot demos×4 + ImageItem preferredValues; stretchChildOnInsert; AI-READY EN + storybook sync (no chevrons intentional).
- **2026-07-23** [storybook-carousel-pagination-gap]: CarouselPaginationItem: dots gap `spacing/050`→`spacing/100` (8px); AI-READY + docs sync.
- **2026-07-23** [storybook-carousel-pagination-item]: CarouselItem→CarouselPaginationItem (`4152:495`): local `spacing/*`; dot size `spacing/100`; rename dots; expose on Carousel; AI-READY EN; Carousel shell docs; storybook sparse 14.
- **2026-07-23** [storybook-photo-text-item]: PhotoTextItem (`4149:479`): AI-READY INTERNAL; S2 typography/tokens; `showSupportingText`; nested in ImageItem 20/20 via `showPhotoTextItem` BOOLEAN (STRETCH fill); ImageItem AI-READY sync; storybook entries.
- **2026-07-23** [storybook-slider]: Slider (`3950:7327`) + SliderBaseItem (`3950:7416`): AI-READY EN; feedback `body/small/regular`; spacing/100 gaps; expose Base/Skeleton (+ Base Item/Input); Base TEXT label/min/max + Input `content=value`; storybook entries; read-only→Input default documented.
- **2026-07-23** [storybook-slider-skeleton-item]: SliderSkeletonItem (`4092:4005`): AI-READY EN; spacing/100|200 + bone radius/100; expose SliderItem; rewired Status=Skeleton off legacy; storybook entry.
- **2026-07-22** [storybook-slider-item]: SliderItem (`4073:2232`): AI-READY EN; active wired to nested SliderLeftRail; expose SliderRail; middleIndicator `spacing/025`; rewired 12 legacy `_Slider item` instances; storybook entry active×2.
- **2026-07-22** [storybook-slider-rail]: SliderRail (`4073:2228`): AI-READY EN; child order Right→Left (intentional); expose SliderLeftRail; rewired 14 instances off legacy `_Slider rail`; shell HUG kept; storybook entry.
- **2026-07-22** [storybook-slider-right-rail]: SliderRightRail (`4073:2224`): AI-READY EN; spacing/250 gap + spacing/025 height FIXED parity with LeftRail; storybook entry; LeftRail composition refs synced to SliderRightRail.
- **2026-07-22** [storybook-image-orientation-item-rename]: ImageOrientationBlock→ImageOrientationItem (`3671:2318`) + prop showOrientationBlock→showOrientationItem; FileUploader rule keys vsBlock→vsDropzone and Button/Block prose → FileUploaderDropzoneItem. Completes Block→Item naming pass. Figma + docs synced.
- **2026-07-22** [storybook-block-to-item-rename]: Renamed subcomponent suffix Block→Item: VerificationCodeInputItem, DatePickerSelectItem, CommentItem, ImageItem; FileUploaderBlock→FileUploaderDropzoneItem (collision with FileUploaderItem). Figma + docs synced.
- **2026-07-22** [storybook-slider-left-rail-recreate]: SliderLeftRail recreate `4073:2214`: AI-READY EN; spacing/250|025 binds; wired into `_Slider rail` + Slider overrides; storybook nodeId sync.
- **2026-07-22** [storybook-slider-left-rail]: SliderLeftRail: both active fills color/actions/primary (size-only diff); AI-READY EN; spacing/250 gap + spacing/025 height binds; page Slider trim; storybook entry active×2.
- **2026-07-21** [storybook-app-header]: AppHeader: swapped remote App bar text→local TextHeader; showProfileMenu; first/second trailing=search/bell; showAction wired; Painel Home search+greeting title; storybook sync.
- **2026-07-21** [storybook-system-header]: SystemHeader: wired showPrimaryAction; exposed datePickerSelect; slot description; AI-READY + storybook sync (simple sparse trailing).
- **2026-07-21** [storybook-date-picker-select]: DatePickerSelect: exposed nested day/month/year DatePickerSelectItem instances; AI-READY desc (value via nested); storybook entry format×state 16.
- **2026-07-21** [storybook-date-picker-select-block]: DatePickerSelectItem: wired value TEXT on all 21 variants; renamed chevron-up-outline Vector→*-path; storybook entry (unit×state×expanded).
- **2026-07-20** [storybook-input-focus-caret-error-icon]: Input: added focus caret (Material pattern) and always-on trailingIconError (alert-circle) for error a11y; docs updated.
- **2026-07-20** [storybook-input]: Added Input (outlined floating-label, h=56, radius/200) from Material Text field matrix + target visual identity; S2 tokens; AI-Ready and storybook docs.
- **2026-07-20** [storybook-input-removed]: Removed Input component from Figma and cleared Input storybook/AI-Ready docs to restart from scratch.
- **2026-07-20** [storybook-pagination-select-menu]: Added PaginationSelectMenu + PaginationSelectMenuItem (ListActionDropdown pattern); nested under PaginationSelectInput expanded; deprecated Carbon draft.
- **2026-07-20** [storybook-link]: Link: modernized from Carbon to S2 — kebab props/variants, local tokens/typography/icons, AI-Ready and storybook docs.
- **2026-07-20** [storybook-tooltip-sync]: Tooltip: synced AI-Ready/token rules to manual specs — border/width/012, arrow constraints horizontal, body/small/regular, elevation/spacing detail.
- **2026-07-20** [storybook-vertical-stepper]: Added VerticalStepper container with items SLOT for VerticalStepperItem; preferredValues; AI-Ready and storybook docs.
- **2026-07-20** [storybook-vertical-stepper-item]: VerticalStepperItem: kept nested ListItem; exposed ListItem props; unified alignment; cleaned AI-Ready; storybook docs added.
- **2026-07-20** [storybook-step-progress]: Added StepProgressIndicator/Segment; remapped Spacing/050 to HUG+spacing/050 track; cleaned AI-Ready entities; storybook docs added.
- **2026-07-20** [storybook-modal-header-alignment]: ModalHeader: added alignment=start|center with optical center leadingSpacer; AI-Ready and storybook docs updated.
- **2026-07-20** [storybook-modal-header]: Added ModalHeader; replaced Modal AppHeader with ModalHeader; cleaned AI-Ready entities/typography docs; storybook synced.
- **2026-07-20** [storybook-mobile-gesture-navigation]: MobileGestureNavigation: INTERNAL prefix; appearance default|inverse; Keyboard nests component instead of gestureBar; docs synced.
- **2026-07-20** [storybook-overlay]: Added Overlay; renamed type/platform kebab; composed Modal/BottomSheet in slot; bound spacing; cleared set stroke; AI-Ready and storybook docs.
- **2026-07-20** [storybook-keyboard-polish]: Keyboard polish: removed remotes/GIF/BB; bound radius/spacing; DS text styles; local shift/backspace; enter text/on-color; docs synced.
- **2026-07-20** [storybook-keyboard]: Added Keyboard placement utility; renamed configuration/layout kebab variants; remapped Schemes to local tokens; Poppins + local icons; AI-Ready and storybook docs.
- **2026-07-20** [storybook-breadcrumb]: Added Breadcrumb; cleaned AI-Ready entities; hid currentItem slash; fixed leadingIcon alignment; renamed page; canonical AI-Ready and storybook docs added.
- **2026-07-17** [storybook-list-manual-sync]: List documentation synced to manual Figma refinements (nodeId 3745:10921, default type=dropdown).
- **2026-07-17** [storybook-list]: Added List (type=plain|dropdown) with items SLOT for ListItem; showScroll; elevation/2 on dropdown; canonical AI-Ready and storybook docs added.
- **2026-07-17** [storybook-list-item-manual-sync]: ListItem documentation synced to manual Figma refinements (Switch md, control-only Checkbox/Radio, icon defaults, contentRow layout).
- **2026-07-17** [storybook-breadcrumb-item]: Added BreadcrumbItem; fixed overflow open overlay layout (absolute ListActionDropdown, content-hug width, showDivider=false); wired label; Contente→Content; canonical AI-Ready and storybook docs added.
- **2026-07-17** [storybook-list-item-building-blocks]: Added ListItemLeadingMonogram, ListItemStateLayer, ListItemImageThumbnail, ListItemVideoThumbnail; fixed focusRing STRETCH, ring-only focus, local pressedRipple; video FILL + playIcon; canonical AI-Ready and storybook docs added.
- **2026-07-17** [storybook-icon-scale]: Formalized icon size scale 80/64/40/32/24/20/16 with proportional stroke from master 24px + border/width/025 (2px); documented Figma Scale/unbind rules and INSTANCE_SWAP caveat.
- **2026-07-17** [storybook-list-action-dropdown]: Added ListActionDropdown; remapped Spacing/* to local spacing; wired showDivider/showScroll; added local scroll affordance; slot preferredValues; canonical AI-Ready and storybook docs added.
- **2026-07-17** [storybook-list-action-dropdown-item-no-country]: ListActionDropdownItem: removed showCountry prop and countryFlag layer; docs updated.
- **2026-07-17** [storybook-list-action-dropdown-item]: Added ListActionDropdownItem; fixed focusRing STRETCH; added state=focus; local icon preferredValues; canonical AI-Ready and storybook docs added.
- **2026-07-17** [storybook-image-block]: Added ImageItem; restored verticalResize keepers (FIXED×HUG / HUG×FIXED) from Aspect ratio base; local color/background-surface/1; kept imageSurface; canonical AI-Ready and storybook docs added.
- **2026-07-16** [storybook-chip-group]: Added ChipGroup; recomposed all nested chips on ChipClickable intent=outline size=sm; reset broken overrides; filter uses selected; AI-Ready and storybook docs added.
- **2026-07-16** [storybook-comment-block]: Added CommentItem (Figma-only annotation); remapped elevation/spacing tokens; local category icons; unified leadingIcon/showIcon; intentional generic vs categoryTag composition documented.
- **2026-07-16** [storybook-organization-header]: Added OrganizationHeader (Figma docs header); descriptionSlot FILL wrap; local ChipTag icon; cleaned AI-Ready React mapping; storybook docs added.
- **2026-07-16** [storybook-file-uploader-skeleton-bones]: FileUploader: restored semantic layer names and showFiles bind; skeleton bones-only (no nested components); docs updated.
- **2026-07-16** [storybook-file-uploader]: Added FileUploader; Button size/icon/label aligned to matrix; skeleton cleaned (bones, DnD dropzone); AI-Ready and storybook docs added; showFiles intentional on default-only.
- **2026-07-16** [storybook-upload-photos]: Added UploadPhotos metadata; applied local text styles; local chevron + visible Button labels; renamed camera path; AI-Ready and storybook docs added.
- **2026-07-16** [storybook-file-uploader-list]: Added FileUploaderList; recomposed on FileUploaderItem; showFileItem02–07 props; deprecated legacy _File uploader file item; AI-Ready and storybook docs added.
- **2026-07-16** [storybook-file-uploader-item]: Added FileUploaderItem metadata; removed orphan longFileName/showLongFileName; renamed layers; aligned danger-long text tokens; AI-Ready and storybook docs added.
- **2026-07-16** [storybook-file-uploader-block]: Added FileUploaderDropzoneItem metadata; unified focus padding; cleaned dropzone dash/root fills; documented stroke width tokens and dashPattern leftover; AI-Ready and storybook docs added.
- **2026-07-16** [storybook-tooltip]: Added Tooltip metadata; remapped Title Case elevation/spacing tokens; fixed bottom-center arrow constraint; AI-Ready (EN) and storybook docs added.
- **2026-07-16** [storybook-tooltip-rich]: Added TooltipRich metadata; remapped Title Case tokens to kebab; documented intentional secondaryAction text/on-color; unified layer order; AI-Ready and storybook docs added.
- **2026-07-15** [storybook-toast]: Added Toast metadata; published showAction and dismissible; split action/dismiss Buttons; unified statusIcon fills; AI-Ready and storybook docs added.
- **2026-07-15** [storybook-tabs-secondary]: Added TabsSecondary metadata; remapped Spacing/050|100|200 and Color/Content/Disabled; documented no appearance/inverse axis; AI-Ready and storybook docs added.
- **2026-07-15** [storybook-tabs-primary]: Added TabsPrimary metadata; remapped Spacing/200 and Color/Content/Disabled; documented intentional-sparse inverse×web; AI-Ready and storybook docs added.
- **2026-07-15** [storybook-tab-item]: Added TabItem metadata; renamed selectedIcon→leadingIcon; documented intentional-sparse inverse matrix; hid secondary selectedIndicator except selected; remapped Color/Content/Brand→text/brand; AI-Ready and storybook docs added.
- **2026-07-15** [storybook-table-mobile]: Added TableMobile metadata; relinked orphan TableMobileCell instances; remapped Title Case tokens; documented intentional-sparse interactive×columnCount; AI-Ready and storybook docs added.
- **2026-07-15** [storybook-table-mobile-cell]: Added TableMobileCell metadata; removed interactive axis; renamed Instance→icon; remapped Spacing/800→spacing/800; slot preferred chip clickable; AI-Ready and storybook docs added.
- **2026-07-15** [storybook-table-expand-chevron]: TableExpandCell: added intentional-sparse type=header showChevron=false spacer (keeps 56×40, no chevron); docs updated.
- **2026-07-15** [storybook-table]: Renamed Table Web → Table; recomposed header/body on TableRow; docs key Table; AI-Ready and storybook updated.
- **2026-07-15** [storybook-table-web]: Added TableWeb metadata; modernized props (columns, showHeader, rows slot with default body lines); AI-Ready description and storybook docs added.
- **2026-07-14** [storybook-table-skeleton]: Added TableSkeleton metadata; cleaned AI-Ready description (fixed density, empty false vs true, intentional leftover bodyRow07–10); storybook docs added.
- **2026-07-14** [storybook-table-row-expand]: TableRow: added showExpandCell boolean with trailing TableExpandCell on all variants; AI-Ready description and storybook docs updated.
- **2026-07-14** [storybook-table-row]: Added TableRow metadata; repaired 60 detached TableCell instances after showAction removal; remapped Border/Radius legacy tokens; documented row-level focus; storybook docs added.
- **2026-07-14** [storybook-table-cell-slot]: TableCell: aligned docs and AI-Ready description to type=slot (renamed from action); refreshed spacing token rule to used tokens.
- **2026-07-14** [storybook-table-expand-cell]: Added TableExpandCell metadata; cleaned AI-Ready description (no size axis; selected=expanded with structural chevron-up); renamed selected path layers; storybook docs added.
- **2026-07-14** [storybook-table-cell-remove-show-action]: TableCell: removed showAction variant axis (kept non-action variants); updated AI-Ready description and storybook docs.
- **2026-07-14** [storybook-table-cell]: Added TableCell metadata; remapped Spacing/800|100|500 to kebab-case; documented intentional-sparse header and showAction variant axis; storybook docs added.
- **2026-07-14** [storybook-button-text-icon]: Button: documented showIcon (leadingIcon) on variant=text + intent=primary (enabled) using text/primary across states; token rules clarified.
- **2026-07-14** [storybook-switch]: Added Switch metadata; remapped Spacing/0 and Border/Radius/0; renamed parent Loovi to Switch; checked icon to color/actions/primary; documented showIcon md-only; storybook docs added.
- **2026-07-14** [storybook-stepper-primary]: Added StepperPrimary metadata; inactive trails unified to color/border/2; cleaned AI-Ready description; documented intentional sparse trailState matrix; storybook docs added.
- **2026-07-14** [storybook-radio-button]: Added RadioButton metadata; remapped Border/Radius/0 to border/radius/0; cleaned AI-Ready description entities; added React mapping and token rule.
- **2026-07-14** [storybook-progress-bar]: Added ProgressBar metadata; trimmed parent frame name; cleaned AI-Ready description entities; documented value-as-label vs layout-controlled indicator fill.
- **2026-07-13** [storybook-pagination-select-input]: Added PaginationSelectInput metadata; remapped expanded border from color/border-feedback/primary to interactive/focus; documented default|hover-only states; storybook docs added.
- **2026-07-13** [storybook-pagination]: Added Pagination metadata; remapped Spacing/500 and Color/Content/Ghost; fixed size=lg prev/next disabled by position; exposed actions and pageItems; trimmed parent page name; storybook docs added.
- **2026-07-13** [storybook-pagination-item]: Added PaginationItem metadata; removed pressed from interaction states; documented intentional sparse selected×focus/disabled matrix; storybook docs added.
- **2026-07-13** [storybook-navigation-rail-expanded]: Added NavigationRailExpanded metadata; remapped legacy Spacing/Border/Content tokens; wired showMenu on all variants; exposed nested trees; renamed Section 1/2 to section01/02; documented top-only trees and itemCount=6 sections.
- **2026-07-13** [storybook-navigation-rail-expanded-tree]: Added NavigationRailExpandedTree metadata; remapped legacy Spacing/Color/Border tokens to kebab-case; renamed marcador/Nav tree/Vertical layers; exposed nested navItem01; documented second-level sparse selectedItem matrix.
- **2026-07-13** [storybook-navigation-rail-expanded-item]: Added NavigationRailExpandedItem metadata; documented hierarchy=nav-tree as intentional sparse axis; exposed nested Badge; intentional color model documented.
- **2026-07-13** [storybook-navigation-rail-compact]: Added NavigationRailCompact metadata; remapped Spacing/600, Spacing/1000 and Color/Content/Default Inverse to kebab-case; renamed parent frame Navegation Rail to Navigation Rail.
- **2026-07-13** [storybook-navigation-rail-compact-item]: Added NavigationRailCompactItem metadata; remapped Color/Interactive/* and Color/Background Surface/2 to kebab-case; renamed Label text to label; exposed nested Badge; intentional color model documented.
- **2026-07-13** [storybook-navigation-bar]: Added NavigationBar metadata; remapped Spacing/700 to spacing/700 on FAB; documented itemCount=5 as 4 items + primaryIconButtonSlot; renamed plus-outline Vector to plus-outline-path.
- **2026-07-13** [storybook-navigation-bar-item]: Added NavigationBarItem metadata; remapped Spacing/800 and Color/Interactive/Focus to kebab-case; exposed nested Badge for count/overflowLabel; intentional color model documented.
- **2026-07-13** [storybook-navigation-drawer]: Added NavigationDrawer metadata including composition rules and itemCount=6 secondary-section note.
- **2026-07-13** [storybook-navigation-drawer-item]: Added NavigationDrawerItem metadata; remapped legacy Color/Spacing tokens to kebab-case; swapped remote info-circle-outline to local DS icon.
- **2026-07-10** [storybook-modal]: Added Modal metadata; remapped legacy surface/spacing tokens; cleaned React description entities. AppHeader internal override discarded.
- **2026-07-10** [storybook-appheader]: AppHeader: remapped Color/Border/2 and Profile menu Spacing/Border tokens; swapped remote icons to local DS library; synced AI-Ready description.
- **2026-07-10** [storybook-divider-vertical]: Added DividerVertical metadata; remapped Color/Border/2 to color/border/2.
- **2026-07-10** [storybook-divider-horizontal]: Added DividerHorizontal metadata; remapped Color/Border/2 and Color/Content/Disabled to kebab-case; renamed Text prop to label.
- **2026-07-10** [storybook-chiptag]: Added ChipTag metadata; remapped legacy token bindings to kebab-case including danger to color/background-feedback-primary/danger and Ghost to text/secondary.
- **2026-07-10** [storybook-feedback-governance]: Added feedback usage table mapping content vs bg-primary vs bg-secondary vs interactive/*-surface vs border-feedback; fixed border-feedback success/danger naming.
- **2026-07-09** [storybook-components]: Added Storybook component metadata for already refined components, Banner status danger, current AI-Ready descriptions and icon layer naming rule.

---

*Gerado a partir de `design-system-tokens.storybook.updated.v2.json`.*
