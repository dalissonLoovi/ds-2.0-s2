import type { Meta, StoryObj } from '@storybook/react';
import { VehicleSummaryCard } from '@ds/react';

const meta = {
  title: 'Components/VehicleSummaryCard',
  component: VehicleSummaryCard,
  tags: ['autodocs'],
  args: { label: 'VehicleSummaryCard' },
} satisfies Meta<typeof VehicleSummaryCard>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
