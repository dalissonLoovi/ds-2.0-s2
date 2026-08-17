import type { Meta, StoryObj } from '@storybook/react';
import { NavigationRailExpandedTree } from '@ds/react';

const meta = {
  title: 'Components/NavigationRailExpandedTree',
  component: NavigationRailExpandedTree,
  tags: ['autodocs'],
  args: { selectedItem: 'item-01', level: 'second-level' },
} satisfies Meta<typeof NavigationRailExpandedTree>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
