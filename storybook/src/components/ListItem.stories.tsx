import type { Meta, StoryObj } from '@storybook/react';
import { ListItem } from '@ds/react';

const meta = {
  title: 'Components/ListItem',
  component: ListItem,
  tags: ['autodocs'],
  args: { condition: '3-line', headline: 'Headline' },
} satisfies Meta<typeof ListItem>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
export const PaymentMarkLeading: Story = {
  args: { leading: 'payment-mark', paymentMethodBrand: 'mastercard', headline: 'Mastercard •••• 4242' },
};
export const IllustrationLeading: Story = {
  args: {
    condition: '3-line',
    leading: 'illustration',
    leadingIllustrationAsset: 'sedan',
    headline: 'Sedan • ABC1D23',
  },
};
export const IllustrationTrailing: Story = {
  args: {
    condition: '3-line',
    trailing: 'illustration',
    trailingIllustrationAsset: 'van',
    headline: 'Veículo com ilustração',
  },
};
export const IllustrationBoth: Story = {
  args: {
    condition: '3-line',
    leading: 'illustration',
    trailing: 'illustration',
    leadingIllustrationAsset: 'suv',
    trailingIllustrationAsset: 'sedan',
    headline: 'SUV • XYZ9K88',
  },
};
export const IllustrationLeading1Line: Story = {
  args: {
    condition: '1-line',
    leading: 'illustration',
    leadingIllustrationAsset: 'sedan',
    headline: 'Sedan • ABC1D23',
    showSupportingText: false,
  },
};
