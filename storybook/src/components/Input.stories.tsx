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
  argTypes: {
    state: {
      control: 'select',
      options: ['default', 'hover', 'focus', 'error', 'disabled'],
    },
    content: {
      control: 'select',
      options: ['value', 'placeholder', 'label'],
    },
    appearance: {
      control: 'select',
      options: ['default', 'inverse'],
    },
  },
} satisfies Meta<typeof Input>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Placeholder: Story = {};
export const WithValue: Story = {
  args: { content: 'value', defaultValue: 'Value' },
  name: 'With Value',
};
export const RestingLabel: Story = { args: { content: 'label' } };
export const FocusEmpty: Story = { args: { content: 'label', state: 'focus' } };
export const Hover: Story = { args: { state: 'hover' } };
export const Focus: Story = { args: { state: 'focus', content: 'placeholder' } };
export const Error: Story = {
  args: { state: 'error', supportingText: 'Error message', trailingIcon: false },
};
export const ErrorWithTrailing: Story = {
  args: { state: 'error', supportingText: 'Error message', trailingIcon: true },
};
export const Disabled: Story = { args: { state: 'disabled' } };
export const WithIcons: Story = { args: { leadingIcon: true, trailingIcon: true, content: 'value', defaultValue: 'Value' } };
export const Inverse: Story = {
  args: { appearance: 'inverse' },
  decorators: [
    (Story) => (
      <div style={{ background: '#3A3345', padding: 24 }}>
        <Story />
      </div>
    ),
  ],
};
export const InverseFocus: Story = {
  args: { appearance: 'inverse', state: 'focus', content: 'placeholder' },
  decorators: [
    (Story) => (
      <div style={{ background: '#3A3345', padding: 24 }}>
        <Story />
      </div>
    ),
  ],
};
