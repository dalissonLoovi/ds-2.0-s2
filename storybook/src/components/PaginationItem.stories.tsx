import type { Meta, StoryObj } from '@storybook/react';
import { PaginationItem } from '@ds/react';

const meta = {
  title: 'Components/PaginationItem',
  component: PaginationItem,
  tags: ['autodocs'],
  args: { content: 'number', label: '1' },
} satisfies Meta<typeof PaginationItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
