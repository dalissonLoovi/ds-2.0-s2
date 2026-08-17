import type { Meta, StoryObj } from '@storybook/react';
import { TabItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/TabItem',
  component: TabItem,
  tags: ['autodocs'],
  args: { label: 'TabItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof TabItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
