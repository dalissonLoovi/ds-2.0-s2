import type { Meta, StoryObj } from '@storybook/react';
import { Badge } from '@ds/react';

const meta = {
  title: 'Components/Badge',
  component: Badge,
  tags: ['autodocs'],
  args: { content: 'count', count: 3, size: 'sm' },
} satisfies Meta<typeof Badge>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
