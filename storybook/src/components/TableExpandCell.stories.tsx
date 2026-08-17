import type { Meta, StoryObj } from '@storybook/react';
import { TableExpandCell } from '@ds/react';

const meta = {
  title: 'Components/TableExpandCell',
  component: TableExpandCell,
  tags: ['autodocs'],
  args: { type: 'body' },
} satisfies Meta<typeof TableExpandCell>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
