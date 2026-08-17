import type { Meta, StoryObj } from '@storybook/react';
import { InputSelect } from '@ds/react/draft';

const meta = {
  title: 'Draft/InputSelect',
  component: InputSelect,
  tags: ['autodocs'],
  args: { label: 'InputSelect' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof InputSelect>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
