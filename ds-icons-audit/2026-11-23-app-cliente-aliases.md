# Auditoria — DS Semantic Aliases (App Cliente / Hugeicons)

**Data:** 2026-11-23 · **Arquivo:** [DS] Icons — App Cliente (`4LsFOmHu3B25vXsDPjklWs`), seção `7003:12884` · **Escopo:** 4.285 aliases
**Status:** itens 2–5 **aplicados em 2026-11-23** (ver "Aplicado"); item 1 (605 `*-filled`) aguarda decisão de design.

## Aplicado (2026-11-23)

- **Geometria (9 aliases):** `arrow-left|up|down-outline` e os 4 `arrow-narrow-*-outline` agora usam a seta de `arrow-right-outline` (7003:12911) girada no centro (180° / ±90°); `chevron-right-outline` e `chevron-right-filled` usam o chevron de `chevron-left-outline|filled` girado 180°. A instância Hugeicons `arrow-*-01-sharp` (chevron) saiu de `arrow-narrow-right|up`. Os 4 `arrow-narrow-*` ficaram iguais aos `arrow-*` (o Hugeicons não tem seta "narrow" separada).
- **Cor:** 12 traços `#4B4F55` → `#1A1E1F` em `home-outline`, `claim-outline`, `tow-truck-outline`.
- **Nome:** `car-filled-2` → `car-side-filled` (7102:12737).
- **Não renomeado:** `" tire"` (7131:12608) — já existe `tire-outline` (7044:20714); é uma segunda versão. Design decide: apagar ou dar outro nome.
- **Publicar:** as mudanças só chegam aos arquivos consumidores depois de **Publish library** no Figma (ação manual).
- Flutter: `arrow-left-outline`, `arrow-narrow-right-outline`, `chevron-right-outline` reexportados; goldens atualizados.

## Resumo

| # | Achado | Qtd | Prioridade |
| --- | --- | --- | --- |
| 1 | `*-filled` sem preenchimento (geometria de contorno) | 605 | P1 |
| 2 | `arrow-*` desenhado como chevron | 5 (+1 a conferir) | P1 |
| 3 | `chevron-*` desenhado como seta | 2 | P1 |
| 4 | Traço fora do contrato (`#4B4F55` = text/secondary) | 3 | P2 |
| 5 | Nome fora do contrato `*-outline` / `*-filled` | 2 | P2 |

## 1. `*-filled` sem preenchimento (P1)

605 aliases com nome `*-filled` não têm nenhum fill de tinta visível — só traço. Ou seja: o contrato `*-filled` está, na prática, mapeado para o estilo *stroke* do Hugeicons. Exemplos usados no app: `info-circle-filled` (7012:13030), `alert-circle-filled` (7012:13028), `alert-triangle-filled` (7012:13023), `bell-filled` (7012:13179), `user-filled` (7012:13181), `shield-filled` (7020:13666), `heart-filled` (7012:13171), `star-half-filled`, `bookmark-filled`, `chevron-*-filled`.

Exceções que estão certas (preenchidas): `circle-check-filled`, `home-filled`, `car-filled`, entre outras.

Sugestão: remapear os `*-filled` para o estilo *solid* do Hugeicons (mesmo nome de alias, só troca a geometria). A lista completa sai do script abaixo.

## 2 e 3. Seta × chevron (P1)

| Alias | Node | Bounding box | Problema |
| --- | --- | --- | --- |
| `arrow-left-outline` | 7003:12908 | 6×12 | chevron |
| `arrow-up-outline` | 7020:13166 | 12×6 | chevron |
| `arrow-down-outline` | 7020:13169 | 12×6 | chevron |
| `arrow-narrow-left-outline` | 7012:13080 | 6×12 | chevron |
| `arrow-narrow-down-outline` | 7020:13174 | 12×6 | chevron |
| `arrow-narrow-right-outline` | 7003:12915 | — | visto como chevron no render; conferir |
| `chevron-right-outline` | 7003:12917 | 16×10 | seta |
| `chevron-right-filled` | 7020:13762 | 16×10 | seta |

Provável causa: no Hugeicons, `arrow-*-01` é chevron; o mapeamento seguiu o nome.

## 4. Cor de traço (P2)

`home-outline` (7019:13176), `claim-outline` (7019:13212), `tow-truck-outline` (7019:13250) usam `#4B4F55` em parte do traço. O contrato é monocromático (`text/primary` no master). O preto `#000000` em `car-*`, `home-*`, `claim-*`, `tow-truck-*` é de máscara (luminância) e está correto.

## 5. Nomes (P2)

- `car-filled-2` (7102:12737) — sufixo fora do contrato; usa `#F7FAFF`.
- `" tire"` (7131:12608) — espaço no início e sem `-outline` / `-filled`.

## Impacto no código

O pacote Flutter `loovi_ds` reproduz os aliases como estão (`tool/extract_icons.mjs`). Depois da correção no Figma: reexportar os aliases usados (ver `tool/icon_alias_nodes.json`), rodar o extrator e atualizar os goldens.

## Script (read-only, `use_figma` no arquivo `4LsFOmHu3B25vXsDPjklWs`)

```js
const sec = await figma.getNodeByIdAsync('7003:12884');
let page = sec; while (page && page.type !== 'PAGE') page = page.parent;
await figma.setCurrentPageAsync(page);
const syms = sec.findAllWithCriteria({ types: ['COMPONENT'] });
const hex = (c) => '#' + [c.r, c.g, c.b].map((x) => Math.round(x * 255).toString(16).padStart(2, '0').toUpperCase()).join('');
const OK = new Set(['#1A1E1F', '#FFFFFF']);
const out = { arrowAsChevron: [], chevronAsArrow: [], filledWithoutFill: [], offContractColor: [] };
for (const s of syms) {
  const name = s.name;
  const shapes = s.findAll((n) => 'fills' in n && !['FRAME', 'GROUP', 'COMPONENT'].includes(n.type) && n.visible !== false);
  let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity, ink = false; const colors = new Set();
  for (const n of shapes) {
    const b = n.absoluteBoundingBox; if (b) { minX = Math.min(minX, b.x); minY = Math.min(minY, b.y); maxX = Math.max(maxX, b.x + b.width); maxY = Math.max(maxY, b.y + b.height); }
    for (const f of (Array.isArray(n.fills) ? n.fills : [])) if (f.type === 'SOLID' && f.visible !== false) { const h = hex(f.color); colors.add(h); if (h !== '#FFFFFF') ink = true; }
    for (const f of (Array.isArray(n.strokes) ? n.strokes : [])) if (f.type === 'SOLID' && f.visible !== false) colors.add(hex(f.color));
  }
  const w = maxX - minX, h = maxY - minY;
  const horiz = /^(arrow|chevron)-(left|right)-|^arrow-narrow-(left|right)/.test(name);
  const vert = /^(arrow|chevron)-(up|down)-|^arrow-narrow-(up|down)/.test(name);
  if (/^arrow-/.test(name) && ((horiz && w / h < 0.75) || (vert && h / w < 0.75))) out.arrowAsChevron.push(`${name} ${s.id}`);
  if (/^chevron-/.test(name) && ((horiz && w / h > 1.1) || (vert && h / w > 1.1))) out.chevronAsArrow.push(`${name} ${s.id}`);
  if (/-filled$/.test(name) && !ink) out.filledWithoutFill.push(`${name} ${s.id}`);
  const bad = [...colors].filter((c) => !OK.has(c)); if (bad.length) out.offContractColor.push(`${name} ${s.id} ${bad}`);
}
return out;
```
