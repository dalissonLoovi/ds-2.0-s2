import type { Meta, StoryObj } from '@storybook/react';
import { QuickAccessTile } from '@ds/react';

const meta = {
  title: 'Components/QuickAccessTile',
  component: QuickAccessTile,
  tags: ['autodocs'],
  args: { label: 'Label', state: 'default' },
} satisfies Meta<typeof QuickAccessTile>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
