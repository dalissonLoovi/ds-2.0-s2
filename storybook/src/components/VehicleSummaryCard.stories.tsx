import type { Meta, StoryObj } from '@storybook/react';
import { VehicleSummaryCard } from '@ds/react/draft';

const meta = {
  title: 'Draft/VehicleSummaryCard',
  component: VehicleSummaryCard,
  tags: ['autodocs'],
  args: { label: 'VehicleSummaryCard' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof VehicleSummaryCard>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
