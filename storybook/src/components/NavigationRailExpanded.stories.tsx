import type { Meta, StoryObj } from '@storybook/react';
import { NavigationRailExpanded } from '@ds/react';

const meta = {
  title: 'Components/NavigationRailExpanded',
  component: NavigationRailExpanded,
  tags: ['autodocs'],
  args: { itemCount: '4', showMenu: true },
} satisfies Meta<typeof NavigationRailExpanded>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
