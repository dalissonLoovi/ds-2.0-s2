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
    appearance: { control: 'select', options: ['default', 'inverse'] },
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
export const Loading: Story = {
  args: { loading: true, label: 'Saving', showIcon: true, showTrailingIcon: true },
};
export const TrailingIcon: Story = {
  args: { showTrailingIcon: true, label: 'Continue' },
};
export const IconOnly: Story = {
  args: { showLabel: false, showIcon: true, 'aria-label': 'Add' },
};

/** appearance=inverse — outline|text + intent=primary on dark/brand surfaces (ignored on solid). */
export const Inverse: Story = {
  args: { appearance: 'inverse', variant: 'outline', showIcon: true },
  render: (args) => (
    <div
      style={{
        display: 'flex',
        flexWrap: 'wrap',
        gap: 'var(--spacing-200, 12px)',
        alignItems: 'center',
        padding: 'var(--spacing-300, 24px)',
        borderRadius: 'var(--border-radius-300, 12px)',
        background: 'var(--color-background-surface-inverse-3)',
      }}
    >
      <Button {...args} variant="outline" />
      <Button {...args} variant="outline" state="pressed" />
      <Button {...args} variant="outline" disabled />
      <Button {...args} variant="text" />
      <Button {...args} variant="text" state="pressed" />
      <Button {...args} variant="text" disabled />
    </div>
  ),
};

export const SolidSuccess: Story = { args: { intent: 'success' } };

/** outline|text danger: label text/danger (AA); icons keep color/actions/danger. */
export const OutlineDanger: Story = {
  args: { variant: 'outline', intent: 'danger', showIcon: true },
};
