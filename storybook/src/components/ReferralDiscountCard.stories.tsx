import type { Meta, StoryObj } from '@storybook/react';
import { ReferralDiscountCard } from '@ds/react';

const meta = {
  title: 'Components/ReferralDiscountCard',
  component: ReferralDiscountCard,
  tags: ['autodocs'],
  args: { label: 'ReferralDiscountCard' },
} satisfies Meta<typeof ReferralDiscountCard>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
