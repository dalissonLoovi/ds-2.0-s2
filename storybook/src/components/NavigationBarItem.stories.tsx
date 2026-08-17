import type { Meta, StoryObj } from '@storybook/react';
import { NavigationBarItem } from '@ds/react';

const meta = {
  title: 'Components/NavigationBarItem',
  component: NavigationBarItem,
  tags: ['autodocs'],
  args: { label: 'Home', selected: true },
} satisfies Meta<typeof NavigationBarItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
