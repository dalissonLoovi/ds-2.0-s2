/**
 * loovi_tokens generator — seed JSON → Dart ThemeExtension.
 *
 * Source of truth: design-system-tokens.storybook.updated.v2.json
 *   - tokens.*                      (primitives, semantic, spacing, radius, …)
 *   - typography.*                  (50 text styles)
 *   - effects.*                     (elevation / pressed / focus)
 *   - meta.productTheme.tokens[]    (23 component tokens, aliasByMode)
 *
 * Why not dist/tokens.json: it is a flat list with no product-theme modes and no
 * component/* tokens (see FLUTTER-CONTRIBUTING.md). This script resolves every
 * product-theme alias down to the primitive value for each mode and fails if an
 * alias does not close or disagrees with tokens.component.
 *
 * Output (do not edit by hand):
 *   lib/src/generated/loovi_tokens.g.dart
 *   RESOLVED-APP-CLIENTE.md
 *
 * Usage: node packages/flutter_tokens/tool/generate_tokens.mjs   (or npm run flutter:tokens)
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const PKG = path.resolve(__dirname, '..');
const ROOT = path.resolve(PKG, '../..');
const SEED = path.join(ROOT, 'design-system-tokens.storybook.updated.v2.json');
const OUT_DART = path.join(PKG, 'lib/src/generated/loovi_tokens.g.dart');
const OUT_MD = path.join(PKG, 'RESOLVED-APP-CLIENTE.md');

const DEFAULT_MODE = 'app-cliente';
const FONT_WEIGHT = { regular: 400, medium: 500, semibold: 600, 'semi-bold': 600, bold: 700, extrabold: 800, 'extra-bold': 800 };

const seed = JSON.parse(fs.readFileSync(SEED, 'utf8'));
const T = seed.tokens;
const errors = [];
const warnings = [];

// ---------- helpers ----------
const getNode = (p) => p.split('/').reduce((n, k) => (n == null ? n : n[k]), T);

function leaves(obj, prefix = '', out = []) {
  for (const [k, v] of Object.entries(obj || {})) {
    if (k.startsWith('$')) continue;
    const p = prefix ? `${prefix}/${k}` : k;
    if (v && typeof v === 'object' && v.$value !== undefined) out.push({ path: p, value: v.$value, type: v.$type });
    else if (v && typeof v === 'object') leaves(v, p, out);
  }
  return out;
}

function camel(s) {
  let id = s
    .split(/[\/\-_]/)
    .filter(Boolean)
    .map((w, i) => (i === 0 ? w.toLowerCase() : w.charAt(0).toUpperCase() + w.slice(1).toLowerCase()))
    .join('');
  if (/^\d/.test(id)) id = `s${id}`;
  return id;
}
const pascal = (s) => camel(s).replace(/^./, (c) => c.toUpperCase());

/** "#RRGGBB" | "#RRGGBBAA" | "rgba(r,g,b,a)" → 0xAARRGGBB */
function toArgb(css) {
  const s = String(css).trim();
  let r, g, b, a = 1;
  let m;
  if ((m = s.match(/^#([0-9a-f]{6})([0-9a-f]{2})?$/i))) {
    r = parseInt(m[1].slice(0, 2), 16);
    g = parseInt(m[1].slice(2, 4), 16);
    b = parseInt(m[1].slice(4, 6), 16);
    if (m[2]) a = parseInt(m[2], 16) / 255;
  } else if ((m = s.match(/^rgba?\(\s*([\d.]+)\s*,\s*([\d.]+)\s*,\s*([\d.]+)\s*(?:,\s*([\d.]+)\s*)?\)$/i))) {
    [r, g, b] = [m[1], m[2], m[3]].map(Number);
    if (m[4] !== undefined) a = Number(m[4]);
  } else {
    throw new Error(`Cor não reconhecida: ${css}`);
  }
  const A = Math.round(a * 255);
  const hex = [A, r, g, b].map((n) => n.toString(16).padStart(2, '0').toUpperCase()).join('');
  return `0x${hex}`;
}
const dartColor = (css) => `Color(${toArgb(css)})`;
const num = (v) => {
  const n = typeof v === 'number' ? v : parseFloat(String(v));
  if (Number.isNaN(n)) throw new Error(`Número inválido: ${v}`);
  return Number.isInteger(n) ? `${n}.0` : String(n);
};
const weightOf = (v) => {
  const w = FONT_WEIGHT[String(v).toLowerCase()];
  if (!w) throw new Error(`Peso não reconhecido: ${v}`);
  return w;
};

/** Resolve a product-theme alias to { value, chain } down to the primitive. */
function resolveAlias(alias, mode, depth = 0) {
  if (depth > 10) throw new Error(`Alias em loop: ${alias}`);
  if (typeof alias === 'number') return { value: alias, chain: ['literal'] };
  const a = String(alias).trim();
  if (/^(#|rgba?\()/i.test(a)) return { value: a, chain: ['literal'] };
  if (/^\d+(\.\d+)?$/.test(a)) return { value: Number(a), chain: ['literal'] };
  // Alias to another product-theme token → follow its alias in the SAME mode.
  const ptRef = seed.meta.productTheme.tokens.find((t) => t.name === a);
  if (ptRef) {
    const next = resolveAlias(ptRef.aliasByMode[mode], mode, depth + 1);
    return { ...next, chain: [a, ...(next.chain || [])] };
  }
  const node = getNode(a);
  if (!node || node.$value === undefined) return { error: `alias não fecha: ${a}` };
  const v = node.$value;
  if (typeof v === 'string' && /^\{.+\}$/.test(v)) {
    const next = resolveAlias(v.slice(1, -1).replace(/\./g, '/'), mode, depth + 1);
    return { ...next, chain: [a, ...(next.chain || [])] };
  }
  if (v !== null && typeof v === 'object') return { error: `alias ${a} resolve para objeto, não para valor` };
  return { value: v, chain: [a] };
}

// ---------- foundation groups ----------
const groups = {
  color: leaves(T.color, 'color'),
  text: leaves(T.text, 'text'),
  feedback: leaves(T.feedback, 'feedback'),
  interactive: leaves(T.interactive, 'interactive'),
  primitive: leaves(T['primitive-colors'], 'primitive-colors'),
  spacing: leaves(T.spacing, 'spacing'),
  radius: leaves(T.border?.radius, 'border/radius'),
  borderWidth: leaves(T.border?.width, 'border/width'),
  breakpoint: leaves(T.breakpoint, 'breakpoint'),
};
const strip = (p, prefix) => p.slice(prefix.length + 1);

// ---------- typography ----------
const typo = [];
for (const s of leaves(seed.typography)) {
  if (s.type !== 'typography') continue;
  const v = s.value;
  typo.push({
    path: s.path,
    id: camel(s.path),
    size: parseFloat(v.fontSize),
    lineHeight: parseFloat(v.lineHeight),
    weight: weightOf(v.fontWeight),
    letterSpacing: parseFloat(v.letterSpacing || 0),
    family: v.fontFamily,
  });
}
if (typo.some((t) => t.family !== 'Poppins')) errors.push('Tipografia com família diferente de Poppins no seed.');

// ---------- effects ----------
const effects = [];
for (const [grp, items] of Object.entries(seed.effects || {})) {
  for (const [k, v] of Object.entries(items)) {
    if (v.$type !== 'shadow') continue;
    effects.push({ path: `${grp}/${k}`, id: camel(`${grp}-${k}`), layers: v.$value.filter((l) => l.visible !== false) });
  }
}

// ---------- product theme (component tokens) ----------
const pt = seed.meta.productTheme;
const modes = pt.modes;
if (!modes.includes(DEFAULT_MODE)) errors.push(`Mode ${DEFAULT_MODE} ausente em meta.productTheme.modes`);

const comp = {}; // component → [{ field, path, type, byMode: {mode: {value, chain}} }]
for (const t of pt.tokens) {
  const [, component, ...rest] = t.name.split('/');
  const field = camel(rest.join('/'));
  const kind = t.resolvedType === 'COLOR' ? 'color' : t.resolvedType === 'STRING' ? 'weight' : 'double';
  const byMode = {};
  for (const m of modes) {
    const alias = t.aliasByMode[m];
    if (alias === undefined) { errors.push(`${t.name}: sem alias no mode ${m}`); continue; }
    const r = resolveAlias(alias, m);
    if (r.error) { errors.push(`${t.name} [${m}]: ${r.error}`); continue; }
    byMode[m] = { alias, ...r };
    // cross-check with tokens.component (when present)
    const cnode = getNode(t.name);
    if (cnode && cnode.$value && typeof cnode.$value === 'object' && cnode.$value[m] !== undefined) {
      const expected = cnode.$value[m];
      const same =
        kind === 'color'
          ? toArgb(expected) === toArgb(r.value)
          : String(expected).toLowerCase() === String(r.value).toLowerCase();
      if (!same) {
        const msg = `${t.name} [${m}]: aliasByMode (${alias}) → ${r.value}, tokens.component → ${expected}`;
        // Default mode must agree; other modes: alias wins, mismatch is reported.
        (m === DEFAULT_MODE ? errors : warnings).push(msg);
      }
    }
  }
  (comp[component] ||= []).push({ field, path: t.name, kind, byMode, binds: t.binds });
}
const missingInTokensComponent = pt.tokens.filter((t) => !getNode(t.name)).map((t) => t.name);

if (errors.length) {
  console.error('loovi_tokens: buracos na resolução — nada foi gerado:\n  ' + errors.join('\n  '));
  process.exit(1);
}

// ---------- Dart emit ----------
const L = [];
const emit = (s = '') => L.push(s);
const modeId = (m) => camel(m);

emit('// GENERATED by packages/flutter_tokens/tool/generate_tokens.mjs — do not edit by hand.');
emit(`// Seed: design-system-tokens.storybook.updated.v2.json · revision ${seed.meta.storybookRevision}`);
emit('// ignore_for_file: constant_identifier_names, lines_longer_than_80_chars');
emit('');
emit("part of '../../loovi_tokens.dart';");
emit('');
emit(`/// Seed revision this file was generated from.`);
emit(`const String looviSeedRevision = '${seed.meta.storybookRevision}';`);
emit('');
emit('/// Product modes of the `product-theme` collection.');
emit('enum LooviProductMode {');
for (const m of modes) emit(`  /// \`${m}\`\n  ${modeId(m)}('${m}'),`);
emit('  ;');
emit('  const LooviProductMode(this.figmaName);');
emit('  /// Mode name in Figma / seed.');
emit('  final String figmaName;');
emit('}');
emit('');

/** Two seed paths that camelCase to the same Dart getter would silently shadow — fail loudly. */
function assertUniqueIds(scope, entries) {
  const seen = new Map();
  for (const e of entries) {
    if (seen.has(e.id)) throw new Error(`${scope}: '${seen.get(e.id)}' e '${e.path}' geram o mesmo identificador Dart '${e.id}'`);
    seen.set(e.id, e.path);
  }
}

function emitValueClass(className, doc, entries, typeName, toDart) {
  assertUniqueIds(className, entries);
  emit(`/// ${doc}`);
  emit(`@immutable`);
  emit(`class ${className} {`);
  emit(`  const ${className}._();`);
  for (const e of entries) {
    emit(`  /// \`${e.path}\` = ${String(e.value)}`);
    emit(`  ${typeName} get ${e.id} => ${toDart(e.value)};`);
  }
  emit(`  /// All tokens of this group by seed path (foundation gallery).`);
  emit(`  Map<String, ${typeName}> get all => {`);
  for (const e of entries) emit(`        '${e.path}': ${e.id},`);
  emit(`      };`);
  emit(`}`);
  emit('');
}

const colorGroup = (key, prefix, cls, doc) =>
  emitValueClass(cls, doc, groups[key].map((e) => ({ ...e, id: camel(strip(e.path, prefix)) })), 'Color', (v) => `const ${dartColor(v)}`);

colorGroup('color', 'color', 'LooviColors', 'Semantic colors (`color/*`).');
colorGroup('text', 'text', 'LooviTextColors', 'Text colors (`text/*`).');
colorGroup('feedback', 'feedback', 'LooviFeedbackColors', 'Feedback foreground colors (`feedback/*`).');
colorGroup('interactive', 'interactive', 'LooviInteractiveColors', 'Interaction state colors (`interactive/*`).');
colorGroup('primitive', 'primitive-colors', 'LooviPrimitiveColors', 'Raw palette (`primitive-colors/*`). Foundation gallery only — widgets use semantic tokens.');

emitValueClass('LooviSpacing', 'Spacing scale in logical px (`spacing/*`).',
  groups.spacing.map((e) => ({ ...e, id: camel(strip(e.path, 'spacing')) })), 'double', num);
emitValueClass('LooviRadius', 'Corner radius in logical px (`border/radius/*`). `full` = 9999 (pill).',
  groups.radius.map((e) => ({ ...e, id: camel(strip(e.path, 'border/radius')) })), 'double', num);
emitValueClass('LooviBorderWidth', 'Border widths in logical px (`border/width/*`).',
  groups.borderWidth.map((e) => ({ ...e, id: camel(strip(e.path, 'border/width')) })), 'double', num);
emitValueClass('LooviBreakpoints', 'Breakpoints in logical px (`breakpoint/*`). Not emitted in tokens.css yet.',
  groups.breakpoint.map((e) => ({ ...e, id: camel(strip(e.path, 'breakpoint')) })), 'double', num);

// typography
assertUniqueIds('LooviTypography', typo);
assertUniqueIds('LooviEffects', effects);
emit('/// Text styles (`typography/*`) — Poppins, bundled in this package.');
emit('/// Line height is applied with `TextLeadingDistribution.even`, like Figma.');
emit('@immutable');
emit('class LooviTypography {');
emit('  const LooviTypography._();');
emit("  /// Font family name declared in this package's pubspec.");
emit("  static const String fontFamily = 'Poppins';");
emit("  /// Package that ships the font files.");
emit("  static const String fontPackage = 'loovi_tokens';");
emit('  static TextStyle _s(double size, double lineHeight, FontWeight weight, double letterSpacing) => TextStyle(');
emit('        fontFamily: fontFamily,');
emit('        package: fontPackage,');
emit('        fontSize: size,');
emit('        height: lineHeight / size,');
emit('        leadingDistribution: TextLeadingDistribution.even,');
emit('        fontWeight: weight,');
emit('        letterSpacing: letterSpacing,');
emit('      );');
for (const t of typo) {
  emit(`  /// \`${t.path}\` — ${t.size}/${t.lineHeight} · ${t.weight}`);
  emit(`  TextStyle get ${t.id} => _s(${num(t.size)}, ${num(t.lineHeight)}, FontWeight.w${t.weight}, ${num(t.letterSpacing)});`);
}
emit('  /// All styles by seed path (foundation gallery).');
emit('  Map<String, TextStyle> get all => {');
for (const t of typo) emit(`        '${t.path}': ${t.id},`);
emit('      };');
emit('}');
emit('');

// effects
emit('/// One shadow layer from `effects/*`. `inner` layers cannot be a BoxShadow.');
emit('@immutable');
emit('class LooviShadow {');
emit('  const LooviShadow({required this.color, required this.offset, required this.blur, required this.spread, this.inner = false});');
emit('  final Color color;');
emit('  final Offset offset;');
emit('  /// Figma blur radius (= CSS blur).');
emit('  final double blur;');
emit('  final double spread;');
emit('  final bool inner;');
emit('  BoxShadow toBoxShadow() => BoxShadow(color: color, offset: offset, blurRadius: blur, spreadRadius: spread);');
emit('}');
emit('');
emit('/// Elevation and state effects (`effects/*`).');
emit('@immutable');
emit('class LooviEffects {');
emit('  const LooviEffects._();');
for (const e of effects) {
  const layers = e.layers
    .map((l) => `LooviShadow(color: ${dartColor(l.color)}, offset: Offset(${num(l.offset.x)}, ${num(l.offset.y)}), blur: ${num(l.radius)}, spread: ${num(l.spread)}${l.type === 'INNER_SHADOW' ? ', inner: true' : ''})`)
    .join(', ');
  emit(`  /// \`effects/${e.path}\``);
  emit(`  List<LooviShadow> get ${e.id} => const [${layers}];`);
}
emit('  /// Drop-shadow layers as BoxShadow (inner layers skipped).');
emit('  static List<BoxShadow> box(List<LooviShadow> layers) => [for (final l in layers) if (!l.inner) l.toBoxShadow()];');
emit('}');
emit('');

// component tokens per mode
const compClasses = [];
for (const [component, fields] of Object.entries(comp)) {
  const cls = `Loovi${pascal(component)}Tokens`;
  assertUniqueIds(cls, fields.map((f) => ({ id: f.field, path: f.path })));
  compClasses.push({ component, cls, field: camel(component) });
  const dartType = (k) => (k === 'color' ? 'Color' : k === 'weight' ? 'FontWeight' : 'double');
  emit(`/// Component tokens \`component/${component}/*\` (product-theme).`);
  emit('@immutable');
  emit(`class ${cls} {`);
  emit(`  const ${cls}({${fields.map((f) => `required this.${f.field}`).join(', ')}});`);
  for (const f of fields) {
    const byModeDoc = modes.map((m) => `${m} → ${f.byMode[m].alias}`).join(' · ');
    emit(`  /// \`${f.path}\` — ${f.binds || ''}`);
    emit(`  /// ${byModeDoc}`);
    emit(`  final ${dartType(f.kind)} ${f.field};`);
  }
  for (const m of modes) {
    const args = fields
      .map((f) => {
        const v = f.byMode[m].value;
        const dv = f.kind === 'color' ? dartColor(v) : f.kind === 'weight' ? `FontWeight.w${weightOf(v)}` : num(v);
        return `${f.field}: ${dv}`;
      })
      .join(', ');
    emit(`  /// Mode \`${m}\`.`);
    emit(`  static const ${cls} ${modeId(m)} = ${cls}(${args});`);
  }
  emit('}');
  emit('');
}

emit('/// All product-theme component tokens for one mode.');
emit('@immutable');
emit('class LooviComponentTokens {');
emit(`  const LooviComponentTokens({${compClasses.map((c) => `required this.${c.field}`).join(', ')}});`);
for (const c of compClasses) emit(`  final ${c.cls} ${c.field};`);
for (const m of modes) {
  emit(`  /// Mode \`${m}\`.`);
  emit(`  static const LooviComponentTokens ${modeId(m)} = LooviComponentTokens(${compClasses.map((c) => `${c.field}: ${c.cls}.${modeId(m)}`).join(', ')});`);
}
emit('  static LooviComponentTokens forMode(LooviProductMode mode) => switch (mode) {');
for (const m of modes) emit(`        LooviProductMode.${modeId(m)} => ${modeId(m)},`);
emit('      };');
emit('}');
emit('');

fs.mkdirSync(path.dirname(OUT_DART), { recursive: true });
fs.writeFileSync(OUT_DART, L.join('\n') + '\n', 'utf8');

// ---------- resolved table (markdown) ----------
const fmt = (f, v) => {
  if (f.kind === 'color') return `\`${toArgb(v)}\` (${v})`;
  if (f.kind === 'weight') return `${v} (${weightOf(v)})`;
  return Number(v) === 9999 ? '9999 (full)' : `${v}`;
};
const unit = (f) => (f.kind === 'color' ? 'cor ARGB' : f.kind === 'weight' ? 'FontWeight' : 'dp');
const md = [
  '# loovi_tokens — mode `app-cliente` resolvido',
  '',
  `> Gerado por \`tool/generate_tokens.mjs\` a partir do seed (revision \`${seed.meta.storybookRevision}\`). Não editar à mão.`,
  '',
  '| Path | Alias (seed) | Cadeia | Valor final | Unidade | Dart |',
  '| --- | --- | --- | --- | --- | --- |',
];
for (const c of compClasses) {
  for (const f of comp[c.component]) {
    const r = f.byMode[DEFAULT_MODE];
    md.push(`| \`${f.path}\` | \`${r.alias}\` | ${(r.chain || []).join(' → ') || '—'} | ${fmt(f, r.value)} | ${unit(f)} | \`tokens.component.${c.field}.${f.field}\` |`);
  }
}
md.push('');
md.push(`Tokens do product-theme ausentes em \`tokens.component\` do seed (só em \`meta.productTheme\`): ${missingInTokensComponent.length}.`);
for (const n of missingInTokensComponent) md.push(`- \`${n}\``);
md.push('');
md.push(`Divergências entre \`aliasByMode\` e \`tokens.component\` em outros modes (o alias ganha): ${warnings.length}.`);
for (const w of warnings) md.push(`- ${w}`);
md.push('');
fs.writeFileSync(OUT_MD, md.join('\n'), 'utf8');

const counts = Object.fromEntries(Object.entries(groups).map(([k, v]) => [k, v.length]));
console.log(
  `loovi_tokens: ${modes.length} modes · ${pt.tokens.length} component tokens · ${typo.length} text styles · ${effects.length} effects · ` +
    Object.entries(counts).map(([k, v]) => `${k} ${v}`).join(' · '),
);
console.log(`  → ${path.relative(ROOT, OUT_DART)}\n  → ${path.relative(ROOT, OUT_MD)}`);
for (const w of warnings) console.warn(`  aviso (alias ganha): ${w}`);
