import type { Meta, StoryObj } from '@storybook/react';
import { CardOutlinedItem } from '@ds/react';

const meta = {
  title: 'Components/CardOutlinedItem',
  component: CardOutlinedItem,
  tags: ['autodocs'],
  args: { state: 'enabled' },
} satisfies Meta<typeof CardOutlinedItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
