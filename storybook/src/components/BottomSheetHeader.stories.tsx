import type { Meta, StoryObj } from '@storybook/react';
import { BottomSheetHeader } from '@ds/react';

const meta = {
  title: 'Components/BottomSheetHeader',
  component: BottomSheetHeader,
  tags: ['autodocs'],
  args: { label: 'BottomSheetHeader' },
} satisfies Meta<typeof BottomSheetHeader>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
