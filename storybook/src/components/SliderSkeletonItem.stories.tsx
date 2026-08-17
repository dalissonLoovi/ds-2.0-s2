import type { Meta, StoryObj } from '@storybook/react';
import { SliderSkeletonItem } from '@ds/react';

const meta = {
  title: 'Components/SliderSkeletonItem',
  component: SliderSkeletonItem,
  tags: ['autodocs'],
  args: {},
} satisfies Meta<typeof SliderSkeletonItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
