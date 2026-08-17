import type { Meta, StoryObj } from '@storybook/react';
import { DatePickerSelectItem } from '@ds/react';

const meta = {
  title: 'Components/DatePickerSelectItem',
  component: DatePickerSelectItem,
  tags: ['autodocs'],
  args: { unit: 'day', value: '01' },
} satisfies Meta<typeof DatePickerSelectItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
