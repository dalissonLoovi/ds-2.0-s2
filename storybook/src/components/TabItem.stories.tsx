import type { Meta, StoryObj } from '@storybook/react';
import { TabItem } from '@ds/react';

const meta = {
  title: 'Components/TabItem',
  component: TabItem,
  tags: ['autodocs'],
  args: { label: 'TabItem' },
} satisfies Meta<typeof TabItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
