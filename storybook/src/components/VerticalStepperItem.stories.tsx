import type { Meta, StoryObj } from '@storybook/react';
import { VerticalStepperItem } from '@ds/react';

const meta = {
  title: 'Components/VerticalStepperItem',
  component: VerticalStepperItem,
  tags: ['autodocs'],
  args: { status: 'current', headline: 'Endereço' },
} satisfies Meta<typeof VerticalStepperItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
