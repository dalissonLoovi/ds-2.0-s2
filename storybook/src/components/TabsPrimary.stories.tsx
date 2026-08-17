import type { Meta, StoryObj } from '@storybook/react';
import { TabsPrimary } from '@ds/react';

const meta = {
  title: 'Components/TabsPrimary',
  component: TabsPrimary,
  tags: ['autodocs'],
  args: { itemCount: '3', platform: 'web' },
} satisfies Meta<typeof TabsPrimary>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
