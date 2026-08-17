import type { Meta, StoryObj } from '@storybook/react';
import { InputDatePicker } from '@ds/react';

const meta = {
  title: 'Components/InputDatePicker',
  component: InputDatePicker,
  tags: ['autodocs'],
  args: { label: 'InputDatePicker' },
} satisfies Meta<typeof InputDatePicker>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
