/**
 * Generate CSS custom properties from design-system-tokens.storybook.updated.v2.json
 * kebab-case path → --path-with-dashes
 *
 * Also emits font-family / font-weight / typography composites and copies Poppins
 * woff2 (latin + latin-ext) next to dist/tokens.css so Storybook and consumers
 * load the DS typeface without a per-component font-family.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '../../..');
const JSON_PATH = path.join(ROOT, 'design-system-tokens.storybook.updated.v2.json');
const OUT_DIR = path.resolve(__dirname, '../dist');
const FONTS_DIR = path.join(OUT_DIR, 'fonts');

const FONT_WEIGHT_MAP = {
  thin: '100',
  extralight: '200',
  'extra-light': '200',
  light: '300',
  regular: '400',
  medium: '500',
  semibold: '600',
  'semi-bold': '600',
  bold: '700',
  extrabold: '800',
  'extra-bold': '800',
  black: '900',
};

const POPPINS_WEIGHTS = [400, 500, 600, 700, 800];
const POPPINS_SUBSETS = [
  {
    id: 'latin-ext',
    unicodeRange:
      'U+0100-02BA,U+02BD-02C5,U+02C7-02CC,U+02CE-02D7,U+02DD-02FF,U+0304,U+0308,U+0329,U+1D00-1DBF,U+1E00-1E9F,U+1EF2-1EFF,U+2020,U+20A0-20AB,U+20AD-20C0,U+2113,U+2C60-2C7F,U+A720-A7FF',
  },
  {
    id: 'latin',
    unicodeRange:
      'U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+0304,U+0308,U+0329,U+2000-206F,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD',
  },
];

function toCssVar(tokenPath) {
  return `--${tokenPath.replace(/\//g, '-')}`;
}

function mapFontWeight(value) {
  const raw = String(value ?? '').trim();
  if (/^\d+$/.test(raw)) return raw;
  const mapped = FONT_WEIGHT_MAP[raw.toLowerCase()];
  return mapped || raw;
}

function walkLeafValues(obj, prefix, out, type) {
  for (const [key, value] of Object.entries(obj || {})) {
    if (key.startsWith('$')) continue;
    const next = prefix ? `${prefix}/${key}` : key;
    if (value && typeof value === 'object' && value.$value != null) {
      let v = value.$value;
      if (typeof v === 'object') continue;
      if (type === 'font-weight') {
        v = mapFontWeight(v);
      } else if (type === 'font-family') {
        v = `"${String(v).replace(/"/g, '')}", sans-serif`;
      } else if (typeof v === 'number') {
        v = type === 'color' ? String(v) : `${v}px`;
      }
      out.push({ path: next, cssVar: toCssVar(next), value: String(v), type });
    } else if (value && typeof value === 'object' && !('$value' in value) && !value.$type) {
      walkLeafValues(value, next, out, type);
    } else if (value && typeof value === 'object' && value.$type === 'color' && value.$value) {
      out.push({ path: next, cssVar: toCssVar(next), value: value.$value, type: 'color' });
    }
  }
}

function walkTypography(obj, prefix, out) {
  for (const [key, value] of Object.entries(obj || {})) {
    if (key.startsWith('$')) continue;
    const next = prefix ? `${prefix}/${key}` : key;
    if (value && typeof value === 'object' && value.$type === 'typography' && value.$value) {
      const t = value.$value;
      const family = t.fontFamily ? `"${String(t.fontFamily).replace(/"/g, '')}", sans-serif` : null;
      const weight = t.fontWeight != null ? mapFontWeight(t.fontWeight) : null;
      const size = t.fontSize != null ? String(t.fontSize) : null;
      const lineHeight = t.lineHeight != null ? String(t.lineHeight) : null;
      const letter = t.letterSpacing != null ? String(t.letterSpacing) : null;
      const base = `typography/${next}`;
      if (family) out.push({ path: `${base}/font-family`, cssVar: toCssVar(`${base}/font-family`), value: family, type: 'font-family' });
      if (weight) out.push({ path: `${base}/font-weight`, cssVar: toCssVar(`${base}/font-weight`), value: weight, type: 'font-weight' });
      if (size) out.push({ path: `${base}/font-size`, cssVar: toCssVar(`${base}/font-size`), value: size, type: 'font-size' });
      if (lineHeight) out.push({ path: `${base}/line-height`, cssVar: toCssVar(`${base}/line-height`), value: lineHeight, type: 'line-height' });
      if (letter) out.push({ path: `${base}/letter-spacing`, cssVar: toCssVar(`${base}/letter-spacing`), value: letter, type: 'letter-spacing' });
      if (weight && size && lineHeight) {
        const shorthand = `${weight} ${size}/${lineHeight} var(--font-family-base, "Poppins", sans-serif)`;
        out.push({ path: base, cssVar: toCssVar(base), value: shorthand, type: 'typography' });
      }
    } else if (value && typeof value === 'object') {
      walkTypography(value, next, out);
    }
  }
}

function resolveFontFile(subset, weight) {
  const spec = `@fontsource/poppins/files/poppins-${subset}-${weight}-normal.woff2`;
  try {
    return fileURLToPath(import.meta.resolve(spec));
  } catch {
    return null;
  }
}

function copyPoppinsFonts() {
  fs.mkdirSync(FONTS_DIR, { recursive: true });
  const copied = [];
  for (const subset of POPPINS_SUBSETS) {
    for (const weight of POPPINS_WEIGHTS) {
      const from = resolveFontFile(subset.id, weight);
      if (!from || !fs.existsSync(from)) {
        throw new Error(`Poppins woff2 missing: poppins-${subset.id}-${weight}-normal.woff2 (install @fontsource/poppins)`);
      }
      const name = `poppins-${subset.id}-${weight}-normal.woff2`;
      fs.copyFileSync(from, path.join(FONTS_DIR, name));
      copied.push({ subset: subset.id, unicodeRange: subset.unicodeRange, weight, name });
    }
  }
  return copied;
}

function fontFaceCss(copied) {
  const blocks = copied.map(
    (f) => `@font-face {
  font-family: "Poppins";
  font-style: normal;
  font-weight: ${f.weight};
  font-display: swap;
  src: url("./fonts/${f.name}") format("woff2");
  unicode-range: ${f.unicodeRange};
}`,
  );
  return blocks.join('\n\n');
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
  if (tokens['font-family']) {
    walkLeafValues(tokens['font-family'], 'font-family', flat, 'font-family');
  }
  if (tokens.font?.family) {
    walkLeafValues(tokens.font.family, 'font/family', flat, 'font-family');
  }
  if (tokens['font-weight']) {
    walkLeafValues(tokens['font-weight'], 'font-weight', flat, 'font-weight');
  }

  walkTypography(data.typography, '', flat);

  const byVar = new Map();
  for (const item of flat) byVar.set(item.cssVar, item);
  const unique = [...byVar.values()];

  if (!unique.some((t) => t.cssVar === '--font-family-base')) {
    unique.unshift({
      path: 'font-family/base',
      cssVar: '--font-family-base',
      value: '"Poppins", sans-serif',
      type: 'font-family',
    });
  }

  fs.mkdirSync(OUT_DIR, { recursive: true });
  const copied = copyPoppinsFonts();

  const cssLines = [
    '/* AUTO-GENERATED from design-system-tokens.storybook.updated.v2.json — do not edit */',
    fontFaceCss(copied),
    '',
    ':root {',
    ...unique.map((t) => `  ${t.cssVar}: ${t.value};`),
    '  font-family: var(--font-family-base);',
    '}',
    '',
    'html, body {',
    '  font-family: var(--font-family-base);',
    '}',
    '',
  ];
  fs.writeFileSync(path.join(OUT_DIR, 'tokens.css'), cssLines.join('\n'), 'utf8');
  fs.writeFileSync(path.join(OUT_DIR, 'tokens.json'), JSON.stringify(unique, null, 2), 'utf8');

  const css = cssLines.join('\n');
  if (!css.includes('font-family: "Poppins"') || !css.includes('--font-family-base')) {
    throw new Error('Poppins / --font-family-base missing from generated tokens.css');
  }

  console.log(`@ds/tokens: wrote ${unique.length} custom properties + ${copied.length} Poppins files → dist/tokens.css`);
}

main();
