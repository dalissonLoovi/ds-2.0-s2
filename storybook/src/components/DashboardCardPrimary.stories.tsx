import type { Meta, StoryObj } from '@storybook/react';
import { DashboardCardPrimary } from '@ds/react';

const meta = {
  title: 'Components/DashboardCardPrimary',
  component: DashboardCardPrimary,
  tags: ['autodocs'],
  args: { type: 'web', title: 'Receita', primaryValue: 'R$ 12.000' },
} satisfies Meta<typeof DashboardCardPrimary>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
