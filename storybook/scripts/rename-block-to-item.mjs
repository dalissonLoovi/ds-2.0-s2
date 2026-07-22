/**
 * String-replace *Block → *Item names in docs (preserves JSON formatting).
 * node storybook/scripts/rename-block-to-item.mjs
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '../..');

const RENAMES = [
  ['VerificationCodeInputBlock', 'VerificationCodeInputItem'],
  ['DatePickerSelectBlock', 'DatePickerSelectItem'],
  ['CommentBlock', 'CommentItem'],
  ['ImageBlock', 'ImageItem'],
  ['FileUploaderBlock', 'FileUploaderDropzoneItem'],
];

const FILES = [
  'design-system-tokens.storybook.updated.v2.json',
  'design-system-storybook.md',
  'AGENTS.md',
];

function applyRenames(text) {
  let out = text;
  for (const [from, to] of RENAMES) out = out.split(from).join(to);
  return out;
}

const report = [];
for (const rel of FILES) {
  const full = path.join(ROOT, rel);
  if (!fs.existsSync(full)) {
    report.push({ rel, skipped: true });
    continue;
  }
  const before = fs.readFileSync(full, 'utf8');
  const after = applyRenames(before);
  if (after !== before) {
    fs.writeFileSync(full, after, 'utf8');
    let count = 0;
    for (const [from] of RENAMES) {
      const m = before.split(from).length - 1;
      count += m;
    }
    report.push({ rel, updated: true, replacementsApprox: count });
  } else {
    report.push({ rel, updated: false });
  }
}

const dlDir = path.join(process.env.USERPROFILE || '', 'Downloads');
for (const name of [
  'design-system-tokens.storybook.updated.v2.json',
  'design-system-storybook.md',
]) {
  const src = path.join(ROOT, name);
  const dest = path.join(dlDir, name);
  if (fs.existsSync(src) && fs.existsSync(path.dirname(dest))) {
    fs.copyFileSync(src, dest);
    report.push({ copied: dest });
  }
}

console.log(JSON.stringify({ renames: Object.fromEntries(RENAMES), report }, null, 2));
