import type { Meta, StoryObj } from '@storybook/react';
import { LoadingSpinner } from '@ds/react';

const meta = {
  title: 'Components/LoadingSpinner',
  component: LoadingSpinner,
  tags: ['autodocs'],
  args: { size: 'md', label: 'Loading' },
} satisfies Meta<typeof LoadingSpinner>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
