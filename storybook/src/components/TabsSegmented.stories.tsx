import type { Meta, StoryObj } from '@storybook/react';
import { TabsSegmented } from '@ds/react';

const meta = {
  title: 'Components/TabsSegmented',
  component: TabsSegmented,
  tags: ['autodocs'],
  args: { itemCount: '3', platform: 'web' },
} satisfies Meta<typeof TabsSegmented>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
