import type { Meta, StoryObj } from '@storybook/react';
import { Table } from '@ds/react';

const meta = {
  title: 'Components/Table',
  component: Table,
  tags: ['autodocs'],
  args: { label: 'Table' },
} satisfies Meta<typeof Table>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
