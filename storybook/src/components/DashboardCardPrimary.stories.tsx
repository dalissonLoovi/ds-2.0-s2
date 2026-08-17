import type { Meta, StoryObj } from '@storybook/react';
import { DashboardCardPrimary } from '@ds/react/draft';

const meta = {
  title: 'Draft/DashboardCardPrimary',
  component: DashboardCardPrimary,
  tags: ['autodocs'],
  args: { label: 'DashboardCardPrimary' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof DashboardCardPrimary>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
