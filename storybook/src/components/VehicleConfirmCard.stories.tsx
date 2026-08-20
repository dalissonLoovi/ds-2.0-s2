import type { Meta, StoryObj } from '@storybook/react';
import { VehicleConfirmCard } from '@ds/react';

const meta = {
  title: 'Components/VehicleConfirmCard',
  component: VehicleConfirmCard,
  tags: ['autodocs'],
  args: { plate: 'ABC1D23', brandModel: 'Brand Model' },
} satisfies Meta<typeof VehicleConfirmCard>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
