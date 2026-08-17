import type { Meta, StoryObj } from '@storybook/react';
import { ListItem } from '@ds/react';

const meta = {
  title: 'Components/ListItem',
  component: ListItem,
  tags: ['autodocs'],
  args: { label: 'ListItem' },
} satisfies Meta<typeof ListItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
