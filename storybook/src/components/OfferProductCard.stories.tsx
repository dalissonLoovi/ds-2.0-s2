import type { Meta, StoryObj } from '@storybook/react';
import { OfferProductCard } from '@ds/react';

const meta = {
  title: 'Components/OfferProductCard',
  component: OfferProductCard,
  tags: ['autodocs'],
  args: { title: 'Title', ctaLabel: 'Label' },
} satisfies Meta<typeof OfferProductCard>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
