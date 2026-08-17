import type { Meta, StoryObj } from '@storybook/react';
import { VehicleConfirmCard } from '@ds/react/draft';

const meta = {
  title: 'Draft/VehicleConfirmCard',
  component: VehicleConfirmCard,
  tags: ['autodocs'],
  args: { label: 'VehicleConfirmCard' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof VehicleConfirmCard>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
