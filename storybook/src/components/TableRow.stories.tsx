import type { Meta, StoryObj } from '@storybook/react';
import { TableRow } from '@ds/react';

const meta = {
  title: 'Components/TableRow',
  component: TableRow,
  tags: ['autodocs'],
  args: { type: 'body', cellCount: '3' },
} satisfies Meta<typeof TableRow>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
