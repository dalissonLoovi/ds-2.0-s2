import type { Meta, StoryObj } from '@storybook/react';
import { ChipClickable } from '@ds/react';

const meta = {
  title: 'Components/ChipClickable',
  component: ChipClickable,
  tags: ['autodocs'],
  args: {
    label: 'Adicionar veículo',
    intent: 'soft',
    size: 'md',
    showLeadingIcon: true,
    leadingIcon: 'plus-outline',
  },
} satisfies Meta<typeof ChipClickable>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Soft: Story = {};
export const Selected: Story = { args: { selected: true, intent: 'outline', label: 'Filter' } };
