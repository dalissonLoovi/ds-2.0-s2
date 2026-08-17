import type { Meta, StoryObj } from '@storybook/react';
import { SliderRightRail } from '@ds/react';

const meta = {
  title: 'Components/SliderRightRail',
  component: SliderRightRail,
  tags: ['autodocs'],
  args: { label: 'SliderRightRail' },
} satisfies Meta<typeof SliderRightRail>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
