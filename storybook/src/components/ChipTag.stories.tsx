import type { Meta, StoryObj } from '@storybook/react';
import { ChipTag } from '@ds/react';

const meta = {
  title: 'Components/ChipTag',
  component: ChipTag,
  tags: ['autodocs'],
  args: {
    label: 'Ativo',
    intent: 'success',
    emphasis: 'soft',
    size: 'md',
    width: 'hug',
    showLeadingIcon: true,
  },
} satisfies Meta<typeof ChipTag>;

export default meta;
type Story = StoryObj<typeof meta>;

export const SoftSuccess: Story = {};
export const StrongOutline: Story = {
  args: { emphasis: 'strong', intent: 'outline', label: 'Tag', showLeadingIcon: false },
};
