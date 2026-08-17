import type { Meta, StoryObj } from '@storybook/react';
import { SelectCountry } from '@ds/react';

const meta = {
  title: 'Components/SelectCountry',
  component: SelectCountry,
  tags: ['autodocs'],
  args: { label: 'SelectCountry' },
} satisfies Meta<typeof SelectCountry>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
