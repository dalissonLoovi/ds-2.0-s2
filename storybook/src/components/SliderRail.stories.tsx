import type { Meta, StoryObj } from '@storybook/react';
import { SliderRail } from '@ds/react';

const meta = {
  title: 'Components/SliderRail',
  component: SliderRail,
  tags: ['autodocs'],
  args: {},
} satisfies Meta<typeof SliderRail>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
