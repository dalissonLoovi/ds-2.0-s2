import type { Meta, StoryObj } from '@storybook/react';
import { SliderLeftRail } from '@ds/react';

const meta = {
  title: 'Components/SliderLeftRail',
  component: SliderLeftRail,
  tags: ['autodocs'],
  args: { label: 'SliderLeftRail' },
} satisfies Meta<typeof SliderLeftRail>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
