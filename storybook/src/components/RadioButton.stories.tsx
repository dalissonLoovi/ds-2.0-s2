import type { Meta, StoryObj } from '@storybook/react';
import { RadioButton } from '@ds/react';

const meta = {
  title: 'Components/RadioButton',
  component: RadioButton,
  tags: ['autodocs'],
  args: { label: 'Option', name: 'demo' },
} satisfies Meta<typeof RadioButton>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
/** disabled + checked: 4px ring text/placeholder. */
export const DisabledChecked: Story = {
  args: { disabled: true, checked: true, readOnly: true, label: 'Disabled checked' },
};
/** disabled + unchecked: 2px ring color/border/2. */
export const DisabledUnchecked: Story = {
  args: { disabled: true, checked: false, readOnly: true, label: 'Disabled unchecked' },
};
