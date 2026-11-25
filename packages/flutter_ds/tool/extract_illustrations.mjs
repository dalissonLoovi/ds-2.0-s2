/**
 * Illustration assets for LooviIllustration (Flutter) and <Illustration> (React).
 *
 * Input: SVG exports of the illustration COMPONENTs on Figma page
 * "Ilustrações e animações" (4326:1764) of `[DS] 2.0 - S2`, one file per node,
 * named by node id with ":" → "-" (e.g. 5128-175.svg). Both export flavours
 * are accepted:
 *   - Plugin API `exportAsync({format:'SVG_STRING'})` (component at the root);
 *   - MCP/REST render export, which wraps the component in its section
 *     background — only the `<g id="{figmaName}">` subtree is kept.
 *
 * Usage:
 *   node packages/flutter_ds/tool/extract_illustrations.mjs <dir-with-raw-exports>
 *   node packages/flutter_ds/tool/generate_illustrations.mjs
 *
 * Cleaning: numbers rounded to 2 decimals (3 in transforms), Figma layer ids
 * stripped, only ids referenced by url(#…)/href kept, unreferenced <defs>
 * dropped, attribute-less <g> wrappers collapsed. viewBox is preserved.
 *
 * Entries flagged `legacyAsset` in tool/illustrations.json already ship a
 * hand-cleaned file that widgets depend on: it is NOT overwritten; the new
 * export is only compared against it and differences are reported.
 *
 * Output (do not edit by hand):
 *   assets/illustrations/<group>/<name>.svg
 *   assets/illustrations/<group>/<name>.flutter.svg — only for art using SVG
 *     filters (unsupported by flutter_svg); see flutterSafeSvg()
 *   tool/illustrations.json (width/height refreshed from the viewBox)
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const PKG = path.resolve(__dirname, '..');
const MANIFEST = path.join(__dirname, 'illustrations.json');

// ---------------------------------------------------------------- mini XML

/** Parse the (simple, Figma-generated) SVG into a tree. No CDATA/comments. */
export function parseXml(src) {
  const root = { tag: '#root', attrs: [], children: [] };
  const stack = [root];
  const re = /<(\/?)([a-zA-Z][\w:-]*)((?:\s+[\w:-]+="[^"]*")*)\s*(\/?)>|([^<]+)/g;
  let m;
  while ((m = re.exec(src))) {
    const [, close, tag, rawAttrs, selfClose, text] = m;
    const top = stack[stack.length - 1];
    if (text !== undefined) {
      if (text.trim()) top.children.push({ text: text.trim() });
      continue;
    }
    if (close) {
      if (top.tag !== tag) throw new Error(`tag mismatch: </${tag}> closes <${top.tag}>`);
      stack.pop();
      continue;
    }
    const attrs = [...(rawAttrs || '').matchAll(/([\w:-]+)="([^"]*)"/g)].map((a) => [a[1], a[2]]);
    const node = { tag, attrs, children: [] };
    top.children.push(node);
    if (!selfClose) stack.push(node);
  }
  if (stack.length !== 1) throw new Error('unbalanced XML');
  return root;
}

export function serialize(node) {
  if (node.text !== undefined) return node.text;
  const attrs = node.attrs.map(([k, v]) => ` ${k}="${v}"`).join('');
  if (!node.children.length) return `<${node.tag}${attrs}/>`;
  return `<${node.tag}${attrs}>\n${node.children.map(serialize).join('\n')}\n</${node.tag}>`;
}

const attr = (n, k) => n.attrs?.find((a) => a[0] === k)?.[1];
function* walk(n) {
  yield n;
  for (const c of n.children || []) yield* walk(c);
}

// ---------------------------------------------------------------- cleaning

const NUM = /-?(?:\d+\.\d*|\.\d+|\d+)(?:e[-+]?\d+)?/gi;
function roundNumbers(value, decimals) {
  return value.replace(NUM, (s) => {
    if (!/[.e]/i.test(s)) return s;
    const r = Number(Number(s).toFixed(decimals));
    return String(Object.is(r, -0) ? 0 : r);
  });
}
const NUMERIC_ATTRS = new Set([
  'd', 'x', 'y', 'width', 'height', 'cx', 'cy', 'r', 'rx', 'ry', 'x1', 'x2', 'y1', 'y2',
  'fx', 'fy', 'offset', 'opacity', 'fill-opacity', 'stroke-opacity', 'stop-opacity',
  'stroke-width', 'stroke-miterlimit', 'stdDeviation', 'flood-opacity', 'points', 'viewBox',
]);
const TRANSFORM_ATTRS = new Set(['transform', 'gradientTransform', 'patternTransform']);

const refsIn = (v) => [...v.matchAll(/url\(#([^)]+)\)/g)].map((m) => m[1]).concat(v.startsWith('#') ? [v.slice(1)] : []);

/** Clean one component subtree + its defs into a standalone SVG string. */
export function cleanSvg(raw, figmaName) {
  const doc = parseXml(raw);
  const svg = doc.children.find((n) => n.tag === 'svg');
  if (!svg) throw new Error('no <svg> root');

  // Locate the component content: the wrapper group named after the component
  // (render export) or the whole root (plugin export).
  const escaped = figmaName.replace(/&/g, '&amp;');
  // Sections often share the component name (Figma then dedupes the id as
  // `name_2`), so take the innermost match.
  const isWrapperId = (id) => id === escaped || (id?.startsWith(`${escaped}_`) && /^\d+$/.test(id.slice(escaped.length + 1)));
  const wrapper = [...walk(svg)].filter((n) => n.tag === 'g' && isWrapperId(attr(n, 'id'))).pop();
  const content = wrapper ? wrapper.children : svg.children.filter((n) => n.tag !== 'defs');
  const defsPool = new Map();
  for (const d of [...walk(svg)].filter((n) => n.tag === 'defs')) {
    for (const c of d.children) if (attr(c, 'id')) defsPool.set(attr(c, 'id'), c);
  }

  // Referenced ids (transitively through defs).
  const used = new Set();
  const queue = [...content];
  while (queue.length) {
    const n = queue.pop();
    for (const node of walk(n)) {
      for (const [k, v] of node.attrs || []) {
        if (k === 'id') continue;
        for (const id of refsIn(v)) {
          if (used.has(id)) continue;
          used.add(id);
          if (defsPool.has(id)) queue.push(defsPool.get(id));
        }
      }
    }
  }
  // Masks/clipPaths defined inline (Figma puts <mask> next to its target).
  const defs = [...defsPool.entries()].filter(([id]) => used.has(id)).map(([, n]) => n);

  const tidy = (n) => {
    if (n.text !== undefined) return [n];
    n.attrs = n.attrs
      .filter(([k, v]) => !(k === 'id' && !used.has(v)))
      .map(([k, v]) => [k, TRANSFORM_ATTRS.has(k) ? roundNumbers(v, 3) : NUMERIC_ATTRS.has(k) ? roundNumbers(v, 2) : v]);
    n.children = n.children.flatMap(tidy);
    // Collapse attribute-less groups; drop empty groups.
    if (n.tag === 'g' && !n.attrs.length) return n.children;
    if (n.tag === 'g' && !n.children.length) return [];
    return [n];
  };
  const body = content.flatMap((c) => tidy(structuredClone(c)));
  const cleanDefs = defs.flatMap((c) => tidy(structuredClone(c)));

  const vb = attr(svg, 'viewBox');
  const [, , w, h] = vb.split(/\s+/).map(Number);
  const out = [
    `<svg width="${w}" height="${h}" viewBox="${vb}" fill="none" xmlns="http://www.w3.org/2000/svg">`,
    ...body.map(serialize),
    ...(cleanDefs.length ? [serialize({ tag: 'defs', attrs: [], children: cleanDefs })] : []),
    '</svg>',
    '',
  ].join('\n');
  return { svg: out, width: w, height: h };
}

/**
 * flutter_svg ignores SVG filters, so a Figma LAYER_BLUR (`<g filter>` →
 * feGaussianBlur around a solid shape) paints as a hard-edged blob. Returns a
 * copy where each blurred solid shape becomes an ellipse with a radial
 * gradient that approximates the blur (shape bbox grown by 2σ, opacity falling
 * to 0.5 at the original edge and 0 at the grown edge), or null when the SVG
 * has no such blur. Browsers keep using the faithful file.
 */
export function flutterSafeSvg(svgText) {
  const doc = parseXml(svgText);
  const svg = doc.children.find((n) => n.tag === 'svg');
  const defs = svg.children.find((n) => n.tag === 'defs');
  if (!defs) return null;
  const blurs = new Map();
  for (const f of defs.children.filter((n) => n.tag === 'filter')) {
    const blur = f.children.find((c) => c.tag === 'feGaussianBlur');
    if (blur) blurs.set(attr(f, 'id'), Number(attr(blur, 'stdDeviation')));
  }
  if (!blurs.size) return null;
  let i = 0;
  const replaced = new Set();
  for (const g of [...walk(svg)].filter((n) => n.tag === 'g' && attr(n, 'filter'))) {
    const id = refsIn(attr(g, 'filter'))[0];
    const shape = g.children.length === 1 ? g.children[0] : null;
    const color = shape && attr(shape, 'fill');
    if (!blurs.has(id) || shape.tag !== 'path' || !/^#[0-9A-Fa-f]{6}$/.test(color ?? '')) continue;
    // Bbox from the absolute path coordinates (Figma exports absolute M/L/C/H/V/Z).
    const xs = [];
    const ys = [];
    for (const [, cmd, args] of attr(shape, 'd').matchAll(/([MLCHVZ])([^MLCHVZ]*)/gi)) {
      const nums = (args.match(NUM) || []).map(Number);
      if (cmd === 'H') xs.push(...nums);
      else if (cmd === 'V') ys.push(...nums);
      else nums.forEach((v, k) => (k % 2 ? ys : xs).push(v));
    }
    const sigma = blurs.get(id);
    const [x0, x1, y0, y1] = [Math.min(...xs), Math.max(...xs), Math.min(...ys), Math.max(...ys)];
    const [rx, ry] = [(x1 - x0) / 2, (y1 - y0) / 2];
    const edge = Math.min(rx, ry) / (Math.min(rx, ry) + 2 * sigma);
    const gid = `flutter_blur_${i++}`;
    const r2 = (v) => String(Number(v.toFixed(2)));
    g.attrs = g.attrs.filter(([k]) => k !== 'filter');
    g.children = [{
      tag: 'ellipse',
      attrs: [['cx', r2((x0 + x1) / 2)], ['cy', r2((y0 + y1) / 2)], ['rx', r2(rx + 2 * sigma)], ['ry', r2(ry + 2 * sigma)], ['fill', `url(#${gid})`]],
      children: [],
    }];
    const stop = (offset, opacity) => ({ tag: 'stop', attrs: [['offset', r2(offset)], ['stop-color', color], ['stop-opacity', r2(opacity)]], children: [] });
    defs.children.push({
      tag: 'radialGradient',
      attrs: [['id', gid]],
      children: [stop(0, 0.9), stop(edge * 0.6, 0.8), stop(edge, 0.5), stop(edge + (1 - edge) * 0.5, 0.12), stop(1, 0)],
    });
    replaced.add(id);
  }
  if (!replaced.size) return null;
  defs.children = defs.children.filter((n) => !(n.tag === 'filter' && replaced.has(attr(n, 'id'))));
  return `${svg.children.length ? serialize(svg) : ''}\n`;
}

/** Structural signature used to compare two SVGs of the same artwork. */
export function signature(svgText) {
  const ds = [...svgText.matchAll(/ d="([^"]*)"/g)].map((m) => m[1]);
  let sum = 0;
  for (const d of ds) for (const x of d.match(NUM) || []) sum += Math.abs(Number(x));
  const count = (re) => (svgText.match(re) || []).length;
  return {
    paths: ds.length,
    dSum: Math.round(sum),
    gradients: count(/<(linear|radial)Gradient/g),
    masks: count(/<mask /g),
    filters: count(/<filter /g),
    fills: [...new Set([...svgText.matchAll(/(?:fill|stop-color|stroke)="(#[0-9A-Fa-f]{6})"/g)].map((m) => m[1].toUpperCase()))].sort().join(','),
  };
}

// ---------------------------------------------------------------- main

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const RAW = process.argv[2];
  if (!RAW) throw new Error('Usage: node tool/extract_illustrations.mjs <dir-with-raw-exports>');
  const manifest = JSON.parse(fs.readFileSync(MANIFEST, 'utf8'));
  const report = [];
  for (const it of manifest.illustrations) {
    const file = path.join(RAW, `${it.nodeId.replace(':', '-')}.svg`);
    if (!fs.existsSync(file)) {
      report.push(`MISSING export ${it.name} (${it.nodeId})`);
      continue;
    }
    const { svg, width, height } = cleanSvg(fs.readFileSync(file, 'utf8'), it.figmaName);
    it.width = width;
    it.height = height;
    const dest = path.join(PKG, it.asset);
    if (it.legacyAsset && fs.existsSync(dest)) {
      const a = signature(fs.readFileSync(dest, 'utf8'));
      const b = signature(svg);
      const diff = Object.keys(a).filter((k) => (k === 'dSum' ? Math.abs(a[k] - b[k]) > a[k] * 0.001 + 2 : a[k] !== b[k]));
      report.push(
        diff.length
          ? `KEPT legacy ${it.asset} — differs from new export: ${diff.map((k) => `${k} ${a[k]} → ${b[k]}`).join('; ')}`
          : `KEPT legacy ${it.asset} — matches new export`,
      );
      continue;
    }
    fs.mkdirSync(path.dirname(dest), { recursive: true });
    fs.writeFileSync(dest, svg);
    const flutterSvg = flutterSafeSvg(svg);
    if (flutterSvg) {
      it.flutterAsset = it.asset.replace(/\.svg$/, '.flutter.svg');
      fs.writeFileSync(path.join(PKG, it.flutterAsset), flutterSvg);
      report.push(`FLUTTER variant ${it.flutterAsset} — layer blur approximated with radial gradients`);
    } else {
      delete it.flutterAsset;
    }
  }
  fs.writeFileSync(MANIFEST, `${JSON.stringify(manifest, null, 2)}\n`);
  console.log(report.join('\n') || 'ok');
  console.log(`${manifest.illustrations.length} illustrations in manifest`);
}
