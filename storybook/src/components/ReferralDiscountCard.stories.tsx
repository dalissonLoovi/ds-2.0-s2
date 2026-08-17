import type { Meta, StoryObj } from '@storybook/react';
import { ReferralDiscountCard } from '@ds/react/draft';

const meta = {
  title: 'Draft/ReferralDiscountCard',
  component: ReferralDiscountCard,
  tags: ['autodocs'],
  args: { label: 'ReferralDiscountCard' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof ReferralDiscountCard>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
