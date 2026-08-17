import type { Meta, StoryObj } from '@storybook/react';
import { TabsPrimary } from '@ds/react/draft';

const meta = {
  title: 'Draft/TabsPrimary',
  component: TabsPrimary,
  tags: ['autodocs'],
  args: { label: 'TabsPrimary' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof TabsPrimary>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
