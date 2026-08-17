import type { Meta, StoryObj } from '@storybook/react';
import { Avatar } from '@ds/react';

const meta = {
  title: 'Components/Avatar',
  component: Avatar,
  tags: ['autodocs'],
  args: { label: 'Avatar' },
} satisfies Meta<typeof Avatar>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
