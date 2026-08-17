import type { Meta, StoryObj } from '@storybook/react';
import { BottomSheet } from '@ds/react';

const meta = {
  title: 'Components/BottomSheet',
  component: BottomSheet,
  tags: ['autodocs'],
  args: { label: 'BottomSheet' },
} satisfies Meta<typeof BottomSheet>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
