import type { Meta, StoryObj } from '@storybook/react';
import { Calendar } from '@ds/react';

const meta = {
  title: 'Components/Calendar',
  component: Calendar,
  tags: ['autodocs'],
  args: { mode: 'simple', platform: 'mobile' },
} satisfies Meta<typeof Calendar>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
