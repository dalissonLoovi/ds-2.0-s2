import type { Meta, StoryObj } from '@storybook/react';
import { CardFilledItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/CardFilledItem',
  component: CardFilledItem,
  tags: ['autodocs'],
  args: { label: 'CardFilledItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof CardFilledItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
