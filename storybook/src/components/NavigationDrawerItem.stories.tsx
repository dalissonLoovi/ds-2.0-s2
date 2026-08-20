import type { Meta, StoryObj } from '@storybook/react';
import { NavigationDrawerItem } from '@ds/react';

const meta = {
  title: 'Components/NavigationDrawerItem',
  component: NavigationDrawerItem,
  tags: ['autodocs'],
  args: { label: 'Inbox', selected: true },
} satisfies Meta<typeof NavigationDrawerItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
