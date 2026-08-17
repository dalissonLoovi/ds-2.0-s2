import type { Meta, StoryObj } from '@storybook/react';
import { List } from '@ds/react';

const meta = {
  title: 'Components/List',
  component: List,
  tags: ['autodocs'],
  args: { label: 'List' },
} satisfies Meta<typeof List>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
