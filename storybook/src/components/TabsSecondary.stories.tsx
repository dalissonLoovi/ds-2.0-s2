import type { Meta, StoryObj } from '@storybook/react';
import { TabsSecondary } from '@ds/react';

const meta = {
  title: 'Components/TabsSecondary',
  component: TabsSecondary,
  tags: ['autodocs'],
  args: { itemCount: '3', platform: 'web' },
} satisfies Meta<typeof TabsSecondary>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
