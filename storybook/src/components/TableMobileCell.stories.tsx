import type { Meta, StoryObj } from '@storybook/react';
import { TableMobileCell } from '@ds/react';

const meta = {
  title: 'Components/TableMobileCell',
  component: TableMobileCell,
  tags: ['autodocs'],
  args: { type: 'primary', label: 'Title' },
} satisfies Meta<typeof TableMobileCell>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
