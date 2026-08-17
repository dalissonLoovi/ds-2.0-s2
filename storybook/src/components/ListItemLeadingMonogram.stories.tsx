import type { Meta, StoryObj } from '@storybook/react';
import { ListItemLeadingMonogram } from '@ds/react';

const meta = {
  title: 'Components/ListItemLeadingMonogram',
  component: ListItemLeadingMonogram,
  tags: ['autodocs'],
  args: { label: 'ListItemLeadingMonogram' },
} satisfies Meta<typeof ListItemLeadingMonogram>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
