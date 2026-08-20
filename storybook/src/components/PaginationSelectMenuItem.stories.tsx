import type { Meta, StoryObj } from '@storybook/react';
import { PaginationSelectMenuItem } from '@ds/react';

const meta = {
  title: 'Components/PaginationSelectMenuItem',
  component: PaginationSelectMenuItem,
  tags: ['autodocs'],
  args: { label: '10', state: 'default' },
} satisfies Meta<typeof PaginationSelectMenuItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
