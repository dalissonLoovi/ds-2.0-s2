import type { Meta, StoryObj } from '@storybook/react';
import { SliderBaseItem } from '@ds/react';

const meta = {
  title: 'Components/SliderBaseItem',
  component: SliderBaseItem,
  tags: ['autodocs'],
  args: { label: 'Label' },
} satisfies Meta<typeof SliderBaseItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
