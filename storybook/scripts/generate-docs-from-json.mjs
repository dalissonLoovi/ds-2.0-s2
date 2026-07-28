/**
 * Generate Storybook MDX docs from design-system-tokens.storybook.updated.v2.json
 *
 * Source of seed metadata (until React components exist):
 *   ../design-system-tokens.storybook.updated.v2.json
 *
 * Output:
 *   src/Introduction.mdx
 *   src/foundations/*.mdx
 *   src/components/*.mdx
 *   src/Changelog.mdx
 */

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '../..');
const STORYBOOK_SRC = path.resolve(__dirname, '../src');
const JSON_PATH = path.join(ROOT, 'design-system-tokens.storybook.updated.v2.json');

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function wipeGenerated(dir) {
  if (!fs.existsSync(dir)) return;
  for (const entry of fs.readdirSync(dir)) {
    fs.rmSync(path.join(dir, entry), { recursive: true, force: true });
  }
}

/** Escape prose so MDX does not treat { } < as JSX */
function escapeMdx(text) {
  return String(text ?? '')
    .replace(/\\/g, '\\\\')
    .replace(/\{/g, '\\{')
    .replace(/\}/g, '\\}')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
}

/** Escape for Markdown table cells (pipes break columns) */
function escapeTableCell(text) {
  return escapeMdx(text).replace(/\|/g, '\\|');
}

function figmaNodeUrl(fileKey, nodeId) {
  if (!fileKey || !nodeId) return null;
  const nodeParam = String(nodeId).replace(':', '-');
  return `https://www.figma.com/design/${fileKey}/-DS--2.0---S2?node-id=${nodeParam}`;
}

function asList(value) {
  if (value == null) return [];
  if (Array.isArray(value)) return value;
  return [value];
}

function objectEntries(obj) {
  if (!obj || typeof obj !== 'object') return [];
  return Object.entries(obj);
}

function bulletList(items) {
  const list = asList(items).filter(Boolean);
  if (!list.length) return '_None._\n';
  return list.map((item) => `- ${escapeMdx(item)}`).join('\n') + '\n';
}

function variantsSection(variants) {
  const entries = objectEntries(variants);
  if (!entries.length) return '';
  let md = '## Variants\n\n';
  for (const [key, vals] of entries) {
    const joined = asList(vals).join(' | ');
    md += `- **${escapeMdx(key)}:** ${escapeMdx(joined)}\n`;
  }
  return md + '\n';
}

function propsSection(props) {
  const entries = objectEntries(props);
  if (!entries.length) return '';
  let md = '## Props\n\n| Prop | Type / values |\n| --- | --- |\n';
  for (const [key, val] of entries) {
    md += `| \`${escapeTableCell(key)}\` | ${escapeTableCell(val)} |\n`;
  }
  return md + '\n';
}

function rulesSection(rules) {
  const entries = objectEntries(rules);
  if (!entries.length) return '';
  let md = '## Rules\n\n';
  for (const [key, val] of entries) {
    if (val && typeof val === 'object' && !Array.isArray(val)) {
      md += `- **${escapeMdx(key)}:**\n`;
      for (const [sk, sv] of Object.entries(val)) {
        md += `  - **${escapeMdx(sk)}:** ${escapeMdx(sv)}\n`;
      }
    } else if (Array.isArray(val)) {
      md += `- **${escapeMdx(key)}:**\n`;
      for (const item of val) md += `  - ${escapeMdx(item)}\n`;
    } else {
      md += `- **${escapeMdx(key)}:** ${escapeMdx(val)}\n`;
    }
  }
  return md + '\n';
}

function tokenRulesSection(tokenRules) {
  const list = asList(tokenRules);
  if (!list.length) return '';
  return '## Token rules\n\n' + bulletList(list) + '\n';
}

function productThemeSection(productTheme) {
  if (!productTheme || typeof productTheme !== 'object') return '';
  const modes = asList(productTheme.modes);
  const tokens = asList(productTheme.tokens);
  if (!modes.length && !tokens.length) return '';

  let md = '## Product theme\n\n';
  if (productTheme.collection) {
    md += `Collection: \`${escapeMdx(productTheme.collection)}\`\n\n`;
  }
  if (modes.length) {
    md += `Modes: ${modes.map((m) => `\`${escapeMdx(m)}\``).join(' | ')}\n\n`;
  }
  if (productTheme.summary) {
    md += `${escapeMdx(productTheme.summary)}\n\n`;
  }

  if (tokens.length) {
    const modeHeaders = modes.length
      ? modes
      : [...new Set(tokens.flatMap((t) => Object.keys(t.aliases || t.aliasByMode || {})))];
    md += `| Token | Bind | ${modeHeaders.map((m) => escapeTableCell(m)).join(' | ')} |\n`;
    md += `| --- | --- | ${modeHeaders.map(() => '---').join(' | ')} |\n`;
    for (const t of tokens) {
      const aliases = t.aliases || t.aliasByMode || {};
      const cells = modeHeaders.map((m) => {
        const val = aliases[m];
        return val == null ? '—' : `\`${escapeTableCell(val)}\``;
      });
      md += `| \`${escapeTableCell(t.name || '')}\` | ${escapeTableCell(t.binds || '')} | ${cells.join(' | ')} |\n`;
    }
    md += '\n';
  }

  const notes = asList(productTheme.notes);
  if (notes.length) {
    md += '### Notes\n\n' + bulletList(notes) + '\n';
  }
  return md;
}

