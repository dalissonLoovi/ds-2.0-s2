import type { Meta, StoryObj } from '@storybook/react';
import { InputTextArea } from '@ds/react';

const meta = {
  title: 'Components/InputTextArea',
  component: InputTextArea,
  tags: ['autodocs'],
  args: { label: 'Message', showCount: true },
} satisfies Meta<typeof InputTextArea>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
