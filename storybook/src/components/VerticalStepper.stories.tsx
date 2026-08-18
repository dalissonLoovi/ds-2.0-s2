import type { Meta, StoryObj } from '@storybook/react';
import { VerticalStepper } from '@ds/react';

const meta = {
  title: 'Components/VerticalStepper',
  component: VerticalStepper,
  tags: ['autodocs'],
  args: {},
} satisfies Meta<typeof VerticalStepper>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
