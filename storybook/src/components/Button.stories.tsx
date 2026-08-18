import type { Meta, StoryObj } from '@storybook/react';
import { Button } from '@ds/react';

const meta = {
  title: 'Components/Button',
  component: Button,
  tags: ['autodocs'],
  args: {
    label: 'Label',
    variant: 'solid',
    size: 'md',
    intent: 'primary',
    showLabel: true,
    showIcon: false,
    showTrailingIcon: false,
    disabled: false,
    loading: false,
  },
  argTypes: {
    variant: { control: 'select', options: ['solid', 'outline', 'text'] },
    size: { control: 'select', options: ['sm', 'md', 'lg'] },
    intent: { control: 'select', options: ['primary', 'success', 'danger', 'secondary'] },
    state: {
      control: 'select',
      options: ['default', 'hover', 'focus', 'pressed', 'selected', 'loading'],
    },
  },
} satisfies Meta<typeof Button>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {};
export const Secondary: Story = { args: { intent: 'secondary' } };
export const Outline: Story = { args: { variant: 'outline' } };
export const Text: Story = { args: { variant: 'text' } };
export const Loading: Story = { args: { loading: true } };
export const IconOnly: Story = {
  args: { showLabel: false, showIcon: true, 'aria-label': 'Add' },
};
