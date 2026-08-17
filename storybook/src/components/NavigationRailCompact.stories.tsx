import type { Meta, StoryObj } from '@storybook/react';
import { NavigationRailCompact } from '@ds/react';

const meta = {
  title: 'Components/NavigationRailCompact',
  component: NavigationRailCompact,
  tags: ['autodocs'],
  args: { label: 'NavigationRailCompact' },
} satisfies Meta<typeof NavigationRailCompact>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
