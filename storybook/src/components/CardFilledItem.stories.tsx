import type { Meta, StoryObj } from '@storybook/react';
import { CardFilledItem } from '@ds/react';

const meta = {
  title: 'Components/CardFilledItem',
  component: CardFilledItem,
  tags: ['autodocs'],
  args: { label: 'CardFilledItem' },
} satisfies Meta<typeof CardFilledItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
