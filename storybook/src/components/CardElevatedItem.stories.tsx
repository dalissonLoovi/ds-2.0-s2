import type { Meta, StoryObj } from '@storybook/react';
import { CardElevatedItem } from '@ds/react';

const meta = {
  title: 'Components/CardElevatedItem',
  component: CardElevatedItem,
  tags: ['autodocs'],
  args: { state: 'enabled' },
} satisfies Meta<typeof CardElevatedItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