function productThemeGlobalSection(productTheme, metaProductTheme) {
  const pt = productTheme || metaProductTheme;
  if (!pt || typeof pt !== 'object') return '';
  const modes = asList(pt.modes);
  const tokens = asList(pt.tokens || metaProductTheme?.tokens);
  const components = asList(pt.components || Object.keys(metaProductTheme?.byComponent || {}));
  const notes = asList(pt.notes || metaProductTheme?.notes);

  let md = `
## Product theme (\`product-theme\`)

${escapeMdx(pt.summary || metaProductTheme?.summary || '')}

| Field | Value |
| --- | --- |
| Collection | \`${escapeMdx(pt.collection || metaProductTheme?.collection || 'product-theme')}\` |
| Modes | ${modes.map((m) => `\`${escapeMdx(m)}\``).join(' \\| ') || '—'} |
| Components | ${components.map((c) => `\`${escapeMdx(c)}\``).join(', ') || '—'} |
| Variable count | ${escapeMdx(String(metaProductTheme?.variableCount ?? tokens.length ?? '—'))} |

`;

  if (tokens.length) {
    const modeHeaders = modes.length
      ? modes
      : [...new Set(tokens.flatMap((t) => Object.keys(t.aliases || t.aliasByMode || {})))];
    md += `| Token | Component | Bind | ${modeHeaders.map((m) => escapeTableCell(m)).join(' | ')} |\n`;
    md += `| --- | --- | --- | ${modeHeaders.map(() => '---').join(' | ')} |\n`;
    for (const t of tokens) {
      const aliases = t.aliases || t.aliasByMode || {};
      const cells = modeHeaders.map((m) => {
        const val = aliases[m];
        return val == null ? '—' : `\`${escapeTableCell(val)}\``;
      });
      md += `| \`${escapeTableCell(t.name || '')}\` | ${escapeTableCell(t.component || '')} | ${escapeTableCell(t.binds || '')} | ${cells.join(' | ')} |\n`;
    }
    md += '\n';
  }

  if (notes.length) {
    md += '### Notes\n\n' + bulletList(notes) + '\n';
  }
  return md;
}

function compositionSection(composition) {
  const list = asList(composition);
  if (!list.length) return '';
  return '## Composition\n\n' + bulletList(list) + '\n';
}

function statusMapSection(statusMap) {
  const entries = objectEntries(statusMap);
  if (!entries.length) return '';
  let md = '## Status map\n\n| Status | Icon | Background token |\n| --- | --- | --- |\n';
  for (const [status, row] of entries) {
    const icon = row?.icon ?? '—';
    const bg = row?.backgroundToken ?? '—';
    md += `| ${escapeTableCell(status)} | \`${escapeTableCell(icon)}\` | \`${escapeTableCell(bg)}\` |\n`;
  }
  return md + '\n';
}

function writeFile(filePath, contents) {
  ensureDir(path.dirname(filePath));
  fs.writeFileSync(filePath, contents, 'utf8');
}

function generateIntroduction(meta, storybook) {
  const revision = meta.storybookRevision || meta.revision || '—';
  const updated =
    meta.storybookUpdatedAt || storybook.updatedAt || meta.exportedAt || '—';
  return `import { Meta } from '@storybook/blocks';

<Meta title="Introduction" />

# Design System 2.0 — Storybook

Seed documentation catalog generated from Figma metadata JSON.

| | |
| --- | --- |
| **Figma file** | [${escapeMdx(meta.fileName || '[DS] 2.0 - S2')}](${meta.figmaUrl || '#'}) |
| **File key** | \`${escapeMdx(meta.fileKey || '')}\` |
| **Schema** | \`${escapeMdx(storybook.schemaVersion || 'ds-storybook-metadata/v2')}\` |
| **Updated** | ${escapeMdx(updated)} |
| **Revision** | \`${escapeMdx(revision)}\` |

${escapeMdx(storybook.purpose || '')}

## How this catalog works

1. Audit / finalize a component in Figma.
2. Update \`design-system-tokens.storybook.updated.v2.json\` (repo root).
3. Run \`npm run docs:generate\` (also runs automatically before \`storybook\` / \`build-storybook\`).
4. Review locally, open a PR, merge — GitHub Pages publishes the build.

> **Status:** Docs-only seed. Pages marked *Seed docs* are not yet backed by React stories.
> When a component is implemented in code, replace its seed page with CSF3 + Autodocs.

## Sidebar

- **Foundations** — global rules and feedback vocabulary
- **Components** — one page per entry in the metadata JSON
- **Changelog** — recent documentation revisions
`;
}

