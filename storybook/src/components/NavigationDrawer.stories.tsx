import type { Meta, StoryObj } from '@storybook/react';
import { NavigationDrawer } from '@ds/react';

const meta = {
  title: 'Components/NavigationDrawer',
  component: NavigationDrawer,
  tags: ['autodocs'],
  args: { heading: 'Menu', itemCount: '4' },
} satisfies Meta<typeof NavigationDrawer>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
