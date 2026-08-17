import type { Meta, StoryObj } from '@storybook/react';
import { VerificationCodeInputItem } from '@ds/react/draft';

const meta = {
  title: 'Draft/VerificationCodeInputItem',
  component: VerificationCodeInputItem,
  tags: ['autodocs'],
  args: { label: 'VerificationCodeInputItem' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof VerificationCodeInputItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
