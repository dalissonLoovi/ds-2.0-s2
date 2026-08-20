import type { Meta, StoryObj } from '@storybook/react';
import { Pagination } from '@ds/react';

const meta = {
  title: 'Components/Pagination',
  component: Pagination,
  tags: ['autodocs'],
  args: { position: 'start', size: 'lg' },
} satisfies Meta<typeof Pagination>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
