import type { Meta, StoryObj } from '@storybook/react';
import { Input } from '@ds/react';

const meta = {
  title: 'Components/Input',
  component: Input,
  tags: ['autodocs'],
  args: {
    label: 'Label',
    supportingText: 'Supporting text',
    showSupportingText: true,
    state: 'default',
    content: 'placeholder',
    appearance: 'default',
    leadingIcon: false,
    trailingIcon: false,
  },
} satisfies Meta<typeof Input>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Placeholder: Story = {};
export const WithValue: Story = { args: { content: 'value', defaultValue: 'Value' } };
export const Error: Story = { args: { state: 'error', supportingText: 'Error message' } };
export const WithIcons: Story = { args: { leadingIcon: true, trailingIcon: true } };
