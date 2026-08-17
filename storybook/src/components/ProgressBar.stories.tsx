import type { Meta, StoryObj } from '@storybook/react';
import { ProgressBar } from '@ds/react';

const meta = {
  title: 'Components/ProgressBar',
  component: ProgressBar,
  tags: ['autodocs'],
  args: { label: 'ProgressBar' },
} satisfies Meta<typeof ProgressBar>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
