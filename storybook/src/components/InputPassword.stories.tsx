import type { Meta, StoryObj } from '@storybook/react';
import { InputPassword } from '@ds/react';

const meta = {
  title: 'Components/InputPassword',
  component: InputPassword,
  tags: ['autodocs'],
  args: { label: 'Password' },
} satisfies Meta<typeof InputPassword>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
