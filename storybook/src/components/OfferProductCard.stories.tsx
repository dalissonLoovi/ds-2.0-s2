import type { Meta, StoryObj } from '@storybook/react';
import { OfferProductCard } from '@ds/react/draft';

const meta = {
  title: 'Draft/OfferProductCard',
  component: OfferProductCard,
  tags: ['autodocs'],
  args: { label: 'OfferProductCard' },
  parameters: {
    docs: {
      description: {
        component:
          'Scaffold only (reactScaffold). Not DoD — use seed docs until polished. Import from `@ds/react/draft`.',
      },
    },
  },
} satisfies Meta<typeof OfferProductCard>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
