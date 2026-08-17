import type { Meta, StoryObj } from '@storybook/react';
import { ListItemStateLayer } from '@ds/react';

const meta = {
  title: 'Components/ListItemStateLayer',
  component: ListItemStateLayer,
  tags: ['autodocs'],
  args: { label: 'ListItemStateLayer' },
} satisfies Meta<typeof ListItemStateLayer>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
