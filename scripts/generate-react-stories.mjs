/**
 * Generate CSF3 autodocs stories for scaffolded @ds/react components.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const COMP_DIR = path.join(ROOT, 'packages/react/src/components');
const OUT_DIR = path.join(ROOT, 'storybook/src/components');

const HANDWRITTEN = new Set([
  'Button',
  'Input',
  'ChipTag',
  'ChipClickable',
  'Alert',
  'Toast',
  'Modal',
]);

function story(name) {
  return `import type { Meta, StoryObj } from '@storybook/react';
import { ${name} } from '@ds/react';

const meta = {
  title: 'Components/${name}',
  component: ${name},
  tags: ['autodocs'],
  args: { label: '${name}' },
} satisfies Meta<typeof ${name}>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
`;
}

function main() {
  const names = fs
    .readdirSync(COMP_DIR)
    .filter((n) => fs.statSync(path.join(COMP_DIR, n)).isDirectory())
    .sort();
  let count = 0;
  for (const name of names) {
    if (HANDWRITTEN.has(name)) continue;
    const out = path.join(OUT_DIR, `${name}.stories.tsx`);
    fs.writeFileSync(out, story(name));
    count += 1;
  }
  console.log(`Wrote ${count} story files`);
}

main();
