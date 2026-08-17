import type { Meta, StoryObj } from '@storybook/react';
import { InputNumber } from '@ds/react';

const meta = {
  title: 'Components/InputNumber',
  component: InputNumber,
  tags: ['autodocs'],
  args: { label: 'InputNumber' },
} satisfies Meta<typeof InputNumber>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
