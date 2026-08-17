import type { Meta, StoryObj } from '@storybook/react';
import { CalendarPeriodNav } from '@ds/react';

const meta = {
  title: 'Components/CalendarPeriodNav',
  component: CalendarPeriodNav,
  tags: ['autodocs'],
  args: { label: 'CalendarPeriodNav' },
} satisfies Meta<typeof CalendarPeriodNav>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