function generateGlobalRules(storybook, meta) {
  const gr = storybook.globalRules || {};
  const gov = meta.governance || {};
  const libs = gov.iconLibraries || {};
  const libraryRows = asList(libs.libraries)
    .map((lib) => {
      const label = lib.label || lib.id || 'Library';
      const url = lib.figmaUrl ? `[${escapeMdx(label)}](${lib.figmaUrl})` : escapeMdx(label);
      return `| ${url} | \`${escapeMdx(lib.fileKey || '')}\` | ${escapeMdx(lib.sourcePack || '')} | ${escapeMdx(lib.naming || '')} | \`${escapeMdx(lib.productTheme || '')}\` |`;
    })
    .join('\n');

  let iconLibrariesSection = '';
  if (libs.summary || libraryRows) {
    iconLibrariesSection = `
## Icon libraries (multi-product)

${escapeMdx(libs.summary || '')}

| Library | File key | Source pack | Naming | Product theme |
| --- | --- | --- | --- | --- |
${libraryRows || '| — | — | — | — | — |'}

- **Name contract:** ${escapeMdx(libs.nameContract || '*-outline | *-filled')}
- **Strategy:** ${escapeMdx(libs.strategy || 'Library Swap + INSTANCE_SWAP')}
- **Component slots:** ${escapeMdx(libs.componentSlots || 'DS name contract only')}

### Alias rules (App Cliente)

${bulletList(libs.aliasRules)}

### Do not

${bulletList(libs.doNot)}
`;
  }

  return `import { Meta } from '@storybook/blocks';

<Meta title="Foundations/Global rules" />

# Global rules

| Rule | Value |
| --- | --- |
| Variants | ${escapeMdx(gr.variantNaming || '')} |
| Tokens | ${escapeMdx(gr.tokens || '')} |
| Component tokens | \`${escapeMdx(gr.componentTokens || '')}\` |
| Icon layers | ${escapeMdx(gr.iconLayers || '')} |
| Icon scale | sizes \`80/64/40/32/24/20/16\`; stroke from master \`24px\` + \`border/width/025\` |
| Icon libraries | ${escapeMdx(gr.iconLibraries || libs.summary || 'Library Swap + *-outline/*-filled contract')} |
| Code Connect | ${escapeMdx(gr.codeConnect || 'not configured')} |

## Feedback vocabulary

**Use:** ${asList(gr.feedbackVocabulary).map((t) => `\`${t}\``).join(', ') || '—'}

**Deprecated (do not use):** ${asList(gr.deprecatedFeedbackTerms).map((t) => `\`${t}\``).join(', ') || '—'}

## Governance

- **Naming:** ${escapeMdx(gov.naming || 'kebab-case path segments, slash hierarchy')}
- **Disabled spelling:** ${escapeMdx(gov.disabledSpelling || 'use disabled, never disable')}
- **Component descriptions:** ${escapeMdx(gov.componentDescriptions || 'AI-Ready aligned with variables and kebab-case variants')}
- **Icon layer naming:** ${escapeMdx(gov.iconLayerNaming || '{icon-name}-path instead of Vector')}
${iconLibrariesSection}
${productThemeGlobalSection(gr.productTheme, meta.productTheme)}`;
}

function generateFeedback(storybook) {
  const ft = storybook.globalRules?.feedbackUsageTable || {};
  const layers = asList(ft.layers);
  let md = `import { Meta } from '@storybook/blocks';

<Meta title="Foundations/Feedback" />

# Feedback — usage by layer

${escapeMdx(ft.summary || '')}

## Decision guide

