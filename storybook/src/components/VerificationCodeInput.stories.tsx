import type { Meta, StoryObj } from '@storybook/react';
import { VerificationCodeInput } from '@ds/react';

const meta = {
  title: 'Components/VerificationCodeInput',
  component: VerificationCodeInput,
  tags: ['autodocs'],
  args: { label: 'VerificationCodeInput' },
} satisfies Meta<typeof VerificationCodeInput>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
