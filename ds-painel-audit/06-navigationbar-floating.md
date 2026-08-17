# Auditoria 06 — NavigationBar (layout floating)

**Tipo:** Evolução de componente existente  
**Etapa do plano:** E6  
**Status de auditoria:** ✅ Validado (2026-08-17 — Figma `3653:14851` layout=floating)

---

## Links

| Recurso | URL |
|---|---|
| Componente `NavigationBar` (doc node) | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3327-2528 |
| Set publicado (implementação) | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3653-14851 |
| `NavigationBarItem` | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3327-2878 |
| Página Navigation Bar | https://www.figma.com/design/mHm12Zu9tgNmaSYnooihE5/-DS--2.0---S2?node-id=3327-2224 |
| Storybook — NavigationBar | [`design-system-storybook.md`](../design-system-storybook.md) |
| Referência Painel — bottom nav | https://www.figma.com/design/CHvtaAGCXlqvqZzWD0Or5B/Novo-App-UI?node-id=10438-33053 |

**Node IDs:** doc `3327:2528` · set `3653:14851` · item `3327:2878`

---

## O que foi feito

- Nova variante **`layout`:** `flush` | `floating`
- Variantes antigas → `layout=flush`
- Variante esparsa: `itemCount=5` + `appearance=default` + `layout=floating`
  - `border/radius/full`
  - drop shadow
  - superfície `color/background-surface/0`
- `itemCount=5` continua = **4 destinos + ação central (Acionar)**, não 5 itens iguais

---

## Spec técnica

### Variants

| Eixo | Valores |
|---|---|
| `itemCount` | 3 \| 4 \| 5 |
| `appearance` | default \| inverse |
| `layout` | flush \| floating |

### Regras

- **flush:** `border/radius/0`, edge-to-edge
- **floating:** pill + elevação + inset horizontal na composição de tela
- **itemCount=5:** `navItem01` + `navItem02` + `primaryIconButtonSlot` + `navItem04` + `navItem05`

### Itens Painel

| Destino | Estado |
|---|---|
| Home | `selected=true` |
| Veículos | default |
| Acionar (centro) | primary slot + label |
| Sinistro | default |
| Menu | default |

### Tokens

- `color/background-surface/0`
- `border/radius/full` (floating)
- Nested `NavigationBarItem` tokens

---

## Checklist de validação

- [ ] Floating parece a barra pill do Painel
- [ ] Centro Acionar com label (não só FAB genérico plus, se aplicável)
- [ ] selected/a11y ok
- [ ] Docs alinhados flush vs floating
- [ ] Aprovo / peço ajuste: _______________

---

## Notas do auditor

_Preencher durante a revisão._
