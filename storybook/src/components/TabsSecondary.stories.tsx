import type { Meta, StoryObj } from '@storybook/react';
import { TabsSecondary } from '@ds/react/draft';

const meta = {
  title: 'Draft/TabsSecondary',
  component: TabsSecondary,
  tags: ['autodocs'],
  args: { label: 'TabsSecondary' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof TabsSecondary>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
