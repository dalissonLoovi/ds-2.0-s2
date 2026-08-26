import type { Meta, StoryObj } from '@storybook/react';
import { InputNumber } from '@ds/react';

const meta = {
  title: 'Components/InputNumber',
  component: InputNumber,
  tags: ['autodocs'],
  args: { label: 'Phone', showSelectCountry: true },
} satisfies Meta<typeof InputNumber>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Phone: Story = {};

export const CreditCardVisa: Story = {
  args: {
    label: 'Número do cartão',
    placeholder: '0000 0000 0000 0000',
    showSelectCountry: false,
    showPaymentMethodMark: true,
    paymentMethodBrand: 'visa',
    defaultValue: '4111 1111 1111 1111',
    content: 'value',
  },
};

export const CreditCardMastercard: Story = {
  args: {
    label: 'Número do cartão',
    showSelectCountry: false,
    showPaymentMethodMark: true,
    paymentMethodBrand: 'mastercard',
    defaultValue: '5555 5555 5555 4444',
    content: 'value',
  },
};

export const CreditCardError: Story = {
  args: {
    label: 'Número do cartão',
    state: 'error',
    showSupportingText: true,
    supportingText: 'Número inválido',
    showSelectCountry: false,
    showPaymentMethodMark: true,
    paymentMethodBrand: 'visa',
    trailingIcon: true,
    defaultValue: '4111 1111 1111 1110',
    content: 'value',
  },
};
