import type { Meta, StoryObj } from '@storybook/react';
import { Keyboard } from '@ds/react';

const meta = {
  title: 'Components/Keyboard',
  component: Keyboard,
  tags: ['autodocs'],
  args: { label: 'Keyboard' },
} satisfies Meta<typeof Keyboard>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
