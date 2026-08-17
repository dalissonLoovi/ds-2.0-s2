import type { Meta, StoryObj } from '@storybook/react';
import { NavigationRailCompactItem } from '@ds/react';

const meta = {
  title: 'Components/NavigationRailCompactItem',
  component: NavigationRailCompactItem,
  tags: ['autodocs'],
  args: { label: 'NavigationRailCompactItem' },
} satisfies Meta<typeof NavigationRailCompactItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
