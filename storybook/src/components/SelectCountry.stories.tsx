import type { Meta, StoryObj } from '@storybook/react';
import { SelectCountry } from '@ds/react/draft';

const meta = {
  title: 'Draft/SelectCountry',
  component: SelectCountry,
  tags: ['autodocs'],
  args: { label: 'SelectCountry' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof SelectCountry>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
