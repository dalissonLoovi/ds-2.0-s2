import type { Meta, StoryObj } from '@storybook/react';
import { TableSkeleton } from '@ds/react';

const meta = {
  title: 'Components/TableSkeleton',
  component: TableSkeleton,
  tags: ['autodocs'],
  args: { empty: false },
} satisfies Meta<typeof TableSkeleton>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
