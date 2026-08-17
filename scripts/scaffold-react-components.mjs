/**
 * Scaffolds lightweight React components for remaining seed entries.
 * Skips CommentItem and already-handwritten W0 set.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const JSON_PATH = path.join(ROOT, 'design-system-tokens.storybook.updated.v2.json');
const SRC = path.join(ROOT, 'packages/react/src/components');

const SKIP = new Set([
  'Button',
  'Input',
  'ChipTag',
  'ChipClickable',
  'Alert',
  'Toast',
  'Modal',
  'CommentItem',
]);

function pascal(name) {
  return name;
}

function variantTypes(variants = {}) {
  return Object.entries(variants)
    .map(([key, values]) => {
      const union = (values || []).map((v) => `'${v}'`).join(' | ') || 'string';
      return `  ${key}?: ${union};`;
    })
    .join('\n');
}

function defaultsFromVariants(variants = {}) {
  return Object.entries(variants)
    .map(([key, values]) => {
      const first = values?.[0];
      if (first == null) return null;
      const lit = typeof first === 'boolean' ? first : `'${first}'`;
      return `  ${key} = ${lit},`;
    })
    .filter(Boolean)
    .join('\n');
}

function dataAttrs(variants = {}) {
  return Object.keys(variants)
    .map((key) => `      data-${key}={${key}}`)
    .join('\n');
}

function generate(name, meta) {
  const variants = meta.variants || {};
  const propsType = `${name}Props`;
  const css = `.root {
  box-sizing: border-box;
  font: inherit;
  color: var(--color-text-primary, #1a1a1a);
  background: var(--color-background-surface-0, #fff);
  border: 1px solid var(--color-border-2, #ebebeb);
  border-radius: var(--border-radius-200, 8px);
  padding: var(--spacing-200, 12px);
}

.title {
  margin: 0;
  font-weight: 600;
  font-size: 14px;
  line-height: 20px;
}

.meta {
  margin: 4px 0 0;
  font-size: 12px;
  line-height: 16px;
  color: var(--color-text-secondary, #5d6a80);
}
`;

  const tsx = `import type { HTMLAttributes, ReactNode } from 'react';
import { cx } from '../../utils/cx';
import styles from './${name}.module.css';

export type ${propsType} = HTMLAttributes<HTMLDivElement> & {
${variantTypes(variants)}
  label?: string;
  children?: ReactNode;
};

export function ${name}({
${defaultsFromVariants(variants)}
  label = '${name}',
  children,
  className,
  ...rest
}: ${propsType}) {
  return (
    <div
      className={cx(styles.root, className)}
${dataAttrs(variants)}
      {...rest}
    >
      <p className={styles.title}>{children ?? label}</p>
      <p className={styles.meta}>${name} · DS React</p>
    </div>
  );
}
`;

  const dir = path.join(SRC, name);
  fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(path.join(dir, `${name}.tsx`), tsx);
  fs.writeFileSync(path.join(dir, `${name}.module.css`), css);
}

function main() {
  const data = JSON.parse(fs.readFileSync(JSON_PATH, 'utf8'));
  const components = data.storybook?.components || {};
  let count = 0;
  for (const [name, meta] of Object.entries(components)) {
    if (SKIP.has(name)) continue;
    if (!/^[A-Z][A-Za-z0-9]+$/.test(name)) continue;
    generate(pascal(name), meta);
    count += 1;
  }
  console.log(`Scaffolded ${count} components under packages/react/src/components`);
}

main();
