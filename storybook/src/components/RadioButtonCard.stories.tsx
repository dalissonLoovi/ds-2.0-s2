import type { Meta, StoryObj } from '@storybook/react';
import { RadioButtonCard } from '@ds/react';

const meta = {
  title: 'Components/RadioButtonCard',
  component: RadioButtonCard,
  tags: ['autodocs'],
  args: { label: 'Plan', description: 'Includes support', name: 'plan' },
} satisfies Meta<typeof RadioButtonCard>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
