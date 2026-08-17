import type { Meta, StoryObj } from '@storybook/react';
import { TableCell } from '@ds/react';

const meta = {
  title: 'Components/TableCell',
  component: TableCell,
  tags: ['autodocs'],
  args: { label: 'TableCell' },
} satisfies Meta<typeof TableCell>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
