import type { Meta, StoryObj } from '@storybook/react';
import { BottomSheetCheckItem } from '@ds/react';

const meta = {
  title: 'Components/BottomSheetCheckItem',
  component: BottomSheetCheckItem,
  tags: ['autodocs'],
  args: { label: 'BottomSheetCheckItem' },
} satisfies Meta<typeof BottomSheetCheckItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
