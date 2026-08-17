/**
 * Generate CSS custom properties from design-system-tokens.storybook.updated.v2.json
 * kebab-case path → --path-with-dashes
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '../../..');
const JSON_PATH = path.join(ROOT, 'design-system-tokens.storybook.updated.v2.json');
const OUT_DIR = path.resolve(__dirname, '../dist');

function toCssVar(tokenPath) {
  return `--${tokenPath.replace(/\//g, '-')}`;
}

function walkColors(obj, prefix, out) {
  for (const [key, value] of Object.entries(obj || {})) {
    if (key.startsWith('$')) continue;
    const next = prefix ? `${prefix}/${key}` : key;
    if (value && typeof value === 'object' && value.$type === 'color' && value.$value) {
      out.push({ path: next, cssVar: toCssVar(next), value: value.$value, type: 'color' });
    } else if (value && typeof value === 'object' && !value.$type) {
      walkColors(value, next, out);
    }
  }
}

function walkDimensionGroup(obj, prefix, out, type) {
  for (const [key, value] of Object.entries(obj || {})) {
    if (key.startsWith('$')) continue;
    const next = prefix ? `${prefix}/${key}` : key;
    if (value && typeof value === 'object' && value.$value != null) {
      let v = value.$value;
      if (typeof v === 'number') v = `${v}px`;
      out.push({ path: next, cssVar: toCssVar(next), value: String(v), type });
    } else if (value && typeof value === 'object' && !('$value' in value)) {
      walkDimensionGroup(value, next, out, type);
    }
  }
}

function main() {
  const data = JSON.parse(fs.readFileSync(JSON_PATH, 'utf8'));
  const tokens = data.tokens || {};
  const flat = [];

  walkColors(tokens.color, 'color', flat);

  if (tokens.spacing) {
    for (const [key, value] of Object.entries(tokens.spacing)) {
      if (value?.$value != null) {
        let v = value.$value;
        if (typeof v === 'number') v = `${v}px`;
        flat.push({
          path: `spacing/${key}`,
          cssVar: toCssVar(`spacing/${key}`),
          value: String(v),
          type: 'spacing',
        });
      }
    }
  }

  if (tokens.border?.radius) {
    walkDimensionGroup(tokens.border.radius, 'border/radius', flat, 'radius');
  }
  if (tokens.border?.width) {
    walkDimensionGroup(tokens.border.width, 'border/width', flat, 'border-width');
  }

  fs.mkdirSync(OUT_DIR, { recursive: true });

  const cssLines = [
    '/* AUTO-GENERATED from design-system-tokens.storybook.updated.v2.json — do not edit */',
    ':root {',
    ...flat.map((t) => `  ${t.cssVar}: ${t.value};`),
    '}',
    '',
  ];
  fs.writeFileSync(path.join(OUT_DIR, 'tokens.css'), cssLines.join('\n'), 'utf8');
  fs.writeFileSync(path.join(OUT_DIR, 'tokens.json'), JSON.stringify(flat, null, 2), 'utf8');

  console.log(`@ds/tokens: wrote ${flat.length} custom properties → dist/tokens.css`);
}

main();
