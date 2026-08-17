import type { Meta, StoryObj } from '@storybook/react';
import { InputSelect } from '@ds/react';

const meta = {
  title: 'Components/InputSelect',
  component: InputSelect,
  tags: ['autodocs'],
  args: { label: 'City', content: 'placeholder' },
} satisfies Meta<typeof InputSelect>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
