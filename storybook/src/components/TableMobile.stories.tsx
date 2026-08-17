import type { Meta, StoryObj } from '@storybook/react';
import { TableMobile } from '@ds/react';

const meta = {
  title: 'Components/TableMobile',
  component: TableMobile,
  tags: ['autodocs'],
  args: { columnCount: '4' },
} satisfies Meta<typeof TableMobile>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
