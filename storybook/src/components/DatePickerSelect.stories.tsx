import type { Meta, StoryObj } from '@storybook/react';
import { DatePickerSelect } from '@ds/react';

const meta = {
  title: 'Components/DatePickerSelect',
  component: DatePickerSelect,
  tags: ['autodocs'],
  args: { label: 'DatePickerSelect' },
} satisfies Meta<typeof DatePickerSelect>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
