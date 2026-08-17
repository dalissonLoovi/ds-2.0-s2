import type { Meta, StoryObj } from '@storybook/react';
import { CardStacked } from '@ds/react/draft';

const meta = {
  title: 'Draft/CardStacked',
  component: CardStacked,
  tags: ['autodocs'],
  args: { label: 'CardStacked' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof CardStacked>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
