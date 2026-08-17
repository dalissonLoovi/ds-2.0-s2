import type { Meta, StoryObj } from '@storybook/react';
import { CardOutlinedItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/CardOutlinedItem',
  component: CardOutlinedItem,
  tags: ['autodocs'],
  args: { label: 'CardOutlinedItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof CardOutlinedItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
