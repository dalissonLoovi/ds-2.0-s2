import type { Meta, StoryObj } from '@storybook/react';
import { CalendarDay } from '@ds/react';

const meta = {
  title: 'Components/CalendarDay',
  component: CalendarDay,
  tags: ['autodocs'],
  args: { day: '10', kind: 'default', state: 'default' },
} satisfies Meta<typeof CalendarDay>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
