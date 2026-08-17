import type { Meta, StoryObj } from '@storybook/react';
import { NavigationRailExpandedItem } from '@ds/react';

const meta = {
  title: 'Components/NavigationRailExpandedItem',
  component: NavigationRailExpandedItem,
  tags: ['autodocs'],
  args: { label: 'NavigationRailExpandedItem' },
} satisfies Meta<typeof NavigationRailExpandedItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
