import type { Meta, StoryObj } from '@storybook/react';
import { TableSkeleton } from '@ds/react';

const meta = {
  title: 'Components/TableSkeleton',
  component: TableSkeleton,
  tags: ['autodocs'],
  args: { label: 'TableSkeleton' },
} satisfies Meta<typeof TableSkeleton>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
