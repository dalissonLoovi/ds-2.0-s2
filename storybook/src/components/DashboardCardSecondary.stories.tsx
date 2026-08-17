import type { Meta, StoryObj } from '@storybook/react';
import { DashboardCardSecondary } from '@ds/react';

const meta = {
  title: 'Components/DashboardCardSecondary',
  component: DashboardCardSecondary,
  tags: ['autodocs'],
  args: { label: 'DashboardCardSecondary' },
} satisfies Meta<typeof DashboardCardSecondary>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
