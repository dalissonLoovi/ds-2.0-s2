import type { Meta, StoryObj } from '@storybook/react';
import { ListItemLeadingMonogram } from '@ds/react';

const meta = {
  title: 'Components/ListItemLeadingMonogram',
  component: ListItemLeadingMonogram,
  tags: ['autodocs'],
  args: { initial: 'A' },
} satisfies Meta<typeof ListItemLeadingMonogram>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
