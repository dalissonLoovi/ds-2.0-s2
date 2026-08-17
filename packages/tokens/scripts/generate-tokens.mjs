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

function walkLeafValues(obj, prefix, out, type) {
  for (const [key, value] of Object.entries(obj || {})) {
    if (key.startsWith('$')) continue;
    const next = prefix ? `${prefix}/${key}` : key;
    if (value && typeof value === 'object' && value.$value != null) {
      let v = value.$value;
      if (typeof v === 'number') {
        // dimensions default to px; unitless ratios stay numeric strings
        v = type === 'color' || type === 'font-weight' ? String(v) : `${v}px`;
      }
      out.push({ path: next, cssVar: toCssVar(next), value: String(v), type });
    } else if (value && typeof value === 'object' && !('$value' in value) && !value.$type) {
      walkLeafValues(value, next, out, type);
    } else if (value && typeof value === 'object' && value.$type === 'color' && value.$value) {
      out.push({ path: next, cssVar: toCssVar(next), value: value.$value, type: 'color' });
    }
  }
}

function main() {
  const data = JSON.parse(fs.readFileSync(JSON_PATH, 'utf8'));
  const tokens = data.tokens || {};
  const flat = [];

  walkLeafValues(tokens.color, 'color', flat, 'color');
  walkLeafValues(tokens.text, 'text', flat, 'color');
  walkLeafValues(tokens.feedback, 'feedback', flat, 'color');
  walkLeafValues(tokens.interactive, 'interactive', flat, 'color');

  if (tokens.spacing) {
    walkLeafValues(tokens.spacing, 'spacing', flat, 'spacing');
  }
  if (tokens.border?.radius) {
    walkLeafValues(tokens.border.radius, 'border/radius', flat, 'radius');
  }
  if (tokens.border?.width) {
    walkLeafValues(tokens.border.width, 'border/width', flat, 'border-width');
  }

  // de-dupe by cssVar (last wins)
  const byVar = new Map();
  for (const item of flat) byVar.set(item.cssVar, item);
  const unique = [...byVar.values()];

  fs.mkdirSync(OUT_DIR, { recursive: true });

  const cssLines = [
    '/* AUTO-GENERATED from design-system-tokens.storybook.updated.v2.json — do not edit */',
    ':root {',
    ...unique.map((t) => `  ${t.cssVar}: ${t.value};`),
    '}',
    '',
  ];
  fs.writeFileSync(path.join(OUT_DIR, 'tokens.css'), cssLines.join('\n'), 'utf8');
  fs.writeFileSync(path.join(OUT_DIR, 'tokens.json'), JSON.stringify(unique, null, 2), 'utf8');

  console.log(`@ds/tokens: wrote ${unique.length} custom properties → dist/tokens.css`);
}

main();
