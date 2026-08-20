import type { Meta, StoryObj } from '@storybook/react';
import { Slider } from '@ds/react';

const meta = {
  title: 'Components/Slider',
  component: Slider,
  tags: ['autodocs'],
  args: { status: 'enabled', label: 'Label' },
} satisfies Meta<typeof Slider>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
