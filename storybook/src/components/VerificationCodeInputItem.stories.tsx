import type { Meta, StoryObj } from '@storybook/react';
import { VerificationCodeInputItem } from '@ds/react';

const meta = {
  title: 'Components/VerificationCodeInputItem',
  component: VerificationCodeInputItem,
  tags: ['autodocs'],
  args: { label: 'VerificationCodeInputItem' },
} satisfies Meta<typeof VerificationCodeInputItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
