import type { Meta, StoryObj } from '@storybook/react';
import { RadioButton } from '@ds/react';

const meta = {
  title: 'Components/RadioButton',
  component: RadioButton,
  tags: ['autodocs'],
  args: { label: 'RadioButton' },
} satisfies Meta<typeof RadioButton>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
