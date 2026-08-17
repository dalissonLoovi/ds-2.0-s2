import type { Meta, StoryObj } from '@storybook/react';
import { CardElevatedItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/CardElevatedItem',
  component: CardElevatedItem,
  tags: ['autodocs'],
  args: { label: 'CardElevatedItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof CardElevatedItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
