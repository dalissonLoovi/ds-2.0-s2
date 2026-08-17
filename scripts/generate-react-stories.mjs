/**
 * Generate CSF3 autodocs stories for scaffolded draft components.
 * Polished W0 stories are handwritten and import from @ds/react.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const COMP_DIR = path.join(ROOT, 'packages/react/src/components');
const OUT_DIR = path.join(ROOT, 'storybook/src/components');

const HANDWRITTEN = new Set([
  'Alert',
  'Autocomplete',
  'Badge',
  'Banner',
  'BottomSheet',
  'BottomSheetCheckItem',
  'BottomSheetHeader',
  'Button',
  'Checkbox',
  'ChipClickable',
  'ChipTag',
  'DatePickerSelect',
  'DatePickerSelectItem',
  'Input',
  'InputDatePicker',
  'InputNumber',
  'InputPassword',
  'InputSelect',
  'InputTextArea',
  'Link',
  'LoadingSpinner',
  'Modal',
  'Overlay',
  'ProgressBar',
  'RadioButton',
  'RadioButtonCard',
  'SearchBar',
  'SelectCountry',
  'Switch',
  'Toast',
  'Tooltip',
  'TooltipRich',
  'VerificationCodeInput',
  'VerificationCodeInputItem',
]);

function story(name) {
  return `import type { Meta, StoryObj } from '@storybook/react';
import { ${name} } from '@ds/react/draft';

const meta = {
  title: 'Draft/${name}',
  component: ${name},
  tags: ['autodocs'],
  args: { label: '${name}' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from \`@ds/react/draft\`.',
      },
    },
  },
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
    if (name.startsWith('_')) continue;
    fs.writeFileSync(path.join(OUT_DIR, `${name}.stories.tsx`), story(name));
    count += 1;
  }
  console.log(`Wrote ${count} draft story files`);
}

main();
