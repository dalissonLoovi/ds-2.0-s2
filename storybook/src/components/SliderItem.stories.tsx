import type { Meta, StoryObj } from '@storybook/react';
import { SliderItem } from '@ds/react';

const meta = {
  title: 'Components/SliderItem',
  component: SliderItem,
  tags: ['autodocs'],
  args: { active: false },
} satisfies Meta<typeof SliderItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