`;

  const guide =
    ft.decisionGuide ||
    storybook.docs?.feedback?.decisionGuide ||
    [];
  md += bulletList(guide) + '\n';

  for (const layer of layers) {
    md += `## ${escapeMdx(layer.label || layer.id || 'Layer')}\n\n`;
    if (layer.tokenPattern) md += `- **Token pattern:** \`${escapeMdx(layer.tokenPattern)}\`\n`;
    if (layer.exportPrefix) md += `- **Export prefix:** \`${escapeMdx(layer.exportPrefix)}\`\n`;
    if (layer.allowedStatuses) {
      md += `- **Allowed statuses:** ${asList(layer.allowedStatuses).map((s) => `\`${s}\``).join(', ')}\n`;
    }
    if (layer.textPairing) md += `- **Text pairing:** ${escapeMdx(layer.textPairing)}\n`;
    if (layer.useFor) {
      md += `\n**Use for**\n\n${bulletList(layer.useFor)}`;
    }
    if (layer.doNotUseFor) {
      md += `\n**Do not use for**\n\n${bulletList(layer.doNotUseFor)}`;
    }
    if (layer.figmaVariables) {
      md += `\n**Figma variables:** ${asList(layer.figmaVariables).map((v) => `\`${escapeMdx(v)}\``).join(', ')}\n`;
    }
    if (layer.components) {
      md += `\n**Components:** ${asList(layer.components).map((c) => `\`${escapeMdx(c)}\``).join(', ')}\n`;
    }
    md += '\n';
  }

  return md;
}

function generateComponentPage(name, component, fileKey) {
  const nodeId = component.nodeId || '';
  const url = figmaNodeUrl(fileKey, nodeId);
  const figmaLink = url
    ? `[Open in Figma](${url}) · node \`${escapeMdx(nodeId)}\``
    : `node \`${escapeMdx(nodeId)}\``;

  let md = `import { Meta } from '@storybook/blocks';

<Meta title="Components/${escapeMdx(name)}" />

# ${escapeMdx(name)}

> **Seed docs** — generated from metadata JSON. Pending React implementation (CSF3 + Autodocs).

${figmaLink}

## AI-READY

${escapeMdx(component.description || '_No description._')}

`;

  md += variantsSection(component.variants);
  md += propsSection(component.props);
  md += statusMapSection(component.statusMap);
  md += productThemeSection(component.productTheme);
  md += rulesSection(component.rules);
  md += tokenRulesSection(component.tokenRules);

  if (component.accessibility) {
    md += `## Accessibility\n\n${escapeMdx(component.accessibility)}\n\n`;
  }

  md += compositionSection(component.composition);

  if (component.reactMapping) {
    md += `## React mapping\n\n\`${escapeMdx(component.reactMapping)}\`\n\n`;
  }

  return md;
}

function generateChangelog(meta, storybook) {
  const changelog = asList(meta.changelog);
  const recent = asList(storybook.recentUpdates);

  let md = `import { Meta } from '@storybook/blocks';

<Meta title="Changelog" />

# Changelog

Documentation revisions for the Design System 2.0 Storybook seed.

## Recent updates

`;

  if (!recent.length) {
    md += '_No recentUpdates in metadata._\n\n';
  } else {
    for (const item of recent) {
      md += `- **${escapeMdx(item.id || 'update')}:** ${escapeMdx(item.summary || '')}\n`;
    }
    md += '\n';
  }

  md += '## Meta changelog\n\n';
  if (!changelog.length) {
    md += '_No changelog entries._\n';
  } else {
    for (const item of changelog) {
      md += `- **${escapeMdx(item.date || '—')}** [${escapeMdx(item.type || 'update')}]: ${escapeMdx(item.summary || '')}\n`;
    }
  }

  return md;
}

function main() {
  if (!fs.existsSync(JSON_PATH)) {
    console.error(`JSON not found: ${JSON_PATH}`);
    process.exit(1);
  }

  const data = JSON.parse(fs.readFileSync(JSON_PATH, 'utf8'));
  const meta = data.meta || {};
  const storybook = data.storybook || {};
  const components = storybook.components || {};
  const fileKey = meta.fileKey || '';

  const foundationsDir = path.join(STORYBOOK_SRC, 'foundations');
  const componentsDir = path.join(STORYBOOK_SRC, 'components');

  ensureDir(STORYBOOK_SRC);
  wipeGenerated(foundationsDir);
  wipeGenerated(componentsDir);
  ensureDir(foundationsDir);
  ensureDir(componentsDir);

  writeFile(path.join(STORYBOOK_SRC, 'Introduction.mdx'), generateIntroduction(meta, storybook));
  writeFile(path.join(foundationsDir, 'GlobalRules.mdx'), generateGlobalRules(storybook, meta));
  writeFile(path.join(foundationsDir, 'Feedback.mdx'), generateFeedback(storybook));
  writeFile(path.join(STORYBOOK_SRC, 'Changelog.mdx'), generateChangelog(meta, storybook));

  const names = Object.keys(components).sort((a, b) => a.localeCompare(b));
  for (const name of names) {
    const safe = name.replace(/[^\w.-]+/g, '_');
    writeFile(
      path.join(componentsDir, `${safe}.mdx`),
      generateComponentPage(name, components[name], fileKey),
    );
  }

  console.log(`Generated Storybook docs:`);
  console.log(`  Introduction + Changelog`);
  console.log(`  Foundations: 2`);
  console.log(`  Components: ${names.length}`);
  console.log(`  Output: ${STORYBOOK_SRC}`);
}

main();
