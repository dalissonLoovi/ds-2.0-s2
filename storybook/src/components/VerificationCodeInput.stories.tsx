import type { Meta, StoryObj } from '@storybook/react';
import { VerificationCodeInput } from '@ds/react/draft';

const meta = {
  title: 'Draft/VerificationCodeInput',
  component: VerificationCodeInput,
  tags: ['autodocs'],
  args: { label: 'VerificationCodeInput' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof VerificationCodeInput>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
