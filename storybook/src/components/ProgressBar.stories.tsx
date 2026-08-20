import type { Meta, StoryObj } from '@storybook/react';
import { ProgressBar } from '@ds/react';

const meta = {
  title: 'Components/ProgressBar',
  component: ProgressBar,
  tags: ['autodocs'],
  args: { progress: 40, showValue: true, size: 'md' },
} satisfies Meta<typeof ProgressBar>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
